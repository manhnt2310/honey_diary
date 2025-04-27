// presentation/screens/diary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/anniversary_bloc.dart';
import '../bloc/anniversary_event.dart';
import '../bloc/anniversary_state.dart';
import 'add_anniversary_screen.dart';
import 'anniversary_detail_screen.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả sử AnniversaryBloc đã được cung cấp ở trên qua BlocProvider
    context.read<AnniversaryBloc>().add(LoadAnniversariesEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('Anniversaries')),
      body: BlocBuilder<AnniversaryBloc, AnniversaryState>(
        builder: (context, state) {
          if (state is AnniversaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnniversaryLoaded) {
            final anniversaries = state.anniversaries;
            return ListView.builder(
              itemCount: anniversaries.length,
              itemBuilder: (context, index) {
                final ann = anniversaries[index];
                return ListTile(
                  title: Text(ann.title),
                  subtitle: Text(ann.date.toLocal().toString().split(' ')[0]),
                  onTap: () {
                    // Chuyển đến màn hình chi tiết, truyền đối tượng Anniversary
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AnniversaryDetailScreen(anniversary: ann),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is AnniversaryError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Chuyển đến màn hình thêm mới
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAnniversaryScreen()),
          );
        },
      ),
    );
  }
}
