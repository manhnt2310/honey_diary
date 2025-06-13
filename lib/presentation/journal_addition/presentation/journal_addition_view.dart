// add_journal_view.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../bloc/journal_addition_bloc.dart';
import '../bloc/journal_addition_event.dart';
import '../bloc/journal_addition_state.dart';

class JournalAdditionView extends StatefulWidget {
  const JournalAdditionView({super.key});

  @override
  State<JournalAdditionView> createState() => _JournalAdditionViewState();
}

class _JournalAdditionViewState extends State<JournalAdditionView> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      final paths = picked.map((f) => f.path).toList();
      context.read<JournalAdditionBloc>().add(ImagesChanged(paths));
      // Reset carousel to first page
      setState(() {
        _currentPage = 0;
      });
      _pageController.jumpToPage(0);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final bloc = context.read<JournalAdditionBloc>();
    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => Container(
            height: 250,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    initialDateTime: bloc.state.date,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (d) => bloc.add(DateChanged(d)),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
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

  void _save(BuildContext context) =>
      context.read<JournalAdditionBloc>().add(SaveJournal());

  @override
  Widget build(BuildContext context) {
    return BlocListener<JournalAdditionBloc, JournalAdditionState>(
      listener: (context, state) {
        if (state.showError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a title!')),
          );
        }
        final orig = state.journal;
        if (!state.showError && orig != null) Navigator.pop(context, orig);
      },
      child: BlocBuilder<JournalAdditionBloc, JournalAdditionState>(
        builder: (context, state) {
          final dateStr = DateFormat('d/M/yyyy').format(state.date);
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
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  onPressed: () => _save(context),
                  icon: const Icon(Icons.check, color: Colors.white, size: 27),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImages(context),
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
                  if (state.imagePaths.isNotEmpty) ...[
                    SizedBox(
                      height: 280,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: state.imagePaths.length,
                        onPageChanged:
                            (index) => setState(() => _currentPage = index),
                        itemBuilder:
                            (ctx, i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.file(
                                    File(state.imagePaths[i]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        state.imagePaths.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 10 : 6,
                          height: i == _currentPage ? 10 : 6,
                          decoration: BoxDecoration(
                            color:
                                i == _currentPage
                                    ? Colors.pinkAccent
                                    : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  TextField(
                    onChanged:
                        (v) => context.read<JournalAdditionBloc>().add(
                          TitleChanged(v),
                        ),
                    controller: TextEditingController(text: state.title),
                    decoration: const InputDecoration(
                      labelText: 'Title...',
                      hintText: 'Enter title...',
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    onChanged:
                        (v) => context.read<JournalAdditionBloc>().add(
                          DescriptionChanged(v),
                        ),
                    controller: TextEditingController(text: state.description),
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
                        controller: TextEditingController(text: dateStr),
                        decoration: const InputDecoration(labelText: 'Day'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
