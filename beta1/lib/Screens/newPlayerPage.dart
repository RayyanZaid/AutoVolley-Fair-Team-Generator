import './successful_screen.dart';
import 'package:beta1/globals.dart' as globals;
import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'welcome_screen.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class NewPlayerPage extends StatefulWidget {
  NewPlayerPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  NewPlayerPageState createState() => NewPlayerPageState();
}

OutlineInputBorder _inputformdeco() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.0),
    borderSide:
        BorderSide(width: 2.0, color: Colors.black, style: BorderStyle.solid),
  );
}

Future<bool> doesExist(String name) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://autovolley-85d29-default-rtdb.firebaseio.com/players/${name}.json'),
  );

  try {
    Map<String, dynamic> data = json.decode(response.body);
  } catch (e) {
    debugPrint("Does not exist");
    return false;
  }

  return true;
}

void addNewPlayer(String name, Map<String, dynamic> data) async {
  HttpClient client = HttpClient();

  try {
    // Encode the data as a JSON string
    String dataString = json.encode(data);

    // Send an HTTP PATCH request to the document's URL with the new data in the request body
    http.Response response = await http.patch(
        Uri.parse(
            'https://autovolley-85d29-default-rtdb.firebaseio.com/players/${name}.json'),
        body: dataString);

    // Check the status code of the response
    if (response.statusCode == 200) {
      debugPrint('Data set successfully');
    } else {
      debugPrint('Error setting data: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error: $e');
  }
}

class NewPlayerPageState extends State<NewPlayerPage> {
  String name = "";
  String final_response = "";
  final _formkey = GlobalKey<FormState>();
  Future<void> _savingData() async {
    final validation = _formkey.currentState!.validate();
    if (!validation) {
      return;
    }
    _formkey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Player'),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/b1.jpeg"), fit: BoxFit.cover)),
        alignment: Alignment.bottomCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 200),
            Container(
              width: 350,
              alignment: Alignment.topCenter,
              child: Form(
                key: _formkey,
                child: TextFormField(
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter your name:',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 30,
                    ),
                    enabledBorder: _inputformdeco(),
                    focusedBorder: _inputformdeco(),
                  ),
                  onSaved: (value) {
                    name =
                        value!; //getting data from the user form and assigning it to name
                  },
                ),
              ),
            ),

            TextButton(
              onPressed: () async {
                //validating the form and saving it
                _savingData();
                name = name.trim();

                debugPrint(name);
                bool docExists = await doesExist(name);

                if (!docExists) {
                  addNewPlayer(
                      name, {'wins': 0, 'losses': 0, 'winPercentage': 0.0});
                } else {
                  debugPrint("DOC EXISTS");
                }

                bool isTaken = docExists;

                var responseMessage = name + " has been added as a player";
                var alert = "Success!!";
                var bgColor = Color.fromARGB(255, 42, 185, 42);
                if (isTaken == true) {
                  responseMessage = "The name " +
                      name +
                      " has been taken. Enter another name.";
                  alert = "Failed!!";
                  bgColor = Color.fromARGB(255, 230, 128, 128);
                }

                // // ignore: use_build_context_synchronously
                _showDialog(context, responseMessage, alert, bgColor);
                await Future.delayed(const Duration(seconds: 2), () {});

                if (alert == "Success!!") {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MenuOptionsScreen();
                  }));
                }
              },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).accentColor),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                  textStyle: MaterialStateProperty.all(TextStyle(
                    color: Colors.black,
                  )),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              child: Text('SUBMIT',
                  style: TextStyle(fontSize: 25, color: Colors.black)),
            ),

            //displays the data on the screen
          ],
        ),
      ),
    );
  }

  void _showDialog(
      BuildContext context, var message, var alert, Color bgColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: bgColor,
          title: new Text(alert),
          content: new Text(message),
          actions: <Widget>[
            new TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
