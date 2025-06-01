// presentation/screens/journal_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/journal.dart';
import '../bloc/diary_bloc.dart';
import '../bloc/diary_event.dart';

class JournalDetailScreen extends StatelessWidget {
  final Journal journal;
  const JournalDetailScreen({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Gửi event xóa và quay lại màn hình trước
              context.read<DiaryBloc>().add(DeleteJournalEvent(journal.id));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Title: ${journal.title}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${journal.date.toLocal()}'.split(' ')[0],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${journal.description}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Edit'),
              onPressed: () {
                // Chuyển đến màn hình chỉnh sửa (tương tự Add, ta có thể truyền kèm dữ liệu để cập nhật)
                // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (_) => EditJournalScreen(journal: journal)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
