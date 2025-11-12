import { Query, Databases, ID } from "appwrite";
import { listDocuments } from "./database-service";
import client from "./appwrite-config";
import { APPWRITE_DATABASE_ID, APPWRITE_COLLECTION_ID } from "@env";

const databases = new Databases(client);

// Get all notes, potentially filtered by userId
export const getNotes = async (userId = null) => {
  try {
    const queries = [];

    if (userId) {
      queries.push(Query.equal("userId", userId));
    }

    queries.push(Query.orderDesc("createdAt"));

    const notes = await listDocuments(queries);
    return notes;
  } catch (error) {
    console.error("Error getting notes:", error);
    throw error;
  }
};

// Create a new note
export const createNote = async (data) => {
  try {
    const noteData = {
      ...data,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    const response = await databases.createDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID,
      ID.unique(),
      noteData
    );

    return response;
  } catch (error) {
    console.error("Error creating note:", error);
    throw error;
  }
};

// Delete a note by ID
export const deleteNote = async (noteId) => {
  try {
    await databases.deleteDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID,
      noteId
    );

    return true;
  } catch (error) {
    console.error("Error deleting note:", error);
    throw error;
  }
};

// Update an existing note
export const updateNote = async (noteId, data) => {
  try {
    const noteData = {
      ...data,
      updatedAt: new Date().toISOString(),
    };

    const response = await databases.updateDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID,
      noteId,
      noteData
    );

    return response;
  } catch (error) {
    console.error("Error updating note:", error);
    throw error;
  }
};