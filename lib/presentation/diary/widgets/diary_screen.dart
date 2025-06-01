// lib/presentation/screens/diary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/journal.dart';
import '../bloc/diary_bloc.dart';
import '../bloc/diary_event.dart';
import '../bloc/diary_state.dart';
import 'add_journal_screen.dart';
import 'journal_detail_screen.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khi mở màn hình, dispatch Load
    context.read<DiaryBloc>().add(LoadJournalsEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Journal Journal')),
      body: BlocBuilder<DiaryBloc, DiaryState>(
        builder: (context, state) {
          if (state is DiaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DiaryLoaded) {
            if (state.journals.isEmpty) {
              return const Center(child: Text('Start journaling today.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.journals.length,
              itemBuilder: (ctx, i) {
                final ann = state.journals[i];
                return GestureDetector(
                  onTap: () async {
                    // Chuyển đến Detail, chờ kết quả (update/delete trả về qua bloc)
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JournalDetailScreen(journal: ann),
                      ),
                    );
                  },
                  child: JournalCard(journal: ann),
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
              MaterialPageRoute(builder: (_) => const AddJournalScreen()),
            ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// Đưa phần Card riêng cho dễ đọc
class JournalCard extends StatelessWidget {
  final Journal journal;
  const JournalCard({required this.journal, super.key});

  @override
  Widget build(BuildContext context) {
    final dateString = DateFormat('EEEE, MMM d').format(journal.date);
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
              journal.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (journal.description != null && journal.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  journal.description!,
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
