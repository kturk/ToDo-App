import 'package:ToDo_App/models/toDo.dart';
import 'package:ToDo_App/screens/toDoDetail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'addToDo.dart';

class ToDoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToDoListState();
  }
}

class _ToDoListState extends State<ToDoList> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
      floatingActionButton: buildAddToDoButton(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("ToDo List", textAlign: TextAlign.center,),
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        buildSignOutButton(context),
      ],

    );
  }

  IconButton buildSignOutButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      tooltip: "Log Out",
      onPressed: () {
        _signOut();
        Navigator.pop(context, true);
      },
    );
  }

  StreamBuilder<QuerySnapshot> buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("Todos").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData)
          return buildList(context, snapshot.data.documents);
        else
          return LinearProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.all(15.0),
      children:
      snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  FloatingActionButton buildAddToDoButton() {
    return FloatingActionButton(
      onPressed: () {
        goToAddToDoScreen();
      },
      child: Icon(Icons.add),
      tooltip: "Add New ToDo",
      backgroundColor: Colors.redAccent,
    );
  }

  buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = ToDo.fromSnapshot(data); // Data row from firebase
    return Padding(
      key: ValueKey(row.todo),
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Container(
        decoration: boxDecorationConstraints(),
        child: ListTile(
          title: Text(row.todo),
          trailing: buildToDoStatusIcon(row),
          onTap: () {
            goToToDoDetail(row);
          },
        ),
      ),
    );
  }

  Icon buildToDoStatusIcon(ToDo row) {
    if (row.isDone == true)
      return Icon(Icons.done);
    else
      return Icon(Icons.clear);
  }

  BoxDecoration boxDecorationConstraints() {
    return BoxDecoration(
      border: Border.all(color: Colors.redAccent),
      borderRadius: BorderRadius.circular(6.0),
    );
  }

  void goToAddToDoScreen() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddToDo()));
  }

  void goToToDoDetail(ToDo row) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ToDoDetail(row)));
  }

  _signOut() async {
    await _firebaseAuth.signOut();
  }
}


/*

      INITIAL TEST DATA

final testSnapshot = [
  {"Todo": "Study Math", "isDone": true},
  {"Todo": "Play Games", "isDone": true},
  {"Todo": "Watch Community", "isDone": false},
  {"Todo": "Drink Water", "isDone": false},
];

 */
