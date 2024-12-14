import 'package:cloud_firestore/cloud_firestore.dart';

void fetchDocumentIDs() async {
  // Reference to the 'tasks' collection
  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  // Fetch the documents from the 'tasks' collection
  QuerySnapshot snapshot = await tasks.get();

  // Iterate over the documents and print the document ID
  for (var doc in snapshot.docs) {
    print('Document ID: ${doc.id}');
  }
}
