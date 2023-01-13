import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

import 'package:beta1/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beta1/matchScreen.dart';

// RayyanZaid/PlayerSelectionPage

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

  // getters

}

Future<Map<String, dynamic>> returnStats(String name) async {
  http.Response response = await http.get(
    Uri.parse(
        'https://autovolley-85d29-default-rtdb.firebaseio.com/players/${name}.json'),
  );

  Map<String, dynamic> data = json.decode(response.body);

  return data;
}

double getPlayerWorth(int wins, int losses, double ratio) {
  double worth = ratio * (1 + ((wins - losses) / 25)) + ((wins + losses) / 200);
  return worth;
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
                                  debugPrint("Selected");
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

            // for (int i = 0; i < playersPlaying.length; i++) {
            //   debugPrint(playersPlaying[i]);
            // }

            // Send playersPlaying to Firebase to get the player's WL Ratios

            Map<String, dynamic> playerToStats = {};

            for (int i = 0; i < playersPlaying.length; i++) {
              Map<String, dynamic> eachPlayer =
                  await returnStats(playersPlaying[i]);
              playerToStats[playersPlaying[i]] = eachPlayer;
            }

            debugPrint(playerToStats.toString());

            // Create Algorithm to determine player's worth

            for (int i = 0; i < playersPlaying.length; i++) {
              int wins = playerToStats[playersPlaying[i]]["wins"];
              int losses = playerToStats[playersPlaying[i]]["losses"];
              double ratio = double.parse(
                  playerToStats[playersPlaying[i]]["ratio"].toString());
              debugPrint(playerToStats[playersPlaying[i]]["ratio"].toString());
              double worth = getPlayerWorth(wins, losses, ratio);

              playerToStats[playersPlaying[i]]["worth"] = worth;
            }

            // Put it into team creater algorithm

            // 1. Sort by worth

            List<String> keys = playerToStats.keys.toList();

// Sort the list of keys based on the values of the inner map
            keys.sort((k1, k2) => playerToStats[k1]['worth']
                .compareTo(playerToStats[k2]['worth']));

// Create a new map from the sorted keys
            Map<String, Map<String, dynamic>> sortedMap = Map.fromIterable(keys,
                key: (k) => k, value: (k) => playerToStats[k]);
            debugPrint(sortedMap.toString());

            // Return 2 lists (one for each team)

            // Azure

            // final url = 'https://rayyanzaid.azurewebsites.net/createTeams';
            // final response = await http.post(Uri.parse(url),
            //     body: json.encode({'playersPlaying': playersPlaying}));

            // // player objects from the backend
            // final decoded = json.decode(response.body) as Map<String, dynamic>;

            // List<dynamic> team1Names = decoded['team1Names'];
            // List<dynamic> team1WLRatios = decoded['team1WLRatios'];
            // globals.team1Names = team1Names;
            // globals.team1WLRatios = team1WLRatios;

            // for (int i = 0; i < team1Names.length; i++) {
            //   debugPrint(team1Names[i].toString());
            // }

            // List<dynamic> team2Names = decoded['team2Names'];
            // List<dynamic> team2WLRatios = decoded['team2WLRatios'];
            // globals.team2Names = team2Names;
            // globals.team2WLRatios = team2WLRatios;

            // for (int i = 0; i < team2Names.length; i++) {
            //   debugPrint(team2Names[i].toString());
            // }

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MatchScreenPage(
                title: 'Match Screen',
              );
            }));
          }),
    );
  }
}
