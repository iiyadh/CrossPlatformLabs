import { Databases, Query } from "appwrite";
import client from "./appwrite-config";
import { APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID } from "@env";

// Initialize the Databases SDK
const databases = new Databases(client);

// List all documents/notes in the collection
export const listDocuments = async (queries = []) => {
  try {
    const response = await databases.listDocuments(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID,
      queries
    );
    return response.documents;
  } catch (error) {
    console.error("Error listing documents:", error);
    throw error;
  }
};