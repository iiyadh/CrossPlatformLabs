import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'appwrite_config.dart';

class NoteService {
  final Client _client = getClient();
  late final Databases _databases;

  NoteService() {
    _databases = Databases(_client);
  }

  Future<List<Document>> getNotes({String? userId}) async {
    try {
      List<String> queries = [];

      if (userId != null) {
        queries.add(Query.equal('userId', userId));
      }

      queries.add(Query.orderDesc('createdAt'));

      final response = await _databases.listDocuments(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        queries: queries,
      );

      return response.documents;
    } catch (e) {
      print('Error getting notes: $e');
      throw e;
    }
  }

  Future<Document> createNote(Map<String, dynamic> data) async {
    try {
      final noteData = {
        ...data,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final response = await _databases.createDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: ID.unique(),
        data: noteData,
      );

      return response;
    } catch (e) {
      print('Error creating note: $e');
      throw e;
    }
  }

  Future<bool> deleteNote(String noteId) async {
    try {
      await _databases.deleteDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
      );

      return true;
    } catch (e) {
      print('Error deleting note: $e');
      throw e;
    }
  }

  Future<Document> updateNote(String noteId, Map<String, dynamic> data) async {
    try {
      final noteData = {
        ...data,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      final response = await _databases.updateDocument(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        documentId: noteId,
        data: noteData,
      );

      return response;
    } catch (e) {
      print('Error updating note: $e');
      throw e;
    }
  }
}