import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../anniversary_addition/add_anniversary_screen.dart';
import '../diary/presentation/diary_screen.dart';

class AnniversaryDetailScreen extends StatefulWidget {
  final Anniversary anniversary;
  const AnniversaryDetailScreen({super.key, required this.anniversary});

  @override
  State<AnniversaryDetailScreen> createState() =>
      _AnniversaryDetailScreenState();
}

class _AnniversaryDetailScreenState extends State<AnniversaryDetailScreen> {
  late Anniversary currentAnn;
  late List<String> imagePaths;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    currentAnn = widget.anniversary;
    imagePaths = currentAnn.imagePaths;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get _formattedDate {
    return DateFormat("dd/MM/yyyy").format(currentAnn.date);
  }

  Future<void> _editAnniversary() async {
    final updated = await Navigator.push<Anniversary>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAnniversaryScreen(anniversary: currentAnn),
      ),
    );
    if (updated != null) {
      setState(() {
        currentAnn = updated;
        imagePaths = currentAnn.imagePaths;
      });
    }
  }

  Future<void> _deleteAnniversary() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this diary entry?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, 'deleted');
    }
  }

  void _popWithUpdatedAnniversary() {
    Navigator.pop(context, currentAnn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Diary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 22, 185, 254),
                Color.fromARGB(255, 111, 207, 255),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: _editAnniversary,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _deleteAnniversary,
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          _popWithUpdatedAnniversary();
          return false;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imagePaths.isNotEmpty)
                Column(
                  children: [
                    SizedBox(
                      height: 290,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: imagePaths.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 1, // ép ảnh thành hình vuông
                                child: Image.file(
                                  File(imagePaths[index]),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imagePaths.length, (index) {
                        bool isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 10 : 6,
                          height: isActive ? 10 : 6,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.pinkAccent : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ],
                ),

              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .1),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                currentAnn.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (currentAnn.content != null && currentAnn.content!.isNotEmpty)
                Text(currentAnn.content!, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _popWithUpdatedAnniversary,
        backgroundColor: Colors.pinkAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
