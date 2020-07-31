import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String todo;
  bool isDone;
  String documentId;
  DocumentReference reference;

  ToDo.fromMap(Map<String, dynamic> map, String documentId, {this.reference})
      : todo = map["todo"],
        isDone = map["isDone"],
        documentId = documentId;

  ToDo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID,
            reference: snapshot.reference);
}
