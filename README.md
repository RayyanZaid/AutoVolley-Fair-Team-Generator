# AutoVolley Fair Team Generator

Ever have a difficult time deciding what the teams should be when playing with your friends? This IOS app takes that problem away. By keeping track of player statistics and creating the most fair teams, this app will bring more fun and competition to your sports games!

# ***My Inspiration***

With the school year coming to an end, my friends and I devoted a lot of our time into playing Volleyball. However, every time we played there seemed to be a problem. It would take us ages to decide how the teams should be split. As we struggled to create the most optimal teams, the idea of creating this app popped into my head. After developing and publishing this app, our team selections were done within milliseconds, allowing us to focus and enjoy Volleyball.

# ***What it does***

Combining Python SQL and AI, this app tracks the Win:Loss Ratio of each player. It then utilizes that information to create the most balanced teams.

# ***How it was done***

## Frontend (UI) : Flutter Dart

All the user interface and navigation of the app was done using the frontend technology Flutter. 

##PIC HERE

## Backend (Server and Algorithms) : Python

All the behind the scenes work is done through the interpreted programming language Python. This includes:

1. The TeamChooser Algorithm 
2. Sending SQL Queries to the Azure SQL Database to POST and GET information about each player
3. The Flask Server API that is in charge of sending CRUD requests to both the frontend and database.

##PIC HERE

## Database : Azure SQL

Utilized the relational SQL database from Azure Services to store information about a player

##PIC HERE

UML Diagram

##PIC HERE

Database in Azure Studio

## App Flow Diagram

(shows how Frontend works with Backend and Database)

https://www.figma.com/file/fNjfp6abmyByEKXKPpbO6C/AutoVolley?node-id=0%3A1

## Docker and Azure Services
