import './successful_screen.dart';
import 'package:beta1/globals.dart' as globals;
import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'welcome_screen.dart';

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
            alignment: Alignment.topCenter,
            fit: BoxFit.fill,
            image: NetworkImage(
              'https://source.unsplash.com/igpV55ldAKE',
            ),
          ),
        ),
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

                //url to send the post request to
                // ignore: prefer_const_declarations
                final url = globals.localURL + '/addNewPlayer';
                /*
              A Uri object is usually used to tell a ContentProvider what 
              we want to access by reference. It is an immutable one-to-one 
              mapping to a resource or data. The method Uri. parse 
              creates a new Uri object from a properly formated String
              */
                //sending a post request to the url
                bool isTaken = false;
                final response = await http.post(Uri.parse(url),
                    body: json.encode({'name': name, 'isTaken': isTaken}));
                final decoded =
                    json.decode(response.body) as Map<String, dynamic>;
                var nameFromBackEnd = decoded['name'];
                bool isTakenFromBackEnd = decoded['isTaken'];
                var responseMessage =
                    nameFromBackEnd + " has been added as a player";
                var alert = "Success!!";
                var bgColor = Color.fromARGB(255, 42, 185, 42);
                if (isTakenFromBackEnd == true) {
                  responseMessage = "The name " +
                      nameFromBackEnd +
                      " has been taken. Enter another name.";
                  alert = "Failed!!";
                  bgColor = Color.fromARGB(255, 230, 128, 128);
                }

                // ignore: use_build_context_synchronously
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
