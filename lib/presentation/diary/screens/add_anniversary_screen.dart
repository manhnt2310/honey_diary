// presentation/screens/add_anniversary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/anniversary.dart';
import '../bloc/anniversary_bloc.dart';
import '../bloc/anniversary_event.dart';

class AddAnniversaryScreen extends StatefulWidget {
  const AddAnniversaryScreen({super.key});

  @override
  AddAnniversaryScreenState createState() => AddAnniversaryScreenState();
}

class AddAnniversaryScreenState extends State<AddAnniversaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Anniversary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Input tiêu đề
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              // Input ngày (ví dụ sử dụng DatePicker, đơn giản dùng TextField)
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Date'),
                controller: TextEditingController(
                  text: '${_selectedDate.toLocal()}'.split(' ')[0],
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              // Input mô tả
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Tạo Anniversary entity và gửi event thêm mới
                    final ann = Anniversary(
                      title: _titleController.text,
                      date: _selectedDate,
                      description: _descriptionController.text,
                      imagePaths: [],
                      id: 0, // Giả sử không có ảnh trong ví dụ này
                    );
                    context.read<AnniversaryBloc>().add(
                      AddAnniversaryEvent(ann),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
