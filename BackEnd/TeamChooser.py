
from Player import Player
import database # to create the playerObjects
import math
import sys






# Algorithm to figure out the teams that have the most even WL ratio average

# 1) sort the list by WL ratio, ascending

# 2) Append mirror players with each other (e.g first and first to last, second and second to last)

# 3) calculate WL ratio difference and see how much to switch



#    1      2    3     4      5     6
#  Ridwan Gabe Rayyan Sameer Ryan Isaiah 

def createTeams(playerList,team1,team2):
    
    playerObjectList = database.createPlayerObjects(playerList)
    print(len(playerObjectList))
    playerObjectList.sort(key=lambda x: x.WLRatio)
    for i in range(len(playerObjectList) // 4):
        team1.append(playerObjectList[i])
        team1.append(playerObjectList[len(playerObjectList)-i - 1])
    
    if(len(playerObjectList) % 2 == 1):
        team1.append(playerObjectList[len(playerObjectList) // 2])
    
    for i in range(len(playerObjectList) // 4,len(playerObjectList) // 2):
        if(len(playerObjectList) % 2 == 0 and i == len(playerObjectList) // 2 - 1  and len(playerObjectList) % 4 != 0):
            team1.append(playerObjectList[i])
        else:
            team2.append(playerObjectList[i])
        team2.append(playerObjectList[len(playerObjectList) - i - 1])
  
    avgOf1 = calcAvg(team1)
    avgOf2 = calcAvg(team2)
    
    
    differenceOfAvgs = abs(avgOf2 - avgOf1)

    avgOf1IsMore = False
    if(avgOf1 > avgOf2):
        avgOf1IsMore = True
        
    rearrangeTeams(differenceOfAvgs,team1,team2,avgOf1IsMore)

    

    


def calcAvg(team):
    sum = 0
    for eachPlayer in team:
        sum+=eachPlayer.WLRatio
    
    
    return float(sum) / len(team)


    
def rearrangeTeams(differenceOfAvgs, team1, team2, avgOf1IsMore):
    
    
    numTimesWithoutChange = 0

    
    while(numTimesWithoutChange <= 4 and differenceOfAvgs >= 0):
        AverageShiftToValueOfWL = {

        }
        isChanged = False
        optimalAverageShift = sys.maxsize

        
        for eachPlayer1 in team1:

            for eachPlayer2 in team2:

                if(avgOf1IsMore and eachPlayer1.WLRatio < eachPlayer2.WLRatio):
                    continue
                if(not avgOf1IsMore and eachPlayer2.WLRatio < eachPlayer1.WLRatio):
                    continue


                differenceBetweenValues = abs(eachPlayer1.WLRatio - eachPlayer2.WLRatio)

                # Change from switching each pair of values                
                avgChange1 = differenceBetweenValues/float(len(team1))
                avgChange2 = differenceBetweenValues/float(len(team2))
                
                    
                totalAvgChange = avgChange1 + avgChange2
                averageShift = abs(totalAvgChange - differenceOfAvgs)

                optimalAverageShift = min(optimalAverageShift,averageShift)

                AverageShiftToValueOfWL[averageShift] = (eachPlayer1, eachPlayer2)

              
        playersToSwitch = AverageShiftToValueOfWL[optimalAverageShift]
        
        indexOfSwitch1 = team1.index(playersToSwitch[0])
        indexOfSwitch2 = team2.index(playersToSwitch[1])
        team1[indexOfSwitch1] = playersToSwitch[1]
        team2[indexOfSwitch2] = playersToSwitch[0]
        newAvg1 = calcAvg(team1)
        newAvg2 = calcAvg(team2) 
        if(abs(newAvg2-newAvg1) >= differenceOfAvgs):
            indexOfSwitch1 = team1.index(playersToSwitch[1])
            indexOfSwitch2 = team2.index(playersToSwitch[0])
            team1[indexOfSwitch1] = playersToSwitch[0]
            team2[indexOfSwitch2] = playersToSwitch[1]
            numTimesWithoutChange+=1
        else:
            differenceOfAvgs = abs(newAvg2-newAvg1)
            numTimesWithoutChange = 0







