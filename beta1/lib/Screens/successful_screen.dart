import 'package:beta1/Screens/playerStats.dart';

import './welcome_screen.dart';

import 'package:flutter/material.dart';
import '../Models/option_model.dart';
import 'package:beta1/globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'playerSelectionPage.dart';
import 'newPlayerPage.dart';

class MenuOptionsScreen extends StatefulWidget {
  @override
  _MenuOptionsScreenState createState() => _MenuOptionsScreenState();
}

List<dynamic> sortList(List<dynamic> parent, List<dynamic> child) {
  parent = parent.map((item) => double.parse(item)).toList();
  List<dynamic> sortedRatios = List.from(parent)..sort();

  var childValues = Map.fromIterables(child, parent);

  var sortedChildValues = Map.fromEntries(
      childValues.entries.toList()..sort((a, b) => a.value.compareTo(b.value)));
  List<dynamic> sortedChild = sortedChildValues.keys.toList();
  return sortedChild;
}

class _MenuOptionsScreenState extends State<MenuOptionsScreen> {
  int _selectedOption = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 78, 23, 186),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 41, 25, 87),
          title: Text('Menu Options'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            // FlatButton(
            //   textColor: Colors.white,
            //   child: Text(
            //     'Account Info',
            //     style: TextStyle(
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   onPressed: () => print('Account Info'),
            // )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
              image: NetworkImage(
                'https://source.unsplash.com/jAWfDKxRraI',
              ),
            ),
          ),
          child: ListView.builder(
            itemCount: options.length + 2,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return SizedBox(height: 15.0);
              } else if (index == options.length + 1) {
                return SizedBox(height: 100.0);
              }

              if (index == 1) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        'https://source.unsplash.com/M8Y59lwmKAk',
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: options[index - 1].icon,
                    title: Text(
                      options[index - 1].title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      options[index - 1].subtitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    selected: _selectedOption == index - 1,
                    onTap: () async {
                      // here

                      debugPrint('Add New Player Button clicked');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NewPlayerPage(
                          title: 'Add New Player',
                        );
                      }));
                    },
                  ),
                );
              }

              if (index == 2) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        'https://source.unsplash.com/-t40mnV3vAU',
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: options[index - 1].icon,
                    title: Text(
                      options[index - 1].title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      options[index - 1].subtitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    selected: _selectedOption == index - 1,
                    onTap: () async {
                      globals.playerList = [];

                      http.Response response = await http.get(
                        Uri.parse(
                            'https://autovolley-85d29-default-rtdb.firebaseio.com/players.json'),
                      );

                      try {
                        Map<String, dynamic> data = json.decode(response.body);

                        for (String key in data.keys) {
                          globals.playerList.add(key);
                        }
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PlayerSelectionPage(title: 'Player Selection');
                      }));
                    },
                  ),
                );
              }
              if (index == 3) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        'https://source.unsplash.com/Wb63zqJ5gnE',
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: options[index - 1].icon,
                    title: Text(
                      options[index - 1].title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      options[index - 1].subtitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    selected: _selectedOption == index - 1,
                    onTap: () async {
                      globals.playerStatsNames = [];
                      globals.playerStatWPS = [];
                      globals.playerStatLosses = [];
                      globals.playerStatWins = [];
                      http.Response response = await http.get(
                        Uri.parse(
                            'https://autovolley-85d29-default-rtdb.firebaseio.com/players.json'),
                      );

                      try {
                        Map<String, dynamic> data = json.decode(response.body);

                        for (String key in data.keys) {
                          globals.playerStatsNames.add(key);
                          globals.playerStatWins.add(data[key]['wins']);
                          globals.playerStatLosses.add(data[key]['losses']);
                          globals.playerStatWPS.add(data[key]['ratio']);
                        }

                        // sortList(
                        //     globals.playerStatWPS, globals.playerStatsNames);

                        // sortList(globals.playerStatWPS, globals.playerStatWins);
                        // sortList(
                        //     globals.playerStatWPS, globals.playerStatLosses);
                      } catch (e) {
                        debugPrint(e.toString());
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PlayerStatsPage(title: 'Player Stats');
                      }));
                    },
                  ),
                );
              } else {}
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10.0),
                width: double.infinity,
                height: 80.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      'https://source.unsplash.com/iar-afB0QQw',
                    ),
                  ),
                ),
                child: ListTile(
                  leading: options[index - 1].icon,
                  title: Text(
                    options[index - 1].title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  subtitle: Text(
                    options[index - 1].subtitle,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  selected: _selectedOption == index - 1,
                  onTap: () {},
                ),
              );
            },
          ),
        ),
        bottomSheet: Container(
            width: double.infinity,
            height: 80.0,
            color: Color.fromARGB(255, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WelcomeScreen();
                          }))
                        },
                    child: Text('Logout')),
              ],
            )));
  }
}
