import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({Key? key}) : super(key: key);

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _desccontroller = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');
  addNotes(String title, String description) {
    notes
        .add({"title": title, "description": description})
        .then((value) => print("Notes added $value"))
        .catchError((error) => print("Error is $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Add Notes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titlecontroller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Enter Title",
                    hintStyle: TextStyle(color: Colors.white70)),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _desccontroller,
                style: TextStyle(color: Colors.white),
                maxLines: 5,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    hintText: "Enter Description",
                    hintStyle: TextStyle(color: Colors.white70)),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  print(_titlecontroller.text);
                  print(_desccontroller.text);
                  addNotes(_titlecontroller.text, _desccontroller.text);
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => MyHome()));
                  Navigator.pop(context);
                },
                child: Text("Add Notes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
