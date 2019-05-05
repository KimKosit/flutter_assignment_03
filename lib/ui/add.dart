import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int _id = 0;
int max_id = 0;

class AddSubject extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddSubjectState();
  }
}

class AddSubjectState extends State<AddSubject> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController inputName = TextEditingController();
  Firestore _firestore = Firestore();

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
                          _id += 1;
                          if (_formkey.currentState.validate()) {
                            CollectionReference todoRef =
                                _firestore.collection('todo');
                            QuerySnapshot _myDoc = await _firestore
                                .collection('todo')
                                .getDocuments();
                            List<DocumentSnapshot> _myDocCount =
                                _myDoc.documents;
                            int check = _myDocCount.length;
                            if (check != 0) {
                              if (_id != 1) {
                                _myDoc.documents.forEach((doc) {
                                  if (doc.data['_id'] > max_id) {
                                    max_id = doc.data['_id'];
                                  }
                                  _id = max_id + 1;
                                });
                              } else if (_id == 1) {
                                _myDoc.documents.forEach((doc) {
                                  if (doc.data['_id'] > max_id) {
                                    max_id = doc.data['_id'];
                                  }
                                  _id = max_id + 1;
                                });
                              }
                            }
                            await todoRef.document(_id.toString()).setData({
                              '_id': _id,
                              'title': inputName.text,
                              'done': 0,
                            });
                            Navigator.pop(context);

                            // QuerySnapshot _myDoc = await _firestore
                            //     .collection('todo')
                            //     .getDocuments();
                            // List<DocumentSnapshot> _myDocCount =
                            //     _myDoc.documents;
                            // CollectionReference todoRef =
                            //     _firestore.collection('todo');
                            // var num = _myDocCount.length + 1;
                            // String _id = num.toString();
                            // await todoRef.document(_id).setData({
                            //   '_id': int.parse(_id),
                            //   'title': inputName.text,
                            //   'done': 0
                            // });
                            // Navigator.pop(context);
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
