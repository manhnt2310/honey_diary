import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../../shared/utils/helpers/database_helper.dart';
import '../../journal_addition/add_journal_screen.dart';
//import '../../journal_addition/presentation/journal_addition_page.dart';
import '../../journal_detail/journal_detail_screen.dart';

class Journal {
  final int? id; // id trong DB (có thể null khi chưa lưu)
  final String title; // tiêu đề
  final DateTime date; // ngày kỷ niệm
  final List<String> imagePaths; // danh sách đường dẫn ảnh
  final String? content; // nội dung nhật ký

  Journal({
    this.id,
    required this.title,
    required this.date,
    List<String>? imagePaths,
    this.content,
  }) : imagePaths = imagePaths ?? [];

  Journal copyWith({
    int? id,
    String? title,
    DateTime? date,
    List<String>? imagePaths,
    String? content,
  }) {
    return Journal(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      imagePaths: imagePaths ?? this.imagePaths,
      content: content ?? this.content,
    );
  }

  // Giúp chuyển List<String> thành chuỗi phân cách dấu phẩy để lưu vào DB
  String encodeImagePaths() {
    return imagePaths.join(',');
  }

  // Giúp chuyển chuỗi (được lưu trong DB) thành List<String>
  static List<String> decodeImagePaths(String? str) {
    if (str == null || str.trim().isEmpty) return [];
    return str.split(',').map((s) => s.trim()).toList();
  }
}

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Journal> _journals = [];

  @override
  void initState() {
    super.initState();
    _loadJournalsFromDB();
  }

  Future<void> _loadJournalsFromDB() async {
    final data = await _getAllJournals();
    setState(() {
      _journals.clear();
      _journals.addAll(data);
      // Sắp xếp từ mới nhất đến cũ nhất
      _journals.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  Future<List<Journal>> _getAllJournals() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('journals', orderBy: 'date ASC');

    return result.map((row) {
      return Journal(
        id: row['id'] as int?,
        title: row['title'] as String,
        date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
        imagePaths: Journal.decodeImagePaths(
          row['imagePaths'] as String? ?? row['imagePath'] as String?,
        ),
        content: row['content'] as String?,
      );
    }).toList();
  }

  Future<int> _insertJournal(Journal ann) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('journals', {
      'title': ann.title,
      'date': ann.date.millisecondsSinceEpoch,
      'imagePaths':
          ann.encodeImagePaths(), // dùng key đúng và chuyển đổi danh sách ảnh
      'content': ann.content ?? '',
    });
  }

  Future<int> _updateJournal(Journal ann) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'journals',
      {
        'title': ann.title,
        'date': ann.date.millisecondsSinceEpoch,
        'imagePaths': ann.encodeImagePaths(),
        'content': ann.content ?? '',
      },
      where: 'id = ?',
      whereArgs: [ann.id],
    );
  }

  Future<int> _deleteJournal(Journal ann) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete('journals', where: 'id = ?', whereArgs: [ann.id]);
  }

  // Xây dựng collage ảnh theo kiểu “post”
  Widget _buildCollage(List<String> paths) {
    // Nếu không có ảnh thì không hiển thị phần ảnh (card chỉ hiện title, content, ngày)
    if (paths.isEmpty) {
      return const SizedBox.shrink();
    }

    // Giới hạn hiển thị tối đa 5 ảnh (với trường hợp >5, sẽ overlay số vào ảnh cuối)
    final showCount = paths.length > 5 ? 5 : paths.length;
    final extraCount = paths.length > 5 ? paths.length - 5 : 0;

    switch (showCount) {
      case 1:
        return _buildOne(paths[0]);
      case 2:
        return _buildTwo(paths[0], paths[1]);
      case 3:
        return _buildThree(paths[0], paths[1], paths[2]);
      case 4:
        return _buildFour(paths[0], paths[1], paths[2], paths[3]);
      case 5:
      default:
        return _buildFive(paths, extraCount);
    }
  }

  /// Với 1 ảnh: Ảnh vuông nằm bên trái, nửa phải để trống.
  Widget _buildOne(String path) {
    return SizedBox(
      height: 170,
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(path), fit: BoxFit.cover),
              ),
            ),
          ),
          // Nửa bên phải để trống
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  /// Với 2 ảnh: 2 ảnh vuông cạnh nhau.
  Widget _buildTwo(String path1, String path2) {
    return SizedBox(
      height: 170,
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(path1), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(path2), fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Với 3 ảnh: Ảnh thứ nhất vuông bên trái; 2 ảnh còn lại dạng chữ nhật xếp dọc bên phải.
  Widget _buildThree(String path1, String path2, String path3) {
    return SizedBox(
      height: 170,
      child: Row(
        children: [
          // Nửa trái: ảnh vuông
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(path1), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Nửa phải: 2 ảnh chữ nhật xếp dọc
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(path2),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(path3),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Với 4 ảnh: Nửa trái: ảnh vuông; Nửa phải: trên là ảnh chữ nhật, dưới là 2 ảnh vuông cạnh nhau.
  Widget _buildFour(String path1, String path2, String path3, String path4) {
    return SizedBox(
      height: 170,
      child: Row(
        children: [
          // Nửa trái: ảnh vuông
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(path1), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Nửa phải
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Phần trên: ảnh chữ nhật
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(path2),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Phần dưới: 2 ảnh vuông cạnh nhau
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(path3),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(path4),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Với 5 ảnh: Nửa trái: ảnh vuông; Nửa phải: lưới 2x2 gồm 4 ảnh nhỏ.
  /// Nếu có nhiều hơn 5 ảnh thì ảnh ở góc dưới bên phải sẽ có overlay số (+1, +2…).
  Widget _buildFive(List<String> paths, int extraCount) {
    // paths có ít nhất 5 phần tử
    final path1 = paths[0];
    final path2 = paths[1];
    final path3 = paths[2];
    final path4 = paths[3];
    final path5 = paths[4];

    return SizedBox(
      height: 170,
      child: Row(
        children: [
          // Nửa trái: ảnh thứ nhất
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(path1), fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Nửa phải: lưới 2x2 với 4 ảnh nhỏ
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(path2),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(path3),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4), // Re-added the height spacing
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(path4),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(path5),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              if (extraCount > 0)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: .4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '+$extraCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 76, 201, 255),
              Color.fromARGB(255, 209, 240, 255),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: const Text(
                'My Diary',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 76, 201, 255),
              floating: true,
              snap: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 28),
                  tooltip: 'Add Journal',
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddJournalScreen(),
                      ),
                    );
                    if (result is Journal) {
                      final newId = await _insertJournal(result);
                      setState(() {
                        _journals.add(result.copyWith(id: newId));
                        _journals.sort((a, b) => b.date.compareTo(a.date));
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.home_filled,
                    color: Colors.white,
                    size: 23,
                  ),
                  tooltip: 'Home',
                  onPressed: () => Navigator.pop(context), // về trang trước
                ),
              ],
            ),
            if (_journals.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
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
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent.shade100,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start logging your special days.',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = _journals[index];
                  final dateString = DateFormat(
                    'EEEE, MMM d',
                  ).format(item.date);
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JournalDetailScreen(journal: item),
                        ),
                      );
                      if (result is Journal) {
                        await _updateJournal(result);
                        setState(() {
                          final i = _journals.indexWhere(
                            (a) => a.id == item.id,
                          );
                          if (i != -1) {
                            _journals[i] = result;
                            _journals.sort((a, b) => b.date.compareTo(a.date));
                          }
                        });
                      } else if (result == 'deleted') {
                        await _deleteJournal(item);
                        setState(
                          () => _journals.removeWhere((a) => a.id == item.id),
                        );
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCollage(item.imagePaths),
                            const SizedBox(height: 12),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item.content != null &&
                                item.content!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ReadMoreText(
                                  item.content!,
                                  trimLines: 3,
                                  colorClickableText: Colors.pink.shade100,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: ' Read more',
                                  trimExpandedText: ' Hide',
                                  style: const TextStyle(fontSize: 18),
                                  moreStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueGrey,
                                  ),
                                  lessStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            const Divider(color: Colors.grey, thickness: 1),
                            Text(
                              dateString,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: _journals.length),
              ),
          ],
        ),
      ),
    );
  }
}
