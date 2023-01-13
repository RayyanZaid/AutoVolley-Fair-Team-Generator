import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:beta1/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

import 'package:beta1/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:beta1/matchScreen.dart';

class PlayerStatsPage extends StatefulWidget {
  const PlayerStatsPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  PlayerStatsPageState createState() => PlayerStatsPageState();
}

class Player {
  String strPlayerName;
  String wins;
  String losses;
  String wps;
  Player(this.strPlayerName, this.wins, this.losses, this.wps);
// switched order of < and > so that quicksort would work in reverse
  bool operator <(Player other) {
    return double.parse(wps) > double.parse(other.wps);
  }

  bool operator >(Player other) {
    return double.parse(wps) < double.parse(other.wps);
  }
}

void quickSort(List<Player> arr, int low, int high) {
  if (low < high) {
    int pivotIndex = partition(arr, low, high);
    quickSort(arr, low, pivotIndex);
    quickSort(arr, pivotIndex + 1, high);
  }
}

int partition(List<Player> arr, int low, int high) {
  Player pivot = arr[low];
  int i = low - 1;
  int j = high + 1;
  while (true) {
    do {
      i++;
    } while (arr[i] < pivot);
    do {
      j--;
    } while (arr[j] > pivot);
    if (i >= j) {
      return j;
    }
    Player temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }
}

List<Player> createButtons() {
  List<Player> players = [];
  Player first = Player('Name', 'Wins', 'Losses', 'Win Percentage');
  players.add(first);
  for (int i = 0; i < globals.playerStatsNames.length; i++) {
    Player eachPlayer = Player(
        globals.playerStatsNames[i].toString(),
        globals.playerStatWins[i].toString(),
        globals.playerStatLosses[i].toString(),
        globals.playerStatWPS[i].toString());
    players.add(eachPlayer);
  }

  quickSort(players, 1, players.length - 1);

  return players;
}

class PlayerStatsPageState extends State<PlayerStatsPage> {
  List<Player> playerListLocal = createButtons();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Stats'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            fit: BoxFit.fill,
            image: NetworkImage(
              'https://source.unsplash.com/5nUNdLueQio',
            ),
          ),
        ),
        child: ListView.builder(
          itemCount: playerListLocal.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 1) {}
            return GestureDetector(
                child: Container(
                    height: 45.0,
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          // no padding
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight:
                                              const Radius.circular(10.0))),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                              playerListLocal[index]
                                                  .strPlayerName,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                              playerListLocal[index].wins,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                              playerListLocal[index].losses,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                      Container(
                                          width: width / 4,
                                          height: 40.0,
                                          alignment: Alignment.center,
                                          child: Text(
                                              playerListLocal[index].wps,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 15)),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                    ],
                                  )),
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
    );
  }
}
