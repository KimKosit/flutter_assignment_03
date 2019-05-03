import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoScreenState();
  }
}

class TodoScreenState extends State {
  int _index = 0;
  Firestore _firestore = Firestore();

  @override
  Widget build(BuildContext context) {
    final List btnList = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () async {
          Navigator.pushNamed(context, '/add');
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          Fluttertoast.showToast(
            msg: "Deleted!",
            backgroundColor: Color(0xfff0f0f0),
            textColor: Colors.black,
          );
          return _firestore
              .collection('todo')
              .where('done', isEqualTo: 1)
              .getDocuments()
              .then((d) {
            d.documents.forEach((r) {
              r.reference.delete();
            });
          });
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: <Widget>[btnList[_index]],
      ),
      body: StreamBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (_index == 0) {
            if (snapshot.data.documents.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  int _id =
                      snapshot.data.documents.elementAt(index).data['_id'];
                  String name =
                      snapshot.data.documents.elementAt(index).data['title'];
                  bool done =
                      snapshot.data.documents.elementAt(index).data['done'] ==
                          1;
                  String docId =
                      snapshot.data.documents.elementAt(index).documentID;
                  return CheckboxListTile(
                    title: Text(name),
                    value: done,
                    onChanged: (bool check) {
                      setState(() {
                        _firestore
                            .collection('todo')
                            .document(docId)
                            .setData({'_id': _id, 'title': name, 'done': 1});
                      });
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('No data found..'),
              );
            }
          } else if (_index == 1) {
            if (snapshot.data.documents.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  int _id =
                      snapshot.data.documents.elementAt(index).data['_id'];
                  String name =
                      snapshot.data.documents.elementAt(index).data['title'];
                  bool done =
                      snapshot.data.documents.elementAt(index).data['done'] !=
                          0;
                  String docId =
                      snapshot.data.documents.elementAt(index).documentID;
                  return CheckboxListTile(
                    title: Text(name),
                    value: done,
                    onChanged: (bool check) {
                      Fluttertoast.showToast(
                        msg: "Todo Finished",
                        backgroundColor: Color(0xfff0f0f0),
                        textColor: Colors.black,
                      );
                      setState(() {
                        _firestore
                            .collection('todo')
                            .document(docId)
                            .setData({'_id': _id, 'title': name, 'done': 0});
                      });
                    },
                  );
                },
              );
            } else {
              return Center(
                child: Text('No data found..'),
              );
            }
          }
        },
        stream: _firestore
            .collection('todo')
            .where('done', isEqualTo: _index)
            .snapshots(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Task")),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed")),
        ],
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
