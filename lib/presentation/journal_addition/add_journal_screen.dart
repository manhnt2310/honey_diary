import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../diary/presentation/diary_screen.dart';

class AddJournalScreen extends StatefulWidget {
  final Journal? journal;
  const AddJournalScreen({super.key, this.journal});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> _selectedImages = [];

  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.journal != null) {
      _titleController.text = widget.journal!.title;
      _selectedDate = widget.journal!.date;
      _contentController.text = widget.journal!.content ?? '';
      _selectedImages = widget.journal!.imagePaths;
    }
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

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((xfile) => xfile.path));
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (ctx) => Container(
            height: 250,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    initialDateTime: _selectedDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (dateTime) {
                      setState(() {
                        _selectedDate = dateTime;
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Color.fromARGB(255, 22, 185, 254)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _saveJournal() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title!')));
      return;
    }

    Journal newJournal;
    if (widget.journal != null) {
      // Edit mode: tạo đối tượng mới với id được giữ lại
      newJournal = Journal(
        id: widget.journal!.id,
        title: _titleController.text.trim(),
        date: _selectedDate,
        imagePaths: _selectedImages,
        content: _contentController.text.trim(),
      );
    } else {
      // Thêm mới
      newJournal = Journal(
        title: _titleController.text.trim(),
        date: _selectedDate,
        imagePaths: _selectedImages,
        content: _contentController.text.trim(),
      );
    }

    Navigator.pop(context, newJournal);
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat("d/M/yyyy").format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
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
        title: const Text(
          'Add Diary',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: _saveJournal,
            icon: const Icon(Icons.check, color: Colors.white, size: 27),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(
                Icons.photo_library,
                color: Color.fromARGB(255, 42, 191, 255),
                size: 20,
              ),
              label: const Text(
                'Select Photos',
                style: TextStyle(
                  color: Color.fromARGB(255, 42, 191, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedImages.isNotEmpty) ...[
              SizedBox(
                height: 280,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1, // đảm bảo ảnh hiển thị hình vuông
                          child: Image.file(
                            File(_selectedImages[index]),
                            fit: BoxFit.cover,
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
                children: List.generate(_selectedImages.length, (index) {
                  final isActive = index == _currentPage;
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
              const SizedBox(height: 15),
            ],
            // Hiển thị TextField cho title luôn, bất kể có ảnh hay không
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title...',
                hintText: 'Enter title...',
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Content...',
                hintText: 'Write your diary here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Day'),
                  controller: TextEditingController(text: dateString),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
