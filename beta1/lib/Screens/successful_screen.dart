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
                      final url = globals.localURL + '/sendPlayersToFrontEnd';
                      final response = await http.post(Uri.parse(url));
                      final decoded =
                          json.decode(response.body) as Map<String, dynamic>;
                      globals.playerList = decoded['list'];
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
                      final url = globals.localURL + '/sendPlayerStats';
                      final response = await http.post(Uri.parse(url));
                      final decoded =
                          json.decode(response.body) as Map<String, dynamic>;
                      globals.playerStatsNames = decoded['names'];
                      globals.playerStatWins = decoded['wins'];
                      globals.playerStatLosses = decoded['losses'];
                      globals.playerStatWPS = decoded['WinPercentage'];
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
