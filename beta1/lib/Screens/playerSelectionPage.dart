import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

import 'package:beta1/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beta1/matchScreen.dart';

class PlayerSelectionPage extends StatefulWidget {
  const PlayerSelectionPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  PlayerSelectionPageState createState() => PlayerSelectionPageState();
}

class Player {
  String strPlayerName;
  var isChosen = false;
  Player(this.strPlayerName);
}

List<Player> createButtons() {
  List<Player> players = [];
  for (int i = 0; i < globals.playerList.length; i++) {
    Player eachPlayer = Player(globals.playerList[i].toString());
    players.add(eachPlayer);
  }

  return players;
}

class PlayerSelectionPageState extends State<PlayerSelectionPage> {
  List<Player> playerListLocal = createButtons();

  List<String> getPlayers() {
    List<String> playersPlaying = [];
    for (int i = 0; i < playerListLocal.length; i++) {
      if (playerListLocal[i].isChosen) {
        playersPlaying.add(playerListLocal[i].strPlayerName);
      }
    }
    return playersPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose who will play'),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/b2.jpeg"), fit: BoxFit.cover)),
        alignment: Alignment.bottomCenter,
        child: ListView.builder(
          itemCount: playerListLocal.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                child: Container(
                    height: 45.0,
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: const Radius.circular(10.0))),
                                child: Container(
                                    width: 120.0,
                                    height: 40.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                        playerListLocal[index].strPlayerName,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 62, 157, 239),
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    playerListLocal[index].isChosen =
                                        !playerListLocal[index].isChosen;
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(0.0),
                                    child: Icon(
                                      playerListLocal[index].isChosen
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: Colors.blue,
                                      size: 30.0,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )

                    //note
                    ));
          },
        ),
      ),
      bottomNavigationBar: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size(280, 80),
              textStyle: TextStyle(fontSize: 28),
              padding: EdgeInsets.only(top: 30, bottom: 30)),
          child: const Text('Start match'),
          onPressed: () async {
            List<String> playersPlaying = getPlayers();

            // for loop just for debugging
            // for (int i = 0; i < playersPlaying.length; i++) {
            //   debugPrint(playersPlaying[i]);
            // }

            final url = 'https://rayyanzaid.azurewebsites.net/createTeams';
            final response = await http.post(Uri.parse(url),
                body: json.encode({'playersPlaying': playersPlaying}));

            // player objects from the backend
            final decoded = json.decode(response.body) as Map<String, dynamic>;

            List<dynamic> team1Names = decoded['team1Names'];
            List<dynamic> team1WLRatios = decoded['team1WLRatios'];
            globals.team1Names = team1Names;
            globals.team1WLRatios = team1WLRatios;

            for (int i = 0; i < team1Names.length; i++) {
              debugPrint(team1Names[i].toString());
            }

            List<dynamic> team2Names = decoded['team2Names'];
            List<dynamic> team2WLRatios = decoded['team2WLRatios'];
            globals.team2Names = team2Names;
            globals.team2WLRatios = team2WLRatios;

            for (int i = 0; i < team2Names.length; i++) {
              debugPrint(team2Names[i].toString());
            }

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MatchScreenPage(
                title: 'Match Screen',
              );
            }));
          }),
    );
  }
}
