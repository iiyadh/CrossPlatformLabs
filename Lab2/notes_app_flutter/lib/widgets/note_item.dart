import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../services/note_service.dart';

class NoteItem extends StatefulWidget {
  final Document note;
  final Function(String)? onNoteDeleted;
  final Function(Document)? onNoteUpdated;

  const NoteItem({
    Key? key,
    required this.note,
    this.onNoteDeleted,
    this.onNoteUpdated,
  }) : super(key: key);

  @override
  _NoteItemState createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  final NoteService _noteService = NoteService();
  bool _isDeleting = false;

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        setState(() {
          _isDeleting = true;
        });

        await _noteService.deleteNote(widget.note.$id);

        if (widget.onNoteDeleted != null) {
          widget.onNoteDeleted!(widget.note.$id);
        }
      } catch (e) {
        print('Error deleting note: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete note. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
        }
      }
    }
  }

  void _handleEdit() {
    showDialog(
      context: context,
      builder: (context) => EditNoteModal(
        note: widget.note,
        onNoteUpdated: widget.onNoteUpdated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.note.data['title'] as String? ?? 'No Title';
    final content = widget.note.data['content'] as String? ?? 'No Content';
    final updatedAt = widget.note.$updatedAt;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last updated: ${_formatDate(updatedAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isDeleting ? null : _handleEdit,
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 8),
                _isDeleting
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _handleDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}