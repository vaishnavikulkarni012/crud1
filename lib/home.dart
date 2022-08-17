import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'add.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fb = FirebaseDatabase.instance;
  TextEditingController second = TextEditingController();

  TextEditingController third = TextEditingController();
  var l;
  var g;
  var k;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => add(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Todos',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          var v = snapshot.value.toString();

          g = v.replaceAll(RegExp("{|}|subtitle: |title: "), "");
          g.trim();

          l = g.split(',');
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            k = snapshot.key;
                          });
                          child:
                          Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: TextField(
                                  controller: second,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'title',
                                  ),
                                ),
                              ),
                              content: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: TextField(
                                  controller: third,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'sub title',
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  color: Color.fromARGB(255, 135, 0, 145),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    await upd();
                                    Navigator.of(ctx).pop();
                                  },
                                  color: Color.fromARGB(255, 135, 0, 145),
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.purple,
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 255, 0, 0),
                                ),
                                onPressed: () {
                                  ref.child(snapshot.key!).remove();
                                },
                              ),
                              title: Text(
                                l[1],
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                l[0],
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ])
              ]);
        },
      ),
    );
  }

  upd() async {
    DatabaseReference ref1 = FirebaseDatabase.instance.ref("todos/$k");

    await ref1.update({
      "title": second.text,
      "subtitle": third.text,
    });
    second.clear();
    third.clear();
  }
}
