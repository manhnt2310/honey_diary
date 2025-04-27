// presentation/screens/anniversary_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/anniversary.dart';
import '../bloc/anniversary_bloc.dart';
import '../bloc/anniversary_event.dart';

class AnniversaryDetailScreen extends StatelessWidget {
  final Anniversary anniversary;
  const AnniversaryDetailScreen({super.key, required this.anniversary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anniversary Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Gửi event xóa và quay lại màn hình trước
              context.read<AnniversaryBloc>().add(
                DeleteAnniversaryEvent(anniversary.id),
              );
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
              'Title: ${anniversary.title}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${anniversary.date.toLocal()}'.split(' ')[0],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${anniversary.description}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Edit'),
              onPressed: () {
                // Chuyển đến màn hình chỉnh sửa (tương tự Add, ta có thể truyền kèm dữ liệu để cập nhật)
                // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (_) => EditAnniversaryScreen(anniversary: anniversary)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
