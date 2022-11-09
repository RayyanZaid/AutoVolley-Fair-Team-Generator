import mysql.connector
from mysql.connector import Error
from Player import Player
import pymssql

from dotenv import load_dotenv

load_dotenv()


# def create_server_connection(host_name, user_name, user_password):
#     connection = None
    
#     try:
#         # Establishes session w/ mySQL server
#         connection = mysql.connector.connect(host = host_name, user = user_name, password = user_password)
#         print("Database Connection is successful")
#     except Error as err:
#         print(f"Error{err}")
    
#     return connection

# password = ''
# connection = create_server_connection("localhost", "root" , password)


def connect_to_database(host_name,username,user_password,db_name):
    connection = None

    try:
        connection = mysql.connector.connect(
            host = host_name,
            user = username,
            password = user_password,
            database = db_name
        )

    except Error as err:
        print(f"Error {err}")

    return connection

# connection = connect_to_database("localhost","root",'',"volleyball")

def query_executer(connection,query):
    cursor = connection.cursor()

    try:
        cursor.execute(query)
        connection.commit()

    except Error as err:
        print(f"Error {err}")



server = os.getenv('server')
database = os.getenv('database')
username = os.getenv('username')
password = os.getenv('password')


connection = pymssql.connect(server,username,password,database)
cursor = connection.cursor()


# Connected to database (if the preceding lines work)

def addNewPlayer(playerName):
    addNewPlayerQuery = f"""
    INSERT INTO playerstats(name, wins, losses,WLRatio)
    VALUES('{playerName}', 0,0,0);
"""
    query_executer(connection, addNewPlayerQuery)

    


# return bool
def checkDuplicates(name):
    cursor = connection.cursor()
    query = f"""
        SELECT name FROM playerstats
    """
    isDuplicate = False
    try:
        cursor.execute(query)

        records = cursor.fetchall()
        for eachRow in records:
            eachPlayerNameInDatabase = str(eachRow[0])
            if(name == eachPlayerNameInDatabase):
                isDuplicate = True
        if(name == ''):
            isDuplicate = True
        connection.commit()

    except Error as err:
        print(f"Error {err}")
    
    if(isDuplicate):
        return True
    
    return False


def sendPlayerStatList():
    playerNamesList = []
    playerWinsList = []
    playerLossesList = []
    wps = []
    cursor = connection.cursor()
    query = """
    SELECT name, wins, losses FROM playerstats ORDER BY playerstats.WLRatio DESC
    """

    try:
        cursor.execute(query)

        records = cursor.fetchall()
        for eachRow in records:
            playerNamesList.append(str(eachRow[0]))
            playerWinsList.append(str(eachRow[1]))
            playerLossesList.append(str(eachRow[2]))
            


        connection.commit()

        for i in range(len(playerWinsList)):
            if(int(playerLossesList[i]) + int(playerWinsList[i]) > 0):
                eachWP = (int(playerWinsList[i]) / (int(playerLossesList[i]) + int(playerWinsList[i]))) * 100
                eachWP = round(eachWP,2)
            else:
                eachWP = 0
            wps.append(str(eachWP) + '%')
            print(eachWP)
        return playerNamesList, playerWinsList, playerLossesList, wps

    except Error as err:
        print(f"Error {err}")



# Returns a list
def sendPlayerList():
    playerList = []
    cursor = connection.cursor()
    query = """
    SELECT name FROM playerstats ORDER BY playerstats.name ASC
    """
    try:
        cursor.execute(query)

        records = cursor.fetchall()
        for eachRow in records:
            playerList.append(str(eachRow[0]))

        connection.commit()
    
        return playerList

    except Error as err:
        print(f"Error {err}")


# uses database to match each name to their W/L Ratio 
# then creates an object using the Player.py file
# each player has: 1. Name 2. W/L Ratio
def createPlayerObjects(playersPlayingList):
    playerObjectList = []
    cursor = connection.cursor()

    for players in playersPlayingList:

        query = f"""
        SELECT WLRatio FROM playerstats WHERE name = '{players}';
        """
        try:
            cursor.execute(query)

            records = cursor.fetchall()
            for eachRow in records:
                WLRatio = float(eachRow[0])
                playerName = str(players)
                eachPlayerObject = Player(playerName,WLRatio)

                playerObjectList.append(eachPlayerObject)

        except Error as err:
            print(f"Error {err}")
        
        
    connection.commit()
    return playerObjectList


# plist = ["Rayyan","Sameer"]

# pObjList = createPlayerObjects(plist)

# for p in pObjList:
#     print(p.name)
#     print(p.WLRatio)


# iterate through winning teams 
# for each player in team, 

# returns two lists of WLRatios (one list for each team)
def updateStats(winning_team, losing_team):
    updatedWLRatioWinningTeam = []
    updatedWLRatioLosingTeam = []

    cursor = connection.cursor()
    for p in winning_team:
        query = f"""
        UPDATE playerstats 
        SET wins = wins+1 
        WHERE name = '{p}';
        """
        try:
            cursor.execute(query)
        except Error as err:
            print(f"Error {err}")

        query2 = f"""
        SELECT wins,losses
        FROM playerstats
        WHERE name = '{p}'
        """

        try:
            cursor.execute(query2)

            records = cursor.fetchall()
            for eachRow in records:
                wins = float(eachRow[0])
                losses = float(eachRow[1])
                WLRatio = wins
                if(losses != 0):
                    WLRatio = wins / losses
                
                updatedWLRatioWinningTeam.append(WLRatio)

                query3 = f"""
                UPDATE playerstats
                SET WLRatio = {WLRatio}
                WHERE name = '{p}'
                """
                try:
                    cursor.execute(query3)
                except Error as err:
                    print(f"Error {err}")

        except Error as err:
            print(f"Error {err}")
    
    for p in losing_team:
        query = f"""
        UPDATE playerstats 
        SET losses = losses+1 
        WHERE name = '{p}';
        """
        try:
            cursor.execute(query)
        except Error as err:
            print(f"Error {err}")
        query2 = f"""
        SELECT wins,losses
        FROM playerstats
        WHERE name = '{p}'
        """

        try:
            cursor.execute(query2)

            records = cursor.fetchall()
            for eachRow in records:
                wins = float(eachRow[0])
                losses = float(eachRow[1])
                WLRatio = wins / losses
                if(losses == 0):
                    WLRatio = wins
                
                updatedWLRatioLosingTeam.append(WLRatio)

                query3 = f"""
                UPDATE playerstats
                SET WLRatio = {WLRatio}
                WHERE name = '{p}'
                """
                try:
                    cursor.execute(query3)
                except Error as err:
                    print(f"Error {err}")

        except Error as err:
            print(f"Error {err}")
        
    connection.commit()

    return updatedWLRatioWinningTeam, updatedWLRatioLosingTeam

    