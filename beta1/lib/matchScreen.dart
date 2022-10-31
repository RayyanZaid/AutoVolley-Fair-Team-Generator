// ignore_for_file: deprecated_member_use

import 'package:beta1/Screens/playerSelectionPage.dart';

import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Screens/successful_screen.dart';

class MatchScreenPage extends StatefulWidget {
  const MatchScreenPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MatchScreenPageState createState() => MatchScreenPageState();
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      sender,
      style: Theme.of(context).textTheme.headline6,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(
      body,
      style: TextStyle(fontSize: 15),
      textAlign: TextAlign.center,
    );
  }
}

class MatchScreenPageState extends State<MatchScreenPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // for bottom nav
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    String responseMessage = "Play Again";
    String alert;
    var bgColor = Color.fromARGB(255, 9, 155, 82);
    globals.team1Won = true;
    final url = 'https://rayyanzaid.azurewebsites.net/sendResults';
    final response;
    if (index == 0) {
      alert = "Team 1 Won!!";
      _showDialog(context, responseMessage, alert, bgColor);

      // UPDATE WINS AND LOSSES ON THE DATABASE
      response = await http.post(Uri.parse(url),
          body: json.encode({
            'winning_team': globals.team1Names,
            'losing_team': globals.team2Names
          }));

      // RETURN WL Ratios back from database and update frontend
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> winningWLRatios = decoded['updatedWinningWLRatios'];
      List<dynamic> losingWLRatios = decoded['updatedLosingWLRatios'];

      for (int i = 0; i < winningWLRatios.length; i++) {
        globals.updatedWinning[i] = winningWLRatios[i].toString();
      }

      for (int i = 0; i < losingWLRatios.length; i++) {
        globals.updatedLosing[i] = losingWLRatios[i].toString();
      }
    } else if (index == 1) {
      alert = "Team 2 Won!!";
      globals.team1Won = false;
      _showDialog(context, responseMessage, alert, bgColor);
      response = await http.post(Uri.parse(url),
          body: json.encode({
            'winning_team': globals.team2Names,
            'losing_team': globals.team1Names
          }));

      final decoded = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> winningWLRatios = decoded['updatedWinningWLRatios'];
      List<dynamic> losingWLRatios = decoded['updatedLosingWLRatios'];

      for (int i = 0; i < winningWLRatios.length; i++) {
        globals.updatedWinning[i] = winningWLRatios[i].toString();
      }

      for (int i = 0; i < losingWLRatios.length; i++) {
        globals.updatedLosing[i] = losingWLRatios[i].toString();
      }
    } else {
      Navigator.pop(context);
    }
  }

  void updateWL(
      List<dynamic> team1WLRatios, List<dynamic> team2WLRatios, bool team1Won) {
    if (team1Won) {
      for (int i = 0; i < team1WLRatios.length; i++) {
        team1WLRatios[i] = globals.updatedWinning[i];
      }
      for (int i = 0; i < team2WLRatios.length; i++) {
        team2WLRatios[i] = globals.updatedLosing[i];
      }
    } else {
      for (int i = 0; i < team1WLRatios.length; i++) {
        team1WLRatios[i] = globals.updatedLosing[i];
      }
      for (int i = 0; i < team2WLRatios.length; i++) {
        team2WLRatios[i] = globals.updatedWinning[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> teams = [];

    teams.add(HeadingItem("After each game, select which team won"));

    teams.add(HeadingItem(''));

    teams.add(HeadingItem('Team 1'));
    teams.add(HeadingItem(''));
    for (int i = 0; i < globals.team1Names.length; i++) {
      String eachName = globals.team1Names[i];
      String WLRatio = 'W/L: ' + globals.team1WLRatios[i].toString();
      teams.add(MessageItem(eachName, WLRatio));
    }
    teams.add(HeadingItem(''));
    teams.add(HeadingItem(''));
    int index2BeforeTeam2 = teams.length - 2;
    int indexBeforeTeam2 = teams.length - 1;
    int indexOfTeam2 = indexBeforeTeam2 + 1;
    bool isBeforeTeam2 = true;
    teams.add(HeadingItem('Team 2'));
    teams.add(HeadingItem(''));
    for (int i = 0; i < globals.team2Names.length; i++) {
      String eachName = globals.team2Names[i];
      String WLRatio = 'W/L: ' + globals.team2WLRatios[i].toString();
      teams.add(MessageItem(eachName, WLRatio));
    }
    // if (globals.updatedWinning.isNotEmpty) {
    //   updateWL(globals.team1WLRatios, globals.team2WLRatios, globals.team1Won);
    // }
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 15, 174, 227),
          title: Text('Match Screen'),
          leading: FlatButton(
            textColor: Colors.black,
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MenuOptionsScreen();
            })),
            child: Icon(
              Icons.home,
            ),
          ),
          actions: <Widget>[],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                fit: BoxFit.fill,
                image: NetworkImage(
                  'https://source.unsplash.com/uIot6M34igU',
                ),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: teams.length,
              itemBuilder: (BuildContext context, int index) {
                final player = teams[index];

                if (index == indexBeforeTeam2 || index == index2BeforeTeam2) {
                  isBeforeTeam2 = false;
                  return Container(
                    width: 50.0,
                    height: 60.0,
                    alignment: Alignment.center,
                  );
                }

                if (index == 2) {
                  return Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            String responseMessage = "Play Again";
                            String alert;
                            var bgColor = Color.fromARGB(255, 60, 186, 232);
                            globals.team1Won = true;
                            final url = 'https://rayyanzaid.azurewebsites.net/sendResults';
                            final response;

                            alert = "Team 1 Won!!";
                            _showDialog(
                                context, responseMessage, alert, bgColor);

                            // UPDATE WINS AND LOSSES ON THE DATABASE
                            response = await http.post(Uri.parse(url),
                                body: json.encode({
                                  'winning_team': globals.team1Names,
                                  'losing_team': globals.team2Names
                                }));

                            // RETURN WL Ratios back from database and update frontend
                            final decoded = json.decode(response.body)
                                as Map<String, dynamic>;
                            List<dynamic> winningWLRatios =
                                decoded['updatedWinningWLRatios'];
                            List<dynamic> losingWLRatios =
                                decoded['updatedLosingWLRatios'];

                            for (int i = 0; i < winningWLRatios.length; i++) {
                              globals.updatedWinning[i] =
                                  winningWLRatios[i].toString();
                            }

                            for (int i = 0; i < losingWLRatios.length; i++) {
                              globals.updatedLosing[i] =
                                  losingWLRatios[i].toString();
                            }
                          },
                          icon: Icon(
                            Icons.ads_click_rounded,
                          ),
                          label: Text(
                            "Team 1",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 60, 186, 232),
                          )));
                }

                if (index == indexOfTeam2) {
                  return Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            String responseMessage = "Play Again";
                            String alert;
                            var bgColor = Color.fromARGB(255, 235, 123, 101);

                            final url = 'https://rayyanzaid.azurewebsites.net/sendResults';
                            final response;
                            alert = "Team 2 Won!!";
                            globals.team1Won = false;
                            _showDialog(
                                context, responseMessage, alert, bgColor);
                            response = await http.post(Uri.parse(url),
                                body: json.encode({
                                  'winning_team': globals.team2Names,
                                  'losing_team': globals.team1Names
                                }));

                            final decoded = json.decode(response.body)
                                as Map<String, dynamic>;
                            List<dynamic> winningWLRatios =
                                decoded['updatedWinningWLRatios'];
                            List<dynamic> losingWLRatios =
                                decoded['updatedLosingWLRatios'];

                            for (int i = 0; i < winningWLRatios.length; i++) {
                              globals.updatedWinning[i] =
                                  winningWLRatios[i].toString();
                            }

                            for (int i = 0; i < losingWLRatios.length; i++) {
                              globals.updatedLosing[i] =
                                  losingWLRatios[i].toString();
                            }
                          },
                          icon: Icon(
                            Icons.ads_click_rounded,
                          ),
                          label: Text(
                            "Team 2",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 235, 123, 101),
                          )));
                }

                if (index == 3) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 200.0,
                          height: 10.0,
                          alignment: Alignment.center,
                          child: ListTile(
                            title: player.buildTitle(context),
                            subtitle: player.buildSubtitle(context),
                          ),
                        )
                      ]);
                }

                // for separation
                if (index == indexOfTeam2 + 1) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 200.0,
                          height: 10.0,
                          alignment: Alignment.center,
                          child: ListTile(
                            title: player.buildTitle(context),
                            subtitle: player.buildSubtitle(context),
                          ),
                        )
                      ]);
                }

                if (index == 4) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 200.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              title: player.buildTitle(context),
                              subtitle: player.buildSubtitle(context),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 60, 186, 232),
                                border: Border(
                                    top: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    left: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black))))
                      ]);
                }
                if (index == index2BeforeTeam2 - 1) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 200.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              title: player.buildTitle(context),
                              subtitle: player.buildSubtitle(context),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 60, 186, 232),
                                border: Border(
                                    left: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 6.0, color: Colors.black))))
                      ]);
                }
                if (index > 4 && index < index2BeforeTeam2) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 200.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              title: player.buildTitle(context),
                              subtitle: player.buildSubtitle(context),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 60, 186, 232),
                                border: Border(
                                    left: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.black))))
                      ]);
                }
                if (index == indexOfTeam2 + 2) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 200.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              title: player.buildTitle(context),
                              subtitle: player.buildSubtitle(context),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 123, 101),
                                border: Border(
                                    top: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    left: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black))))
                      ]);
                }

                if (index == teams.length - 1) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 200.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              title: player.buildTitle(context),
                              subtitle: player.buildSubtitle(context),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 123, 101),
                                border: Border(
                                    left: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 6.0, color: Colors.black))))
                      ]);
                }
                if (index > indexOfTeam2 + 1 && index < teams.length) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 200.0,
                            height: 60.0,
                            alignment: Alignment.center,
                            child: ListTile(
                              title: player.buildTitle(context),
                              subtitle: player.buildSubtitle(context),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 235, 123, 101),
                                border: Border(
                                    left: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    right: BorderSide(
                                        width: 6.0, color: Colors.black),
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.black))))
                      ]);
                }

                return ListTile(
                  title: player.buildTitle(context),
                  subtitle: player.buildSubtitle(context),
                );
              },
            )),
        bottomNavigationBar: ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.ads_click_rounded,
            ),
            label: Text(
              "Switch Teams",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            style: TextButton.styleFrom(
              minimumSize: Size(280, 80),
              textStyle: TextStyle(fontSize: 28),
              padding: EdgeInsets.only(top: 30, bottom: 30),
              backgroundColor: Color.fromARGB(255, 21, 177, 47),
            )));
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
              child: new Text("OK", style: TextStyle(color: Colors.black)),
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
