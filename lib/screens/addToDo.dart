import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddToDo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddToDoState();
  }
}

class _AddToDoState extends State<AddToDo> {
  var checked = false;
  var toDoController = TextEditingController();
  var isDoneController = TextEditingController();
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Add New ToDo", textAlign: TextAlign.center,),
      backgroundColor: Colors.redAccent,
    );
  }

  Padding buildBody() {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        children: <Widget>[
          buildToDoField(),
          buildIsDoneField(),
          buildSaveButton()
        ],
      ),
    );
  }

  buildToDoField() {
    return TextField(
      decoration: InputDecoration(labelText: "Name of the ToDo"),
      controller: toDoController,
    );
  }

  buildIsDoneField() {
    return CheckboxListTile(
      title: Text("Did you finished this ToDo"),
      controlAffinity: ListTileControlAffinity.trailing,
      value: checked,
      onChanged: (bool value) {
        setState(() {
          checked = value;
        });
      },
    );
  }

  FlatButton buildSaveButton() {
    return FlatButton(
      child: Text("Add"),
      color: Colors.redAccent,
      onPressed: () {
        addToDo();
      },
    );
  }

  void addToDo() async {
    DocumentReference ref = await databaseReference
        .collection("Todos")
        .add({'todo': toDoController.text, 'isDone': checked});
    Navigator.pop(context, true);
  }
}
