import 'package:ToDo_App/models/toDo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ToDoDetail extends StatefulWidget {
  final ToDo row;
  ToDoDetail(this.row);

  @override
  State<StatefulWidget> createState() {
    return _ToDoDetailState(row);
  }
}

enum PopupOptions { DELETE, UPDATE }

class _ToDoDetailState extends State<ToDoDetail> {
  ToDo row;
  _ToDoDetailState(this.row);

  final databaseReference = Firestore.instance;
  var toDoController = TextEditingController();
  var isDoneController = TextEditingController();
  var checked;

  @override
  void initState() {
    toDoController.text = row.todo;
    checked = row.isDone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildToDoDetail(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Details of ToDo: " + row.todo, textAlign: TextAlign.center,),
      backgroundColor: Colors.redAccent,
      actions: <Widget>[
        buildPopupMenuButton(),
      ],
    );
  }

  PopupMenuButton<PopupOptions> buildPopupMenuButton() {
    return PopupMenuButton<PopupOptions>(
        onSelected: performSelectedOption,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupOptions>>[
              buildDeleteOption(),
              buildUpdateOption(),
            ]);
  }

  void performSelectedOption(PopupOptions option) async {
    switch (option) {
      case PopupOptions.DELETE:
        await performDelete();
        break;
      case PopupOptions.UPDATE:
        await performUpdate();
        break;
      default:
        UnimplementedError("There is no such option.");
    }
  }

  Future performDelete() async {
    await databaseReference
        .collection("Todos")
        .document(row.documentId)
        .delete();
    Navigator.pop(context, true);
  }

  Future performUpdate() async {
    var rowAsMap = {"todo": toDoController.text, "isDone": checked};
    await databaseReference
        .collection("Todos")
        .document(row.documentId)
        .updateData(rowAsMap);
    Navigator.pop(context, true);
  }

  PopupMenuItem<PopupOptions> buildDeleteOption() {
    return PopupMenuItem<PopupOptions>(
      value: PopupOptions.DELETE,
      child: Text("Delete"),
    );
  }

  PopupMenuItem<PopupOptions> buildUpdateOption() {
    return PopupMenuItem<PopupOptions>(
      value: PopupOptions.UPDATE,
      child: Text("Update"),
    );
  }

  Padding buildToDoDetail() {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        children: <Widget>[
          buildToDoField(),
          buildIsDoneField(),
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
}
