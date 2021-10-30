import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/update_note.dart';

class NotesList extends StatefulWidget {
  NotesList({
    Key? key,
  }) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  final Stream<QuerySnapshot> noteStream =
      FirebaseFirestore.instance.collection('notes').snapshots();

  bool isDelete = false;
  var deleteid;
  Color color = Colors.white;
  var delindex;
  var willpop = true;

  Future<void> deleteNote(id) {
    return FirebaseFirestore.instance
        .collection('notes')
        .doc(id)
        .delete()
        .then((value) => print("note deleted!"));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: noteStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        List data = [];
        snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
          Map a = documentSnapshot.data() as Map;
          print("map $a");
          a['id'] = documentSnapshot.id;
          print("map = $a");
          data.add(a);
        }).toList();

        if (snapshot.hasError) {
          return Center(child: Text("Somthing Went Wrong!"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (data.isEmpty){
          return Center(child: Text("Notes not found",style: TextStyle(color: Colors.white,fontSize: 18),));
        }


        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            if (delindex == index && deleteid == data[index]['id']) {
              isDelete ? color = Colors.purpleAccent : color = Colors.white;
            } else {
              color = Colors.white;
            }

            return InkWell(
              onLongPress: () {
                delindex = index;
                setState(() {
                  isDelete = !isDelete;
                });

                deleteid = data[index]['id'];
                showModalBottomSheet(
                  isDismissible: false,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0)),
                  ),
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async {
                        setState(() {
                          color = Colors.white;
                          isDelete = false;
                        });
                        return true;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(15.0),
                              topRight: const Radius.circular(15.0)),
                        ),
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () {
                                  print(deleteid);
                                  deleteNote(deleteid);
                                  if (isDelete == true) {
                                    isDelete = false;
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.black),
                                    child: Icon(Icons.delete_rounded,
                                        color: Colors.purple, size: 35))),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateNote(
                      id: data[index]['id'],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: color),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[index]['title'].toString(),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        data[index]['description'].toString(),
                        maxLines: 5,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
