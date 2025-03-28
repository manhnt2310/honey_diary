// file: add_anniversary_screen.dart

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'diary_screen.dart';

class AddAnniversaryScreen extends StatefulWidget {
  final Anniversary? anniversary;
  const AddAnniversaryScreen({super.key, this.anniversary});

  @override
  State<AddAnniversaryScreen> createState() => _AddAnniversaryScreenState();
}

class _AddAnniversaryScreenState extends State<AddAnniversaryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController =
      TextEditingController(); // Controller cho content
  DateTime _selectedDate = DateTime.now();
  String? _selectedImagePath; // chỉ lưu path

  // Hàm chọn ảnh
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path; // lưu path
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.anniversary != null) {
      _titleController.text = widget.anniversary!.title;
      _selectedDate = widget.anniversary!.date;
      _selectedImagePath = widget.anniversary!.imagePath;
      _contentController.text = widget.anniversary!.content ?? '';
    }
  }

  // Hàm chọn ngày (iOS style)
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
                    onDateTimeChanged: (DateTime dateTime) {
                      setState(() {
                        _selectedDate = dateTime;
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Lưu kỷ niệm
  void _saveAnniversary() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title!')));
      return;
    }

    Anniversary newAnniversary;
    if (widget.anniversary != null) {
      // Đây là thao tác edit, giữ lại id cũ
      newAnniversary = widget.anniversary!.copyWith(
        title: _titleController.text.trim(),
        date: _selectedDate,
        imagePath: _selectedImagePath,
        content: _contentController.text.trim(),
      );
    } else {
      // Đây là thao tác thêm mới
      newAnniversary = Anniversary(
        title: _titleController.text.trim(),
        date: _selectedDate,
        imagePath: _selectedImagePath,
        content: _contentController.text.trim(),
      );
    }
    Navigator.pop(context, newAnniversary);
  }

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat("d/M/yyyy").format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.withValues(alpha: .7),
        title: const Text('Add Anniversary Day 💞'),
        actions: [
          IconButton(
            onPressed: _saveAnniversary,
            icon: const Icon(Icons.check, color: Colors.pinkAccent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Chọn ảnh
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    _selectedImagePath == null
                        ? const Center(
                          child: Text('+', style: TextStyle(fontSize: 20)),
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            // Nhập tiêu đề
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title...',
                hintText: 'Enter title...',
              ),
            ),
            const SizedBox(height: 16),
            // Nhập nội dung nhật ký
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Content...',
                hintText: 'Write your diary here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Hiển thị ngày, bấm để chọn
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
