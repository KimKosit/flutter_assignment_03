import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSubject extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddSubjectState();
  }
}

class AddSubjectState extends State<AddSubject> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController inputName = TextEditingController();
  Firestore _store = Firestore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Subject"),
        ),
        body: Padding(
          padding: EdgeInsets.all(13),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: inputName,
                  decoration: InputDecoration(labelText: "Subject"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill subject";
                    }
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("Save"),
                        onPressed: () async {
                          if (_formkey.currentState.validate()) {
                            print(_store);
                            _store
                                .collection('todo')
                                .add({'title': inputName.text, 'done': 0});
                            Navigator.pop(context);
                          }
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
