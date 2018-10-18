stuff = {}

for i  in [2,4,5,8,10,16,20,24,32]:
	numRanks = i*i*i
	stuff[numRanks] = []
	for j in range(0,numRanks):
		stuff[numRanks].append({})
		col = j%i
		row = int(j/i)%i
		plane = int(j/(i*i))
		if row == 0 :
			stuff[numRanks][j]["rowmin"] = 0
		else:
			stuff[numRanks][j]["rowmin"] = 1
		if row == i-1 :
			stuff[numRanks][j]["rowmax"] = 0
		else:
			stuff[numRanks][j]["rowmax"] = 1
		if col == 0 :
			stuff[numRanks][j]["colmin"] = 0
		else:
			stuff[numRanks][j]["colmin"] = 1
		if col == i-1 :
			stuff[numRanks][j]["colmax"] = 0
		else:
			stuff[numRanks][j]["colmax"] = 1
		if plane == 0 :
			stuff[numRanks][j]["planemin"] = 0
		else:
			stuff[numRanks][j]["planemin"] = 1
		if plane == i-1 :
			stuff[numRanks][j]["planemax"] = 0
		else:
			stuff[numRanks][j]["planemax"] = 1
		stuff[numRanks][j]["Zminus"] = j - (i*i)
		stuff[numRanks][j]["Zplus"] = j + (i*i)
		stuff[numRanks][j]["Yminus"] = j - i
		stuff[numRanks][j]["Yplus"] = j + i
		stuff[numRanks][j]["Xminus"] = j - 1
		stuff[numRanks][j]["Xplus"] = j + 1


#print(stuff)
		
