import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const SmartNoteApp());
}

const String studentName = "Đỗ Quang Nam Anh";
const String studentId = "2351160501";

/// ================= MODEL =================
class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

/// ================= SERVICE (SINGLETON) =================
class NoteService {
  static final NoteService _instance = NoteService._internal();
  factory NoteService() => _instance;
  NoteService._internal();

  static const String _key = 'smart_notes';
  final List<Note> _notes = [];
  late SharedPreferences _prefs;
  bool _initialized = false;

  List<Note> get notes => _notes;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    final data = _prefs.getString(_key);
    if (data != null) {
      final List list = jsonDecode(data);
      _notes.clear();
      _notes.addAll(list.map((e) => Note.fromJson(e)));
      _sort();
    }
    _initialized = true;
  }

  void _sort() {
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> _save() async {
    await _prefs.setString(
      _key,
      jsonEncode(_notes.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> add(Note note) async {
    _notes.insert(0, note);
    await _save();
  }

  Future<void> update(Note note) async {
    final index = _notes.indexWhere((e) => e.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      _sort();
      await _save();
    }
  }

  Future<void> delete(String id) async {
    _notes.removeWhere((e) => e.id == id);
    await _save();
  }

  List<Note> search(String query) {
    if (query.isEmpty) return _notes;
    return _notes
        .where((e) =>
            e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

/// ================= APP =================
class SmartNoteApp extends StatelessWidget {
  const SmartNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Note',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

/// ================= HOME =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteService _service = NoteService();
  bool _loading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _service.init();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final notes = _service.search(_search);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Note - $studentName - $studentId",
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm ghi chú...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: notes.isEmpty
                      ? Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(Icons.note_alt_outlined,
                                size: 100,
                                color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            const Text(
                              "Bạn chưa có ghi chú nào, hãy tạo mới nhé!",
                              textAlign: TextAlign.center,
                            )
                          ],
                        )
                      : MasonryGridView.count(
                          padding: const EdgeInsets.all(16),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return NoteCard(
                              note: note,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          DetailScreen(
                                              note: note)),
                                );
                                setState(() {});
                              },
                              onDelete: () async {
                                await _service
                                    .delete(note.id);
                                setState(() {});
                              },
                            );
                          },
                        ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const DetailScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// ================= NOTE CARD =================
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Xóa ghi chú"),
            content: const Text(
                "Bạn có chắc chắn muốn xóa ghi chú này không?"),
            actions: [
              TextButton(
                  onPressed: () =>
                      Navigator.pop(context, false),
                  child: const Text("Hủy")),
              TextButton(
                  onPressed: () =>
                      Navigator.pop(context, true),
                  child: const Text("OK",
                      style:
                          TextStyle(color: Colors.red))),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child:
            const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  note.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Text(
                  DateFormat("dd/MM/yyyy HH:mm")
                      .format(note.updatedAt),
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= DETAIL =================
class DetailScreen extends StatefulWidget {
  final Note? note;
  const DetailScreen({super.key, this.note});

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final NoteService _service = NoteService();
  late TextEditingController _title;
  late TextEditingController _content;

  @override
  void initState() {
    super.initState();
    _title =
        TextEditingController(text: widget.note?.title ?? '');
    _content =
        TextEditingController(text: widget.note?.content ?? '');
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final content = _content.text.trim();
    if (title.isEmpty || content.isEmpty) {
      return;
    }

    final now = DateTime.now();

    if (widget.note != null) {
      if (title == widget.note!.title &&
          content == widget.note!.content) {
        return;
      }

      await _service.update(Note(
        id: widget.note!.id,
        title: title,
        content: content,
        createdAt: widget.note!.createdAt,
        updatedAt: now,
      ));
    } else {
      await _service.add(Note(
        id: const Uuid().v4(),
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _save();
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.note != null
              ? "Sửa ghi chú"
              : "Tạo ghi chú mới"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                    hintText: "Tiêu đề",
                    border: InputBorder.none),
                maxLines: null,
              ),
              const Divider(),
              Expanded(
                child: TextField(
                  controller: _content,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                      hintText: "Nội dung",
                      border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}