import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';
import '../widgets/note_item.dart';
import '../widgets/add_note_modal.dart';
import '../providers/auth_provider.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NoteService _noteService = NoteService();
  List<Document> _notes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  // Function to fetch notes from the database
  Future<void> _fetchNotes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Get authenticated user id (if available)
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      String? userId;
      try {
        userId = authProvider.user?.$id ?? authProvider.user?.id;
      } catch (_) {
        // last resort: try map-style access
        try {
          userId = authProvider.user?['\$id'] ?? authProvider.user?['id'];
        } catch (_) {
          userId = null;
        }
      }

      // Call the getNotes service function, passing userId when available
      final fetchedNotes = await _noteService.getNotes(userId: userId);

      // Update state with the fetched notes
      setState(() {
        _notes = fetchedNotes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching notes: $e');
      setState(() {
        _error = 'Failed to load notes. Please try again.';
        _isLoading = false;
      });
    }
  }

  // Show the add note dialog
  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteModal(
        onNoteAdded: _handleNoteAdded,
      ),
    );
  }

  // After a new note is added, refresh the list
  void _handleNoteAdded(Map<String, dynamic> noteData) {
    // Simply refetch notes to keep things consistent
    _fetchNotes();
  }

  // Handle note deletion by removing it from state
  void _handleNoteDeleted(String noteId) {
    setState(() {
      _notes = _notes.where((note) => note.$id != noteId).toList();
    });
  }

  // Handle note update by replacing it in state
  void _handleNoteUpdated(Document updated) {
    setState(() {
      _notes = _notes.map((n) => n.$id == updated.$id ? updated : n).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddNoteDialog,
            tooltip: 'Add Note',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Show loading indicator
            if (_isLoading && _notes.isEmpty)
              const Center(child: CircularProgressIndicator()),

            // Show error message
            if (_error != null && _notes.isEmpty)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),

            // Show the notes list
            if (!_isLoading || _notes.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchNotes,
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return NoteItem(
                        note: note,
                        onNoteDeleted: _handleNoteDeleted,
                        onNoteUpdated: _handleNoteUpdated,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}