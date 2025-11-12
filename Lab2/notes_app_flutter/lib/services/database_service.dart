import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'appwrite_config.dart';

class DatabaseService {
  final Client _client = getClient();
  late final Databases _databases;

  DatabaseService() {
    _databases = Databases(_client);
  }

  Future<List<Document>> listDocuments({List<String>? queries}) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: dotenv.env['APPWRITE_DATABASE_ID']!,
        collectionId: dotenv.env['APPWRITE_COLLECTION_ID']!,
        queries: queries,
      );
      return response.documents;
    } catch (e) {
      print('Error listing documents: $e');
      throw e;
    }
  }
}