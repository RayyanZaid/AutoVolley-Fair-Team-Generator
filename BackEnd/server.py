#performing flask imports
from flask import Flask,jsonify
import database
from flask import request, json
import TeamChooser








        




response = ''
app = Flask(__name__) #instance of our flask application 





#Route '/' to facilitate get request from our flutter app

@app.route('/', methods = ['GET','POST'])
def index():
    return jsonify({'Welcome' : "Volleyball Project"})

@app.route('/addNewPlayer', methods = ['GET','POST'])
def add():
    global response
    
    if(request.method == 'POST'):
        print('good')
        request_data = request.data #getting the response data
        request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
        name = request_data['name'] #assigning it to name
        name = name.strip()

        # call function to remove any unnessecary whitespace


        # call checkDuplicates function in database.py (will return bool)
        alreadyExists = database.checkDuplicates(name)
        if(alreadyExists):
            print('Tell user to input another name')
            
        else:
            
            database.addNewPlayer(name)
            # this function inserts a new player in the database with all stats set to 0
            
        # if it already exists, the program tells the user to type another name
        return jsonify({'name' : name ,'isTaken': alreadyExists})



@app.route('/sendPlayersToFrontEnd', methods = ['GET','POST'])
def sendPlayers():
    list = database.sendPlayerList()
    return jsonify({'list' : list})

@app.route('/sendPlayerStats', methods = ['GET','POST'])
def sendStats():
    names, wins, losses, wps = database.sendPlayerStatList()
    return jsonify({'names' : names, 'wins' : wins, 'losses' : losses, 'WinPercentage' : wps })

# Get the list of names from the frontend
@app.route('/createTeams', methods = ['GET', 'POST'])
def createTeams():
    
    request_data = request.data #getting the response data
    request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
    playersPlayingList = request_data['playersPlaying']
    # for player in playersPlayingList:
    #     print(player)
    # call method on playersPlaying list to make it into 2 separate lists

    team1 = []
    team2 = []
    TeamChooser.createTeams(playersPlayingList,team1,team2)
    print('Team 1: ')
    for p in team1:
        print(p.name)
    print('Team 2: ')
    for p in team2:
        print(p.name)
    
    team1Names = []
    team1WLRatios = []
    for eachPlayer in team1:
        team1Names.append(eachPlayer.name)
        team1WLRatios.append(eachPlayer.WLRatio)

    team2Names = []
    team2WLRatios = []
    for eachPlayer in team2:
        team2Names.append(eachPlayer.name)
        team2WLRatios.append(eachPlayer.WLRatio)
    
    print('hi')
    
   # will send back 2 lists (one for each team)
    return jsonify({'team1Names' : team1Names , 'team1WLRatios' : team1WLRatios, 'team2Names' : team2Names , 'team2WLRatios' : team2WLRatios})
    
@app.route('/sendResults', methods = ['GET', 'POST'])
def sendResults():
    request_data = request.data #getting the response data
    request_data = json.loads(request_data.decode('utf-8')) #converting it from json to key value pair
    winning_team = request_data['winning_team'] #assigning it to name
    losing_team = request_data['losing_team']

    updatedWLRatioWinningTeam, updatedWLRatioLosingTeam = database.updateStats(winning_team, losing_team)

    return jsonify({'updatedWinningWLRatios' : updatedWLRatioWinningTeam, 'updatedLosingWLRatios' : updatedWLRatioLosingTeam})
    

    
if __name__ == "__main__":
    app.run(host="0.0.0.0", debug = True) #debug will allow changes without shutting down the server 

    # For local debugging, change to IPV4 address in quotes ex. "192.168.4.45"
    # For public launch, change to "0.0.0.0"