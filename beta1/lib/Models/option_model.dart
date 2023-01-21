import 'package:flutter/material.dart';

class Option {
  Icon icon;
  String title;
  String subtitle;

  Option({required this.icon, required this.title, required this.subtitle});
}

final options = [
  Option(
    icon: Icon(
      Icons.add,
      size: 40.0,
      color: Colors.white,
    ),
    title: 'Add New Players',
    subtitle: 'Before you play!',
  ),
  Option(
    icon: Icon(
      Icons.play_arrow,
      size: 40.0,
      color: Colors.white,
    ),
    title: 'Play Match',
    subtitle: 'Will auto-generate fair teams',
  ),
  Option(
    icon: Icon(
      Icons.account_circle,
      size: 40.0,
      color: Colors.white,
    ),
    title: 'View Player Stats',
    subtitle: 'Wins, Losses, and Win %',
  ),
  Option(
    icon: Icon(
      Icons.delete,
      size: 40.0,
      color: Colors.white,
    ),
    title: 'Delete Player',
    subtitle: 'Remove player from the database',
  ),

  // Option(
  //   icon: Icon(Icons.invert_colors, size: 40.0, color: Colors.white),
  //   title: 'AI Trainer',
  //   subtitle: 'Coming Soon',
  // ),
];
