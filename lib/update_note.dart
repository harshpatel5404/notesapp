import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UpdateNote extends StatefulWidget {
  final id;
  const UpdateNote({Key? key, this.id}) : super(key: key);

  @override
  _UpdateNoteState createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  Future<void> updateNote(title, desc) {
    return notes
        .doc(widget.id)
        .update({'title': title, 'description': desc})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Update Note"),
      ),
      body: FutureBuilder<DocumentSnapshot<Map>>(
        future:
            FirebaseFirestore.instance.collection('notes').doc(widget.id).get(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Something Went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data != null) {
            var data = snapshot.data!.data();
            var title = data!['title'];
            var desc = data['description'];
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      initialValue: title,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.3),
                        ),
                        hintText: "Enter Title",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      initialValue: desc,
                      style: TextStyle(color: Colors.white),
                      maxLines: 5,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        hintText: "Enter Description",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      onChanged: (value) {
                        desc = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          print("updatetitle $title");
                          updateNote(title, desc);
                        });
                        // Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => MyHome()));
                        Navigator.pop(context);
                      },
                      child: Text("Update Notes"),
                    ),
                  ],
                ),
              ),
            );



            
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
