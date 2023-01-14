library my_prj.globals;

var playerList = [];
var playersPlaying;

List<dynamic> team1Names = [];
List<dynamic> team2Names = [];

List<dynamic> team1winPercentages = [];
List<dynamic> team2winPercentages = [];

final updatedWinning = List<String>.generate(22, (int index) => '');
final updatedLosing = List<String>.generate(22, (int index) => '');

bool team1Won = true;

var playerStatsNames = [];
var playerStatWins = [];
var playerStatLosses = [];
var playerStatWPS = [];

var team1Stats;
var team2Stats;

// Old server
// var localURL = 'https://autovolley.azurewebsites.net';

// Working server
// var localURL = 'http://0.0.0.0:5000';

// For testing
var localURL = 'http://192.168.4.45:5000';

// To Test right before pushing to Azure
// var localURL = "http://172.17.0.2:5000";
