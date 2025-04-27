import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/anniversary.dart';
import '../../anniversary_addition/add_anniversary_screen.dart';
import '../bloc/diary_bloc.dart';
import '../bloc/diary_state.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar với nút back mặc định
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade100,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'My Diary',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      // body dùng BlocBuilder như cũ nhưng có styling
      body: BlocBuilder<DiaryBloc, DiaryState>(
        builder: (context, state) {
          if (state is DiaryInitial) {
            // Màn hình chào mừng
            return Container(
              color: Colors.cyan.shade100,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 72,
                      color: Colors.pink.shade200,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to the Diary!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent.shade100,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start logging your special days.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DiaryLoading) {
            // Loading indicator
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
              ),
            );
          }

          if (state is DiaryError) {
            // Lỗi
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is DiaryLoaded) {
            final list = state.anniversaries;
            if (list.isEmpty) {
              return const Center(child: Text('No anniversaries yet.'));
            }

            // Danh sách dưới dạng Card
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final ann = list[idx];
                final dateStr = DateFormat('dd/MM/yyyy').format(ann.date);
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    title: Text(
                      ann.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          dateStr,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        if ((ann.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            ann.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.pinkAccent,
                    ),
                    onTap: () {
                      // TODO: navigate to detail
                    },
                  ),
                );
              },
            );
          }

          // Nếu vào đây thì trả về empty
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAnniversaryScreen(),
            ),
          );

          // if (result != null && result is Anniversary) {
          //   final newId = await _insertAnniversary(result);
          //   setState(() {
          //     final newItem = result.copyWith(id: newId);
          //     _anniversaries.add(newItem);
          //     _anniversaries.sort((a, b) => b.date.compareTo(a.date));
          //   });
          // }
        },
        backgroundColor: Colors.pink.shade200, // Thay đổi màu sắc tại đây
        shape: const CircleBorder(), // Đặt hình dạng là hình tròn
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Căn giữa nút
    );
  }
}
