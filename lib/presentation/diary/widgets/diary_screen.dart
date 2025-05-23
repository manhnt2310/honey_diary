// lib/presentation/screens/diary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/anniversary.dart';
import '../bloc/diary_bloc.dart';
import '../bloc/diary_event.dart';
import '../bloc/diary_state.dart';
import 'add_anniversary_screen.dart';
import 'anniversary_detail_screen.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khi mở màn hình, dispatch Load
    context.read<DiaryBloc>().add(LoadAnniversariesEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Anniversary Journal')),
      body: BlocBuilder<DiaryBloc, DiaryState>(
        builder: (context, state) {
          if (state is DiaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DiaryLoaded) {
            if (state.anniversaries.isEmpty) {
              return const Center(child: Text('Start journaling today.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.anniversaries.length,
              itemBuilder: (ctx, i) {
                final ann = state.anniversaries[i];
                return GestureDetector(
                  onTap: () async {
                    // Chuyển đến Detail, chờ kết quả (update/delete trả về qua bloc)
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AnniversaryDetailScreen(anniversary: ann),
                      ),
                    );
                  },
                  child: AnniversaryCard(anniversary: ann),
                );
              },
            );
          } else if (state is DiaryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddAnniversaryScreen()),
            ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// Đưa phần Card riêng cho dễ đọc
class AnniversaryCard extends StatelessWidget {
  final Anniversary anniversary;
  const AnniversaryCard({required this.anniversary, super.key});

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('EEEE, MMM d').format(anniversary.date);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh & nội dung giống cũ, bạn có thể re-use _buildCollage(...)
            Text(
              anniversary.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (anniversary.description != null &&
                anniversary.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  anniversary.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Divider(),
            Text(
              dateString,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
