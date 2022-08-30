class Player:
    def __init__(self, name, WLRatio):
        self.name = name
        
        self.WLRatio = WLRatio
    

    def printStats(self):
        print('Name: ' + self.name)
        print('WL Ratio: ' + str(self.WLRatio))

    

    