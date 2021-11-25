% ************************************************************
% * Name:     Nima Naghizadehbaee                            *
% * Project:  Project 3 - Prolog Mexican Train               *
% * Class:    CMPS 366 - OPL                                 *
% * Date:     4/30/21                                        *
% ************************************************************

%             *****************************************************************************************
%                                         Source Code for structures used
%             *****************************************************************************************



% **************************
% Source Code for game facts
% **************************

%the game players
player(comp, 0).
player(human, 1).

%the event outcome
eventWinner(compWins, "COMPUTER").
eventWinner(humanWins, "HUMAN").
eventWinner(tied, "TIE").

%score comparison outcomes 
compOutcome(compLower, 0).
compOutcome(humanLower, 1).
compOutcome(tie, 2).

%coin toss
coin(heads, 0).
coin(tails, 1).

%the events
event(game, "GAME ").
event(round, "ROUND").

%the main menu options
mainMenu(newGame, 1).
mainMenu(loadGame, 2).

%the action menu options
actionMenu(saveGame, 1).
actionMenu(makeMove, 2).
actionMenu(getHelp, 3).
actionMenu(quitGame, 4).

%the train menu options
trainMenu(compTrain, 1).
trainMenu(humanTrain, 2).
trainMenu(mexicanTrain, 3).

%play another round menu options
decision(yes, 1).
decision(no, 2).



% ***************************************************
% Source Code to access and update elements of a tile
% ***************************************************

getFront([Front|_], Front).
getBack([_, Back|_], Back).
getSum([First|Rest], Sum):- Sum is First + Rest.		

isDouble(Tile, true):- 
	getFront(Tile, Front), getBack(Tile, Back), 
	Front =:= Back.
isDouble(_, false).

isNonDouble(Tile, true):- 
	getFront(Tile, Front), getBack(Tile, Back), 
	Front =\= Back.
isNonDouble(_, false).

isSameTile(TileOne, TileTwo, true):-  
	getFront(TileOne, FrontOne), getBack(TileOne, BackOne),
	getFront(TileTwo, FrontTwo), getBack(TileTwo, BackTwo),

	((FrontOne =:= FrontTwo, BackOne =:= BackTwo) ; (FrontOne =:= BackTwo, BackOne =:= FrontTwo)).
isSameTile(_, _, false).

isNotSameTile(TileOne, TileTwo, true):- 
	getFront(TileOne, FrontOne), getBack(TileOne, BackOne),
	getFront(TileTwo, FrontTwo), getBack(TileTwo, BackTwo),

	((FrontOne =\= FrontTwo, FrontOne =\= BackTwo) ; (BackOne =\= FrontTwo, BackOne =\= BackTwo)).
isNotSameTile(_, _, false).

flipTile(Tile, NewTile):- getFront(Tile, Front), getBack(Tile, Back), NewTile = [Back, Front].



% ***************************************************
% Source Code to access and update elements of a pile
% ***************************************************

% ******************************************************************************* 
% Clause Name: getTile
% Purpose: To find a tile in a pile based on its index
% Parameters: 
%			Pile, a list consisted of tiles (lists) 
%			TileIndex, the index of the tile in the pile

% Return Value: a tile
% Assistance Received: none 
% ******************************************************************************* 
getTile([Tile|_], 0, Tile).
getTile([_|Pile], TileIndex, Tile):- 
	TileIndex > 0, 
	NewTileIndex is TileIndex - 1, 
	getTile(Pile, NewTileIndex, Tile).

getLastTile([Tile], Tile).
getLastTile([_|Rest], Tile) :- getLastTile(Rest, Tile).

getTopTile([First|_], First). 

% ******************************************************************************* 
% Clause Name: getPilePipSum
% Purpose: To calculate the pip sum of all tiles in a pile
% Parameters: 
%			Pile, a list consisted of tiles (lists) 

% Return Value: an integer, indicating the pip sum of all tiles in the pile
% Assistance Received: none 
% ******************************************************************************* 
getPilePipSum([], 0).
getPilePipSum([First|Rest], Sum):-
	getPilePipSum(Rest, NewSum),
	getSum(First, TileSum),
	Sum is TileSum + NewSum.

% ******************************************************************************* 
% Clause Name: isInPile
% Purpose: To check whether a given tile is in a pile
% Parameters: 
%			Pile, a list consisted of tiles 
%			Tile, the tile to check if it exists in the pile

% Return Value: true if the tile is in the pile and false otherwise
% Assistance Received: none 
% ******************************************************************************* 
isInPile([], _, false).
isInPile([First|_], Tile, true):- isSameTile(First, Tile, SameTile), SameTile.
isInPile([_|Rest], Tile, Outcome):- isInPile(Rest, Tile, Outcome).

addToEnd(Pile, Tile, NewPile):- append(Pile, [Tile], NewPile).

addToFront(Pile, Tile, NewPile):-append([Tile], Pile, NewPile).

removeTile([First|Rest], Tile, Rest):- isSameTile(Tile, First, SameTile), SameTile.
removeTile([First|Rest], Tile, [First|Tail]) :- removeTile(Rest, Tile, Tail).

% ******************************************************************************* 
% Clause Name: removePile
% Purpose: To remove a collection of tiles from a bigger pile
% Parameters: 
%			GigPile, a list consisted of the greater number of tiles
%			Smallpile, a list consisted of the fewer number of tiles

% Return Value: a list, the bigger pile with the smaller pile removed from it
% Assistance Received: none 
% ******************************************************************************* 
removePile([], _, []).
removePile([First|Rest], SmallPile, Tail):- 
	isInPile(SmallPile, First, Exists), 
	Exists,
	removePile(Rest, SmallPile, Tail). 
removePile([First|Rest], SmallPile, [First|Tail]):- removePile(Rest, SmallPile, Tail).

% ******************************************************************************* 
% Clause Name: hasNonDouble
% Purpose: To check whether a pile has any non-double tiles in it
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: true if pile has any non-doubles and false otherwise
% Assistance Received: none 
% ******************************************************************************* 
hasNonDouble([], false).
hasNonDouble([First|_], true):- isNonDouble(First, NonDoubleTile), NonDoubleTile.
hasNonDouble([_|Rest], Outcome):- hasNonDouble(Rest, Outcome).

% ******************************************************************************* 
% Clause Name: flipPile
% Purpose: To switch the front and back values of all tiles in a pile
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: a list, the pile with all tiles flipped
% Assistance Received: none 
% ******************************************************************************* 
flipPile([], []).
flipPile([First|Rest], FlippedPile):-
	flipPile(Rest, NewPile),
	flipTile(First, FlippedTile),
	addToEnd(NewPile, FlippedTile, FlippedPile).

% ******************************************************************************* 
% Clause Name: getDoubles
% Purpose: To get all the double tiles in a pile
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: a list, consisting of double tiles in the pile
% Assistance Received: none 
% ******************************************************************************* 
getDoubles([],[]).
getDoubles([First|Rest], Doubles):-
	
	isDouble(First, DoubleTile),
	DoubleTile,
	getDoubles(Rest, NewDoubles),
	addToEnd(NewDoubles, First, Doubles).
getDoubles([First|Rest], Doubles):- 
	
	isNonDouble(First, NonDoubleTile),
	NonDoubleTile, 
	getDoubles(Rest, Doubles).

% ******************************************************************************* 
% Clause Name: getMaxTile
% Purpose: To identify the tile with the highest pip sum in a pile
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: a tile, with the highest pip sum in the pile
% Assistance Received: none 
% ******************************************************************************* 
getMaxTile([FirstTile], FirstTile).
getMaxTile([FirstTile, SecondTile|Rest], MaxTile):-
	getMaxTile([SecondTile|Rest], MaxTileRest), 
	maxTile(FirstTile, MaxTileRest, MaxTile).

maxTile(FirstTile, SecondTile, FirstTile):- 
	getSum(FirstTile, FirstSum), 
	getSum(SecondTile, SecondSum),
	FirstSum >= SecondSum.
maxTile(FirstTile, SecondTile, SecondTile):- 
	getSum(FirstTile, FirstSum), 
	getSum(SecondTile, SecondSum),
	FirstSum < SecondSum.

% ******************************************************************************* 
% Clause Name: getNTiles
% Purpose: To get the first n tiles of a pile
% Parameters: 
%			Pile, a list consisted of tiles
%			NumTiles, the number of tiles to get from the pile

% Return Value: the first n tiles of a pile as a list 
% Assistance Received: none 
% ******************************************************************************* 
getNTiles(_, 0, []).
getNTiles([First|Rest], NumTiles, NewPile):-

	NewNumTiles is NumTiles - 1,
	getNTiles(Rest, NewNumTiles, NewNewPile),

	%get the tile on the top and add it to thew new pile
	addToEnd(NewNewPile, First, NewPile).

% ******************************************************************************* 
% Clause Name: getRandomTile
% Purpose: To get a random tile from a pile
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: a tile
% Assistance Received: none 
% ******************************************************************************* 
getRandomTile(Pile, Tile):-
	length(Pile, Size),

	%generate random index between 0 and (Size - 1)
	random(0, Size, RandomNum),

	getTile(Pile, RandomNum, Tile).

% ******************************************************************************* 
% Clause Name: reverse
% Purpose: To reverse tiles in a pile
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: the reversed pile
% Assistance Received: none 
% ******************************************************************************* 
reverse([],[]).
reverse([First|Rest], NewList) :- 
	reverse(Rest, RevT),
	append(RevT, [First], NewList).

% ******************************************************************************* 
% Clause Name: shuffle
% Purpose: To shuffle tiles in a pile
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: the shuffled pile
% Assistance Received: none 
% ******************************************************************************* 
shuffle([], []).
shuffle(Pile, ShuffledPile):-
	getRandomTile(Pile, Tile),

	%remove the tile from the old pile
	removeTile(Pile, Tile, NewPile),

	shuffle(NewPile, NewShuffledPile),

	%add the tile to the shuffled pile
	addToEnd(NewShuffledPile, Tile, ShuffledPile).

% ******************************************************************************* 
% Clause Name: deleteLastElem
% Purpose: To remove the last tile in the pile
% Parameters: 
%			Pile, a list consisted of tiles

% Return Value: the pile with the last element removed
% Assistance Received: none 
% ******************************************************************************* 
deleteLastElem([_], []).
deleteLastElem([First, Next|Rest], [First|NTail]):-
  deleteLastElem([Next|Rest], NTail).



% ****************************************************
% Source Code to access and update elements of a train
% ****************************************************

% Train = [[Marked, Orphan], [Tile1], [Tile2], ...]

isTrainMarked([First|_], Bool):- [Bool|_] = First.

isTrainOrphan([First|_], Bool):- [_|Rest] = First, [Bool|_] = Rest.

% ******************************************************************************* 
% Clause Name: getTail
% Purpose: To get the last tile of a train
% Parameters: 
%			Train, a list consisted of tiles

% Return Value: the tile at the end of the train
% Assistance Received: none 
% ******************************************************************************* 
getTail(Train, Tile):- 
	getTrainTiles(Train, Tiles), 
	getLastTile(Tiles, Tile).

% ******************************************************************************* 
% Clause Name: getTailVal
% Purpose: To get the end value of a train
% Parameters: 
%			Train, a list consisted of tiles

% Return Value: the tail value of the train
% Assistance Received: none 
% ******************************************************************************* 
getTailVal(Train, TailVal):- 
	getTrainTiles(Train, Tiles), 
	getLastTile(Tiles, Tile),
	getBack(Tile, TailVal).

% ******************************************************************************* 
% Clause Name: isTailDouble
% Purpose: To check whether a train ends with a double tile 
% Parameters: 
%			Train, a list consisted of tiles

% Return Value: true if a train ends with a double and false otherwise 
% Assistance Received: none 
% ******************************************************************************* 
isTailDouble(Train, Bool):- 
	getTail(Train, Tile), 
	isDouble(Tile, Bool).

getTrainTiles([_|Rest], Rest).

% ******************************************************************************* 
% Clause Name: updateRegularMarker
% Purpose: To modify the marker that indicates whether a personal train is marked
% Parameters: 
%			Train, a list consisted of tiles
%			NewMarker, a boolean

% Return Value: the marked/unmarked train
% Assistance Received: none 
% ******************************************************************************* 
updateRegularMarker(Train, NewMarker, NewTrain):- 
	getTrainTiles(Train, Tiles),
	isTrainOrphan(Train, OrphanMarker),
	NewMarkers = [NewMarker, OrphanMarker],
	addToFront(Tiles, NewMarkers, NewTrain).

% ******************************************************************************* 
% Clause Name: updateOrphanMarker
% Purpose: To modify the marker that indicates whether a train is orphan double
% Parameters: 
%			Train, a list consisted of tiles
%			NewMarker, a boolean

% Return Value: the marked/unmarked train
% Assistance Received: none 
% ******************************************************************************* 
updateOrphanMarker(Train, NewMarker, NewTrain):- 
	getTrainTiles(Train, Tiles),
	isTrainMarked(Train, RegularMarker),
	NewMarkers = [RegularMarker, NewMarker],
	addToFront(Tiles, NewMarkers, NewTrain).

% ******************************************************************************* 
% Clause Name: unmarkPersonalTrain
% Purpose: To remove the personal marker from personal train
% Parameters: 
%			Train, a list consisted of tiles
%			TrainNum, an integer indicating the specific train
%			CurrentPlayer, an integer indicating computer or human player

% Return Value: the marked/unmarked train
% Assistance Received: none 
% ******************************************************************************* 
unmarkPersonalTrain(Train, TrainNum, CurrentPlayer, NewTrain):-
	
	getPersonalTrainNum(CurrentPlayer, PersonalNum),

	%if tile is being placed on personal train
	TrainNum =:= PersonalNum,

	%unmark player train --> false
	updateRegularMarker(Train, false, NewTrain).
unmarkPersonalTrain(Train, _, _, NewTrain):- 
	NewTrain = Train.

% ******************************************************************************* 
% Clause Name: getPersonalTrainNum
% Purpose: To get the train number associated with your train
% Parameters: 
%			CurrentPlayer, an integer indicating computer or human player

% Return Value: an integer, the train number
% Assistance Received: none 
% ******************************************************************************* 
getPersonalTrainNum(CurrentPlayer, TrainNum):-
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	trainMenu(compTrain, TrainNum).
getPersonalTrainNum(CurrentPlayer, TrainNum):-
	player(human, Human),
	CurrentPlayer =:= Human,
	trainMenu(humanTrain, TrainNum).

% ******************************************************************************* 
% Clause Name: getOpponentTrainNum
% Purpose: To get the train number associated with the opponent train
% Parameters: 
%			CurrentPlayer, an integer indicating computer or human player

% Return Value: an integer, the train number
% Assistance Received: none 
% ******************************************************************************* 
getOpponentTrainNum(CurrentPlayer, TrainNum):-
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	trainMenu(humanTrain, TrainNum).
getOpponentTrainNum(CurrentPlayer, TrainNum):-
	player(human, Human),
	CurrentPlayer =:= Human,
	trainMenu(compTrain, TrainNum).



% ***************************************************
% Source Code to access and update elements of a turn
% ***************************************************

% Turn = [DoublesPlaced, DrewFromBoneyard, isOver]

getNumDoublesPlaced([First|_], First).
pickedFromBoneyard([_, Marker|_], Marker).
isTurnOver([_, _, Marker|_], Marker).

% ******************************************************************************* 
% Clause Name: updateDoublesPlaced
% Purpose: To update the number of doubles played by a player
% Parameters: 
%			Turn, a list consisted of indicators

% Return Value: Turn list, with indicators updated
% Assistance Received: none 
% ******************************************************************************* 
updateDoublesPlaced(Turn, NewTurn):- 
	getNumDoublesPlaced(Turn, NumDoubles),
	NewDoubles is NumDoubles + 1,
	pickedFromBoneyard(Turn, DrewFromBoneyard),
	isTurnOver(Turn, TurnMarker),

	NewTurn = [NewDoubles, DrewFromBoneyard, TurnMarker].

% ******************************************************************************* 
% Clause Name: setBoneyardMarker
% Purpose: To update the marker that indicates if player has picked from boneyard
% Parameters: 
%			Turn, a list consisted of indicators
%			NewMarker, a boolean

% Return Value: Turn list, with indicators updated
% Assistance Received: none 
% ******************************************************************************* 
setBoneyardMarker(Turn, NewMarker, NewTurn):- 
	getNumDoublesPlaced(Turn, NumDoubles),
	isTurnOver(Turn, TurnMarker),
	NewTurn = [NumDoubles, NewMarker, TurnMarker].

setTurnOver(Turn, NewMarker, NewTurn):-
	getNumDoublesPlaced(Turn, NumDoubles),
	pickedFromBoneyard(Turn, BoneyardMarker),
	NewTurn = [NumDoubles, BoneyardMarker, NewMarker].



% ****************************************************
% Source Code to access and update elements of a round
% ****************************************************

% Round = [[CompHand, HumanHand], Boneyard, Engine, [CompTrain, HumanTrain, MexicanTrain], 
% [CurrentPl, CompSkips, HumanSkips, IncompleteIndicator, CompleteIndicator] ]


%the player hands
getPlayerHands(Round, Hands):- [Hands|_] = Round.

getCompHand(Round, Hand):- 	
	getPlayerHands(Round, Hands), 
	[Hand|_] = Hands.

getHumanHand(Round, Hand):-	
	getPlayerHands(Round, Hands), 
	[_|Rest] = Hands, 
	[Hand|_] = Rest.

%the boneyard and the engine
getBoneyard(Round, Boneyard):- [_, Boneyard|_] = Round.
getEngine(Round, Engine):- [_, _, Engine|_] = Round.

%the trains
getTrains(Round, Trains):- [_, _, _, Trains|_] = Round.
getCompTrain(Round, Train):- getTrains(Round, Trains), [Train|_] = Trains.
getHumanTrain(Round, Train):- getTrains(Round, Trains), [_, Train|_] = Trains.
getMexicanTrain(Round, Train):- getTrains(Round, Trains), [_, _, Train|_] = Trains.

%the indicators
getIndicators(Round, Indicators):- [_, _, _, _, Indicators|_] = Round.
getCurrentPlayer(Round, Player):- getIndicators(Round, Indicators), [Player|_] = Indicators.
getCompSkips(Round, Indicator):- getIndicators(Round, Indicators), [_, Indicator|_] = Indicators.
getHumanSkips(Round, Indicator):- getIndicators(Round, Indicators), [_, _, Indicator|_] = Indicators.
getIncompleteIndicator(Round, Indicator):- getIndicators(Round, Indicators), [_, _, _, Indicator|_] = Indicators.
getCompleteIndicator(Round, Indicator):- getIndicators(Round, Indicators), [_, _, _, _, Indicator|_] = Indicators.


% ******************************************************************************* 
% Clause Name: getNextPlayer
% Purpose: To identify the next player to take a turn
% Parameters: 
%			CurrentPlayer, an integer referring to computer or human player

% Return Value: an integer, referring to the next player
% Assistance Received: none 
% ******************************************************************************* 
getNextPlayer(CurrentPlayer, NextPlayer):-
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	player(human, NextPlayer).
getNextPlayer(CurrentPlayer, NextPlayer):- 
	player(human, Human),
	CurrentPlayer =:= Human,
	player(comp, NextPlayer).

% ******************************************************************************* 
% Clause Name: updateCompHand
% Purpose: To update the tiles in computer hand 
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewCompHand, a list consisted of the new computer hand

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateCompHand(Round, NewCompHand, NewRound):-

	getHumanHand(Round, HumanHand),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getIndicators(Round, Indicators),

	NewRound = [[NewCompHand, HumanHand], Boneyard, Engine, Trains, Indicators].

% ******************************************************************************* 
% Clause Name: updateHumanHand
% Purpose: To update the tiles in human hand 
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewHumanHand, a list consisted of the new human hand

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateHumanHand(Round, NewHumanHand, NewRound):-

	getCompHand(Round, CompHand),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getIndicators(Round, Indicators),

	NewRound = [[CompHand, NewHumanHand], Boneyard, Engine, Trains, Indicators].

% ******************************************************************************* 
% Clause Name: updateBoneyard
% Purpose: To update the tiles in the boneyard
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewBoneyard, a list consisted of the new boneyard

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateBoneyard(Round, NewBoneyard, NewRound):-
	getPlayerHands(Round, Hands),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getIndicators(Round, Indicators),

	NewRound = [Hands, NewBoneyard, Engine, Trains, Indicators].

% ******************************************************************************* 
% Clause Name: updateTrains
% Purpose: To update the trains of the round
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewTrains, a list consisted of a lists trains

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateTrains(Round, NewTrains, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getIndicators(Round, Indicators),

	NewRound = [Hands, Boneyard, Engine, NewTrains, Indicators].

% ******************************************************************************* 
% Clause Name: updateCompTrain
% Purpose: To update the tiles of the computer train
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewCompTrain, a list consisted of the new computer train

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateCompTrain(Round, NewCompTrain, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getHumanTrain(Round, HumanTrain),
	getMexicanTrain(Round, MexicanTrain),
	getIndicators(Round, Indicators),

	NewRound = [Hands, Boneyard, Engine, [NewCompTrain, HumanTrain, MexicanTrain], Indicators].

% ******************************************************************************* 
% Clause Name: updateHumanTrain
% Purpose: To update the tiles of the human train
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewHumanTrain, a list consisted of the new human train

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateHumanTrain(Round, NewHumanTrain, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getCompTrain(Round, CompTrain),
	getMexicanTrain(Round, MexicanTrain),
	getIndicators(Round, Indicators),

	NewRound = [Hands, Boneyard, Engine, [CompTrain, NewHumanTrain, MexicanTrain], Indicators].

% ******************************************************************************* 
% Clause Name: updateMexicanTrain
% Purpose: To update the tiles of the mexican train
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewMexicanTrain, a list consisted of the new mexican train

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateMexicanTrain(Round, NewMexicanTrain, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getCompTrain(Round, CompTrain),
	getHumanTrain(Round, HumanTrain),
	getIndicators(Round, Indicators),

	NewRound = [Hands, Boneyard, Engine, [CompTrain, HumanTrain, NewMexicanTrain], Indicators].

% ******************************************************************************* 
% Clause Name: updateCurrentPlayer
% Purpose: To update the current player
% Parameters: 
%			Round, a list consisted of all elements of a round

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateCurrentPlayer(Round, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getCurrentPlayer(Round, CurrentPlayer), 
	getCompSkips(Round, CompSkips),
	getHumanSkips(Round, HumanSkips),
	getIncompleteIndicator(Round, IncompleteIndicator),
	getCompleteIndicator(Round, CompleteIndicator),

	getNextPlayer(CurrentPlayer, NextPlayer),


	NewRound = [Hands, Boneyard, Engine, Trains, [NextPlayer, CompSkips, HumanSkips, 
	IncompleteIndicator, CompleteIndicator] ].

% ******************************************************************************* 
% Clause Name: updateCompSkips
% Purpose: To update the computer skips turn indicator
% Parameters: 
%			Round, a list consisted of all elements of a round

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateCompSkips(Round, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getCurrentPlayer(Round, CurrentPlayer), 
	getCompSkips(Round, CompSkips),
	getHumanSkips(Round, HumanSkips),
	getIncompleteIndicator(Round, IncompleteIndicator),
	getCompleteIndicator(Round, CompleteIndicator),

	negate(CompSkips, NewCompSkips),

	NewRound = [Hands, Boneyard, Engine, Trains, [CurrentPlayer, NewCompSkips, HumanSkips, 
	IncompleteIndicator, CompleteIndicator] ].

% ******************************************************************************* 
% Clause Name: updateHumanSkips
% Purpose: To update the human skips turn indicator
% Parameters: 
%			Round, a list consisted of all elements of a round

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateHumanSkips(Round, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getCurrentPlayer(Round, CurrentPlayer), 
	getCompSkips(Round, CompSkips),
	getHumanSkips(Round, HumanSkips),
	getIncompleteIndicator(Round, IncompleteIndicator),
	getCompleteIndicator(Round, CompleteIndicator),

	negate(HumanSkips, NewHumanSkips),

	NewRound = [Hands, Boneyard, Engine, Trains, [CurrentPlayer, CompSkips, NewHumanSkips, 
	IncompleteIndicator, CompleteIndicator]].

% ******************************************************************************* 
% Clause Name: updateIncompleteIndicator
% Purpose: To update the incomplete round indicator
% Parameters: 
%			Round, a list consisted of all elements of a round

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateIncompleteIndicator(Round, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getCurrentPlayer(Round, CurrentPlayer), 
	getCompSkips(Round, CompSkips),
	getHumanSkips(Round, HumanSkips),
	getCompleteIndicator(Round, CompleteIndicator),

	NewRound = [Hands, Boneyard, Engine, Trains, [CurrentPlayer, CompSkips, HumanSkips, 
	true, CompleteIndicator]].

% ******************************************************************************* 
% Clause Name: updateCompleteIndicator
% Purpose: To update the complete round indicator
% Parameters: 
%			Round, a list consisted of all elements of a round

% Return Value: a list, the updated Round list
% Assistance Received: none 
% ******************************************************************************* 
updateCompleteIndicator(Round, NewRound):-
	getPlayerHands(Round, Hands),
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine),
	getTrains(Round, Trains),
	getCurrentPlayer(Round, CurrentPlayer), 
	getCompSkips(Round, CompSkips),
	getHumanSkips(Round, HumanSkips),
	getIncompleteIndicator(Round, IncompleteIndicator),

	NewRound = [Hands, Boneyard, Engine, Trains, [CurrentPlayer, CompSkips, HumanSkips, 
	IncompleteIndicator, true]].

negate(Bool, NewBool):-
	Bool = false,
	NewBool = true.
negate(_, NewBool):- NewBool = false.



% ***************************************************************************
% Source Code to access and update the round elements based on current player
% ***************************************************************************

% ******************************************************************************* 
% Clause Name: getCurrentPlayerHand
% Purpose: To get the hand of the current player
% Parameters: 
%			Round, a list consisted of all elements of a round

% Return Value: a list, the current player hand
% Assistance Received: none 
% ******************************************************************************* 
getCurrentPlayerHand(Round, Hand):-
	%if current player is computer
	getCurrentPlayer(Round, CurrentPlayer),
	player(comp, Comp),
	CurrentPlayer =:= Comp,

	getCompHand(Round, Hand).
getCurrentPlayerHand(Round, Hand):- 
	%if current player is human
	getCurrentPlayer(Round, CurrentPlayer),
	player(human, Human),
	CurrentPlayer =:= Human,

	getHumanHand(Round, Hand).

% ******************************************************************************* 
% Clause Name: updateCurrentPlayerHand
% Purpose: To update the hand of the current player
% Parameters: 
%			Round, a list consisted of all elements of a round
%			NewHand, the new hand of the current player

% Return Value: a list, the updated Round list
% Assistance Received: none 
% *******************************************************************************
updateCurrentPlayerHand(Round, NewHand, NewRound):-
	%if current player is computer
	getCurrentPlayer(Round, CurrentPlayer),
	player(comp, Comp),
	CurrentPlayer =:= Comp,

	updateCompHand(Round, NewHand, NewRound).
updateCurrentPlayerHand(Round, NewHand, NewRound):-
	%if current player is human
	getCurrentPlayer(Round, CurrentPlayer),
	player(human, Human),
	CurrentPlayer =:= Human,
	
	updateHumanHand(Round, NewHand, NewRound).

% ******************************************************************************* 
% Clause Name: getTrainByNum
% Purpose: To get a train by number
% Parameters: 
%			Round, a list consisted of all elements of a round
%			Num, the number of the train

% Return Value: a list, the train
% Assistance Received: none 
% *******************************************************************************
getTrainByNum(Round, Num, Train):-
	trainMenu(compTrain, CompTrain),
	Num =:= CompTrain,
	getCompTrain(Round, Train).
getTrainByNum(Round, Num, Train):-
	trainMenu(humanTrain, HumanTrain),
	Num =:= HumanTrain,
	getHumanTrain(Round, Train).
getTrainByNum(Round, Num, Train):-
	trainMenu(mexicanTrain, MexicanTrain),
	Num =:= MexicanTrain,
	getMexicanTrain(Round, Train).

% ******************************************************************************* 
% Clause Name: updateTrainByNum
% Purpose: To update a train by number
% Parameters: 
%			Round, a list consisted of all elements of a round
%			Num, the number of the train
%			NewTrain, the new train

% Return Value: a list, the updated Round list
% Assistance Received: none 
% *******************************************************************************
updateTrainByNum(Round, Num, NewTrain, NewRound):-
	trainMenu(compTrain, CompTrain),
	Num =:= CompTrain,
	updateCompTrain(Round, NewTrain, NewRound).
updateTrainByNum(Round, Num, NewTrain, NewRound):-
	trainMenu(humanTrain, HumanTrain),
	Num =:= HumanTrain,
	updateHumanTrain(Round, NewTrain, NewRound).
updateTrainByNum(Round, Num, NewTrain, NewRound):-
	trainMenu(mexicanTrain, MexicanTrain),
	Num =:= MexicanTrain,
	updateMexicanTrain(Round, NewTrain, NewRound).

% ******************************************************************************* 
% Clause Name: setCurrentPlayerSkipIndicator
% Purpose: To update the current player indicator
% Parameters: 
%			Round, a list consisted of all elements of a round

% Return Value: a list, the updated Round list
% Assistance Received: none 
% *******************************************************************************
setCurrentPlayerSkipIndicator(Round, NewRound):-
	getCurrentPlayer(Round, CurrentPlayer),
	player(comp, Comp),
	Comp =:= CurrentPlayer,

	updateCompSkips(Round, NewRound).
setCurrentPlayerSkipIndicator(Round, NewRound):-
	getCurrentPlayer(Round, CurrentPlayer),
	player(human, Human),
	Human =:= CurrentPlayer,

	updateHumanSkips(Round, NewRound).

% ******************************************************************************* 
% Clause Name: getCurrentPlayerName
% Purpose: To get the current player name
% Parameters: 
%			CurrentPlayer, an integer referring to computer or human player

% Return Value: a string, the name of the current player
% Assistance Received: none 
% *******************************************************************************
getCurrentPlayerName(CurrentPlayer, Name):-
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	Name = "COMPUTER".
getCurrentPlayerName(CurrentPlayer, Name):-
	player(human, Human),
	CurrentPlayer =:= Human,
	Name = "HUMAN".



% ***************************************************
% Source Code to access and update elements of a game
% ***************************************************
% Game = [RoundNum, [CompScore, HumanScore]]

getRoundNum([First|_], First).
getPlayerScores([_, PlayerScores|_], PlayerScores).
getCompScore(Game, CompScore):- getPlayerScores(Game, [CompScore|_]).
getHumanScore(Game, HumanScore):- getPlayerScores(Game, [_, HumanScore|_]).

incrementRoundNum(Game, NewGame):- 
	getRoundNum(Game, RoundNum),
	getPlayerScores(Game, Scores),
	NewRoundNum is RoundNum + 1,
	NewGame = [NewRoundNum, Scores].

setRoundNum(Game, NewRoundNum, NewGame):- 
	getPlayerScores(Game, Scores),
	NewGame = [NewRoundNum, Scores].

updatePlayerScores(Game, NewScores, NewGame):-
	getRoundNum(Game, RoundNum),
	NewGame = [RoundNum, NewScores].

% ******************************************************************************* 
% Clause Name: updateCompScore
% Purpose: To update the socre of the computer
% Parameters: 
%			Game, a list consisted of the game elements
%			NewCompScore, the new score of the computer

% Return Value: a Game, the updated Game list
% Assistance Received: none 
% *******************************************************************************
updateCompScore(Game, NewCompScore, NewGame):-
	getRoundNum(Game, RoundNum),
	getCompScore(Game, CompScore),
	getHumanScore(Game, HumanScore),

	FinalCompScore is CompScore + NewCompScore,

	NewScores = [FinalCompScore, HumanScore],
	NewGame = [RoundNum, NewScores].

% ******************************************************************************* 
% Clause Name: updateHumanScore
% Purpose: To update the socre of the human
% Parameters: 
%			Game, a list consisted of the game elements
%			NewHumanScore, the new score of the human

% Return Value: a Game, the updated Game list
% Assistance Received: none 
% *******************************************************************************
updateHumanScore(Game, NewHumanScore, NewGame):-
	getRoundNum(Game, RoundNum),
	getCompScore(Game, CompScore),
	getHumanScore(Game, HumanScore),

	FinalHumanScore is HumanScore + NewHumanScore,

	NewScores = [CompScore, FinalHumanScore],
	NewGame = [RoundNum, NewScores].

% **********************************************************
% Source Code to access and update elements of the full game
% **********************************************************

% FullGame = [Game, Round]

getGame([First|_], First).
getRound([_, Round|_], Round).

updateGame(FullGame, NewGame, NewFullGame):-
	getRound(FullGame, Round),
	NewFullGame = [NewGame, Round].

updateRound(FullGame, NewRound, NewFullGame):-
	getGame(FullGame, Game),
	NewFullGame = [Game, NewRound].



%             *****************************************************************************************
%                                              Source Code for GUI (View)
%             *****************************************************************************************



% *******************************************
% Source Code to assist displaying formatting
% *******************************************

%symbols for displaying purposes
symbol(space, ' ').
symbol(dash, '-').
symbol(pipe, '|').
symbol(underScore, '_').

printNewLines(0).
printNewLines(Num):-
	nl,
	NewNum is Num - 1,
	printNewLines(NewNum).

printChar(_, 0).
printChar(Char, Num):-
	put(Char),
	NewNum is Num - 1,
	printChar(Char, NewNum).

% ******************************************************************************* 
% Clause Name: findDigits
% Purpose: To find the number of digits of an integer
% Parameters: 
%			Num, the integer

% Return Value: an integer, the number of digits in the integer
% Assistance Received: none 
% *******************************************************************************
findDigits(Num, 1):-
	Num < 10.
findDigits(Num, NumDigits):-
	NewNum is Num / 10,
	findDigits(NewNum, NewNumDigits), 
	NumDigits is NewNumDigits + 1.



% *******************************************
% Source Code to display messages to the user
% *******************************************

% ******************************************************************************* 
% Clause Name: displayWelcomeMsg
% Purpose: To welcome user to the game
% Parameters: None
% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayWelcomeMsg:-
	printNewLines(4),
	symbol(space, Space),
	printChar(Space, 53),
	format("WELCOME TO THE MEXICAN TRAIN GAME"),
	printNewLines(4).


% ******************************************************************************* 
% Clause Name: displayWelcomeMsg
% Purpose: To display a message to user upon termination
% Parameters: None
% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayEndMsg:-
	printNewLines(2),
	symbol(space, Space),
	printChar(Space, 45),
	format("THANK YOU FOR PLAYING THE MEXICAN TRAIN GAME"),
	printNewLines(4).



% *********************************************
% Source Code to display the game on the screen
% *********************************************

% ******************************************************************************* 
% Clause Name: displayGame
% Purpose: To display all elements of the game to the user
% Parameters: 
%			FullGame, a list consisted of elements of the round and the game

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayGame(FullGame):-
	
	%extract game and round 
	[Game|Rest] = FullGame,

	[Round|_] = Rest,

	%the game information
	getRoundNum(Game, RoundNum),
	getCompScore(Game, CompScore),
	getHumanScore(Game, HumanScore),

	%the round information
	
	getCompHand(Round, CompHand),
	getHumanHand(Round, HumanHand),
	
	getBoneyard(Round, Boneyard),
	getEngine(Round, Engine), 

	getCompTrain(Round, CompTrain),
	getHumanTrain(Round, HumanTrain),
	getMexicanTrain(Round, MexicanTrain),

	printNewLines(5),
	displayRoundNum(RoundNum),
	displayScores(CompScore, HumanScore),
	displayPlayerHands(CompHand, HumanHand),
	displayTopBoneyard(Boneyard),
	displayRegularTrain(CompTrain, HumanTrain, Engine),
	displayMexicanTrain(MexicanTrain).



% **********************************************
% Source Code to display round number and scores 
% **********************************************

% ******************************************************************************* 
% Clause Name: displayRoundNum
% Purpose: To display the round number
% Parameters: 
%			RoundNum, the current round number

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayRoundNum(RoundNum):-
	symbol(space, Space),
	symbol(dash, Dash),
	printNewLines(3),
	printChar(Space, 65),
	format("ROUND: ~p~n", RoundNum),
	printChar(Space, 65),
	printChar(Dash, 8),
	printNewLines(2).

% ******************************************************************************* 
% Clause Name: displayScores
% Purpose: To display the player scores
% Parameters: 
%			CompScore, the current computer score
%			HumanScore, the current human score

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayScores(CompScore, HumanScore):-
	
	%add the top of the box
	symbol(space, Space), put(Space),
	symbol(underScore, UnderScore),
	printChar(UnderScore, 65),
	printChar(Space, 6),
	printChar(UnderScore, 65), nl,

	%display the computer score 
	symbol(pipe, Pipe),
	put(Pipe), put(Space),
	printScore("COMPUTER", CompScore, 48),
	put(Space), put(Pipe),

	printChar(Space, 4), 

	%display the human score 
	put(Pipe), put(Space),
	printScore("HUMAN", HumanScore, 51),
	put(Space), put(Pipe), nl.

% ******************************************************************************* 
% Clause Name: printScore
% Purpose: To print a score relative to player name
% Parameters: 
%			Name, the player name
%			Score, the player score
%			MaxSpace, the maximum space between the name and the score

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printScore(Name, Score, MaxSpace):-
	format(Name),
	findDigits(Score, NumDigits),
	NumSpaces is MaxSpace - NumDigits,
	symbol(space, Space),
	printChar(Space, NumSpaces),
	format("SCORE: ~p", Score).



% ***********************************
% Source Code to display player hands
% ***********************************

% ******************************************************************************* 
% Clause Name: displayPlayerHands
% Purpose: To display the tiles in player hands
% Parameters: 
%			CompHand, the computer hand
%			HumanHand, the human hand

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayPlayerHands(CompHand, HumanHand):-
	
	%the initial number of tiles in each hand
	NumTiles = 16,

	%number of current tiles in each hand 
	length(CompHand, CompSize),
	length(HumanHand, HumanSize),

	displayHands(CompHand, HumanHand, NumTiles, CompSize, HumanSize).

% ******************************************************************************* 
% Clause Name: displayHands
% Purpose: To display the tiles in player hands based on their size
% Parameters: 
%			CompHand, the computer hand
%			HumanHand, the human hand
%			NumTiles, the maximum number of tiles in one row
%			HumanSize, the number of tiles in human hand

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayHands(CompHand, HumanHand, NumTiles, CompSize, HumanSize):-

	%if both players have 16 or less tiles in hand
	(NumTiles >= CompSize, NumTiles >= HumanSize),

	%display the first 3 rows for computer and human
	displayThreeRows(CompHand, HumanHand),

	%close the box for both player hands
	symbol(space, Space),
	symbol(dash, Dash),
	put(Space),
	printChar(Dash, 65),
	printChar(Space, 6),
	printChar(Dash, 65).
displayHands(CompHand, HumanHand, NumTiles, CompSize, HumanSize):-

	%if computer has more than 16 tiles and human has 16 or less
	(NumTiles < CompSize, NumTiles >= HumanSize),

	%break computer hand into 2 piles
	getNTiles(CompHand, NumTiles, FirstComp),
	removePile(CompHand, FirstComp, SecondComp),

	%display the first 3 rows for computer and human
	displayThreeRows(FirstComp, HumanHand),

	%display the first row of computer (true --> outer)
	displayHandRow(SecondComp, true),

	%close the human box
	symbol(space, Space),
	printChar(Space, 5),
	symbol(dash, Dash),
	printChar(Dash, 65), nl,

	%display the second row of computer (false --> inner)
	displayHandRow(SecondComp, false), nl,

	%display the third row of computer (true --> outer)
	displayHandRow(SecondComp, true), nl,

	%close the computer box
	put(Space), printChar(Dash, 65).
displayHands(CompHand, HumanHand, NumTiles, CompSize, HumanSize):-

	%if human has more than 16 tiles and computer has 16 or less
	(NumTiles < HumanSize, NumTiles >= CompSize),

	%break human hand into 2 piles
	getNTiles(HumanHand, NumTiles, FirstHuman),
	removePile(HumanHand, FirstHuman, SecondHuman),

	%display the first 3 rows for computer and human
	displayThreeRows(CompHand, FirstHuman),

	%close the computer box
	symbol(space, Space),
	put(Space),
	symbol(dash, Dash),
	printChar(Dash, 65),
	printChar(Space, 5),

	%display first row of human (true --> outer)
	displayHandRow(SecondHuman, true), nl,

	printChar(Space, 71),

	%display second row of human (false --> inner)
	displayHandRow(SecondHuman, false), nl,

	printChar(Space, 71),

	%display third row of human (true --> outer)
	displayHandRow(SecondHuman, true), nl, 

	printChar(Space, 72), printChar(Dash, 65).
displayHands(CompHand, HumanHand, NumTiles, _, _):-

	%if both players have more than 16 tiles

	%break computer hand into 2 piles
	getNTiles(CompHand, NumTiles, FirstComp),
	removePile(CompHand, FirstComp, SecondComp),

	%break human hand into 2 piles
	getNTiles(HumanHand, NumTiles, FirstHuman),
	removePile(HumanHand, FirstHuman, SecondHuman),

	%display the first 3 rows for computer and human (part 1)
	displayThreeRows(FirstComp, FirstHuman),

	%display the first 3 rows for computer and human (part 2)
	displayThreeRows(SecondComp, SecondHuman),

	%close the box for both player hands
	symbol(space, Space), symbol(dash, Dash),
	put(Space), printChar(Dash, 65),
	printChar(Space, 6), printChar(Dash, 65).

% ******************************************************************************* 
% Clause Name: displayThreeRows
% Purpose: To display each row of the player hands
% Parameters: 
%			CompHand, the computer hand
%			HumanHand, the human hand

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayThreeRows(CompHand, HumanHand):-

	%display the first row
	displayRowHands(CompHand, HumanHand, true),

	%display the second row 
	displayRowHands(CompHand, HumanHand, false),

	%display the third row 
	displayRowHands(CompHand, HumanHand, true).

% ******************************************************************************* 
% Clause Name: displayThreeRows
% Purpose: To display each row of the player hands
% Parameters: 
%			CompHand, the computer hand
%			HumanHand, the human hand
%			Location, the outer or middle part of the tile

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayRowHands(CompHand, HumanHand, Location):-
	
	%display the computer part of row
	displayHandRow(CompHand, Location),

	%add necessary spaces
	symbol(space, Space),
	printChar(Space, 4),

	%display the human part of row
	displayHandRow(HumanHand, Location), nl.

% ******************************************************************************* 
% Clause Name: displayHandRow
% Purpose: To display a row of player hands
% Parameters: 
%			Hand, the player hand
%			Location, the outer or middle part of the tile

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayHandRow(Hand, Location):-
	length(Hand, HandSize),

	%the maximum number of tiles in one row
	MaxTiles = 16,

	%the number of spots for empty tiles
	EmptySpots is MaxTiles - HandSize,

	%the space a tile takes
	TileSpace = 4,

	%print a row of player hand
	symbol(pipe, Pipe),
	put(Pipe),

	%Direction = true --> forward
	printRowTile(Hand, Location, true),
	symbol(space, Space),

	NumSpaces is EmptySpots * TileSpace,
	printChar(Space, NumSpaces),
	put(Pipe).



% *****************************
% Source Code to display a tile
% *****************************

% ******************************************************************************* 
% Clause Name: displayTileRow
% Purpose: To display a row of a tile
% Parameters: 
%			Tile, the tile
%			Location, the outer or middle part of the tile

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayTileRow(Tile, Location):-

	%if outer tile row is being printed

	Location, 
	displayTileOuter(Tile).
displayTileRow(Tile, _):- 
	%if inner tile row is being printed
	
	displayTileInner(Tile).

% ******************************************************************************* 
% Clause Name: displayTileOuter
% Purpose: To display the outer row of a tile
% Parameters: 
%			Tile, the tile

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayTileOuter(Tile):-
	%for doubles
	
	isDouble(Tile, Outcome),
	Outcome, 
	symbol(space, Space),
	put(Space), 
	getFront(Tile, Front),
	print(Front),
	put(Space).
displayTileOuter(_):- 
	%for non-doubles
	
	symbol(space, Space), 
	printChar(Space, 3).

% ******************************************************************************* 
% Clause Name: displayTileInner
% Purpose: To display the inner row of a tile
% Parameters: 
%			Tile, the tile

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayTileInner(Tile):-
	%for doubles

	isDouble(Tile, Outcome),
	Outcome, 
	symbol(space, Space), symbol(pipe, Pipe),
	put(Space), put(Pipe), put(Space).
displayTileInner(Tile):-
	%for non-doubles

	getFront(Tile, Front),
	getBack(Tile, Back),
	symbol(dash, Dash),
	print(Front), print(Dash), print(Back).



% *****************************
% Source Code to display a pile
% *****************************

% ******************************************************************************* 
% Clause Name: printRowTile
% Purpose: To display a row of a collection of tiles
% Parameters: 
%			Pile, a collection of tiles
%			Location, the outer or middle part of the tile
%			Direction, forward or backwards

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printRowTile([], _, _):- symbol(space, Space), put(Space).
printRowTile(Pile, Location, Direction):-
	
	%if outer row is being printed
	Location, 

	symbol(space, Space), put(Space),

	[First|Rest] = Pile,

	printRowTileOuter(First),
	
	printRowTile(Rest, Location, Direction).
printRowTile(Pile, Location, Direction):-

	symbol(space, Space), put(Space),

	[First|Rest] = Pile,
	
	%if inner row is being printed
	printRowTileInner(First, Direction),

	printRowTile(Rest, Location, Direction).

% ******************************************************************************* 
% Clause Name: printRowTileOuter
% Purpose: To display the outer row of a tile
% Parameters: 
%			Tile, the tile

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printRowTileOuter(Tile):- 
	%for double tiles 
	
	isDouble(Tile, Outcome), 
	Outcome, 
	symbol(space, Space),
	put(Space),

	%display the front end of the tile
	getFront(Tile, Front),
	print(Front), put(Space).
printRowTileOuter(_):-
	%for non double tiles
	symbol(space, Space),
	printChar(Space, 3).

% ******************************************************************************* 
% Clause Name: printRowTileInner
% Purpose: To display the inner row of a tile
% Parameters: 
%			Tile, the tile
%			Direction, forward or backwards

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printRowTileInner(Tile, _):-
	%for double tiles

	isDouble(Tile, Outcome),
	Outcome, 
	symbol(space, Space),
	put(Space), 
	symbol(pipe, Pipe),
	put(Pipe), put(Space).
printRowTileInner(Tile, Direction):-
	%for non double tiles
	printRowTileInnerDirection(Tile, Direction).

% ******************************************************************************* 
% Clause Name: printRowTileInnerDirection
% Purpose: To display the inner row of a tile forward or backwards
% Parameters: 
%			Tile, the tile
%			Direction, forward or backwards

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printRowTileInnerDirection(Tile, Direction):-
	%for forward direction

	%if direction is forward
	Direction, 

	%display the front of the tile
	getFront(Tile, Front),
	print(Front),
	symbol(dash, Dash),
	put(Dash),

	%display the back value of the tile
	getBack(Tile, Back),
	print(Back).
printRowTileInnerDirection(Tile, _):-
	%for reverse direction
	
	%display the end value of the tile
	getBack(Tile, Back),
	print(Back),
	symbol(dash, Dash),
	put(Dash),

	%display the front value of the tile
	getFront(Tile, Front),
	print(Front).



% ***********************************
% Source Code to display the boneyard
% ***********************************

% ******************************************************************************* 
% Clause Name: displayTopBoneyard
% Purpose: To display the tile on the top of the boneyard
% Parameters: 
%			Boneyard, the pile of boneyard

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayTopBoneyard(Boneyard):-
	
	printNewLines(2),

	%add the top box
	symbol(space, Space), symbol(underScore, UnderScore),
	printChar(Space, 65),
	printChar(UnderScore, 8), nl,

	%print the title
	printChar(Space, 64),
	format("|BONEYARD|"), nl,

	printChar(Space, 64),
	symbol(pipe, Pipe),
	put(Pipe), printChar(Space, 2),
	length(Boneyard, BoneyardSize),

	displayBoneyardTile(Boneyard, BoneyardSize).

% ******************************************************************************* 
% Clause Name: displayBoneyardTile
% Purpose: To display the tile on the top of the boneyard
% Parameters: 
%			Boneyard, the pile of boneyard

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayBoneyardTile(_, 0):-

	%if boneyard is empty
	
	symbol(space, Space),
	symbol(pipe, Pipe),
	symbol(dash, Dash),
	
	printChar(Space, 3),
	printChar(Space, 3),
	put(Pipe), nl, 

	%add the second row of tile
	printChar(Space, 64),
	put(Pipe), 
	printChar(Space, 2),

	printChar(Space, 3),
	printChar(Space, 3),
	put(Pipe), nl,

	%add the third row of tile
	printChar(Space, 64),
	put(Pipe), 
	printChar(Space, 2),

	printChar(Space, 3),
	printChar(Space, 3),
	put(Pipe), nl,

	%close the box
	printChar(Space, 65),
	printChar(Dash, 8),
	printNewLines(3).
displayBoneyardTile(Boneyard, _):-

	%if boneyard is not empty

	getTopTile(Boneyard, Tile),

	symbol(space, Space),
	symbol(pipe, Pipe),
	symbol(dash, Dash),

	%true --> outer 
	displayTileRow(Tile, true),

	printChar(Space, 3),
	put(Pipe), nl, 

	printChar(Space, 64),
	put(Pipe), 
	printChar(Space, 2),

	%false --> inner
	displayTileRow(Tile, false),

	printChar(Space, 3),
	put(Pipe), nl, 

	printChar(Space, 64),
	put(Pipe), 
	printChar(Space, 2),

	%true --> outer 
	displayTileRow(Tile, true),

	printChar(Space, 3),
	put(Pipe), nl, 

	printChar(Space, 65),
	printChar(Dash, 8),
	printNewLines(3).



% **********************************
% Source Code to display game trains
% **********************************

% ******************************************************************************* 
% Clause Name: displayRegularTrain
% Purpose: To display the personal trains
% Parameters: 
%			CompTrain, the computer train
%			HumanTrain, the human train
%			Engine, the round engine

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayRegularTrain(CompTrain, HumanTrain, Engine):-
	symbol(space, Space),
	put(Space),
	format("REGULAR TRAIN"),
	printNewLines(2),

	%display the first row of the train (true --> outer)
	displayRegularTrainRow(CompTrain, HumanTrain, Engine, true), nl,

	%display the second row of the train (false --> inner)
	displayRegularTrainRow(CompTrain, HumanTrain, Engine, false), nl,

	%display the third row of the train (true --> outer)
	displayRegularTrainRow(CompTrain, HumanTrain, Engine, true), nl.

% ******************************************************************************* 
% Clause Name: displayRegularTrainRow
% Purpose: To display a row of the personal trains
% Parameters: 
%			CompTrain, the computer train
%			HumanTrain, the human train
%			Engine, the round engine
%			Location, the outer or inner part of the train

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayRegularTrainRow(CompTrain, HumanTrain, Engine, Location):- 
	
	%regular train markers
	isTrainMarked(CompTrain, CompMarker),
	isTrainMarked(HumanTrain, HumanMarker),

	%exclude markers and engine which is in personal trains
	getTrainTiles(CompTrain, [_|NewCompTrain]),
	getTrainTiles(HumanTrain, [_|NewHumanTrain]), 

	%reverse the computer train
	reverse(NewCompTrain, ReversedCompTrain),

	%display computer marker (if applicable)
	displayMarker(CompMarker, Location),

	%display the first row of the computer train (true: outer) (false: reversed) 
	printRowTile(ReversedCompTrain, Location, false),

	%display the first row of the engine (true --> outer)
	displayTileRow(Engine, Location),

	%display the first row of the human train (true: outer) (true: normal)
	printRowTile(NewHumanTrain, Location, true),

	%display human marker (if applicable)
	displayMarker(HumanMarker, Location).

% ******************************************************************************* 
% Clause Name: displayMarker
% Purpose: To display personal train marker
% Parameters: 
%			Marker, a boolean 
%			Location, the outer or inner part of the train

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayMarker(Marked, Location):-
	
	%if train is marked
	Marked,
	printMarker(Location).
displayMarker(_, _).

printMarker(Location):-

	%if outer part of marker is being printed
	Location, 

	symbol(space, Space), printChar(Space, 3).
printMarker(_):- symbol(space, Space), put(Space), put('M'), put(Space).

% ******************************************************************************* 
% Clause Name: displayMexicanTrain
% Purpose: To display the mexican train
% Parameters: 
%			Train, the mexican train 

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayMexicanTrain(Train):-
	printNewLines(3),
	symbol(space, Space),
	put(Space),
	format("MEXICAN TRAIN"),
	printNewLines(2),

	%exclude markers in train
	getTrainTiles(Train, NewTrain),

	%print the first row of the mexican train (true: outer) (true: forward)
	printRowTile(NewTrain, true, true), nl,

	%print the second row of the mexican train (false: inner) (true: forward)
	printRowTile(NewTrain, false, true), nl,

	%print the third row of the mexican train (true: outer) (true: forward)
	printRowTile(NewTrain, true, true), nl,

	printNewLines(2).



% *****************************************
% Source Code to display round/game results
% *****************************************

% ******************************************************************************* 
% Clause Name: displayEventResult
% Purpose: To display round/game results
% Parameters: 
%			Event, the round or the game
%			Outcome, the outcome of the round or the game
%			CompScore, the computer score
%			HumanScore, the human score

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayEventResult(Event, Outcome, CompScore, HumanScore):-
	
	symbol(space, Space), 
	put(Space),
	symbol(dash, Dash),
	printChar(Dash, 24),
	symbol(pipe, Pipe), nl, 
	
	put(Pipe), put(Space),
	format(Event), put(Space),
	format("RESULT"),
	printChar(Space, 11), put(Pipe), nl,
	put(Pipe), put(Space), format("WINNER:"), put(Space),

	%display the winner
	printWinnerName(Outcome),

	%display the scores
	put(Pipe), put(Space),
	format("COMPUTER SCORE:"), put(Space),
	print(CompScore), 
	addProperSpaces(CompScore, 7), nl,

	put(Pipe), put(Space),
	format("Human SCORE:"), put(Space),
	print(HumanScore),
	addProperSpaces(HumanScore, 10), nl,

	put(Space),
	printChar(Dash, 24),
	printNewLines(3).

% ******************************************************************************* 
% Clause Name: printWinnerName
% Purpose: To display the name of the round/game winner 
% Parameters: 
%			EventOutcome, the outcome of the round/game

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printWinnerName(EventOutcome):-
	compOutcome(compLower, CompWon),
	EventOutcome =:= CompWon,

	eventWinner(compWins, CompName),
	symbol(space, Space), symbol(pipe, Pipe),
	format(CompName), 
	printChar(Space, 7),
	put(Pipe), nl.
printWinnerName(EventOutcome):-
	compOutcome(humanLower, HumanWon),
	EventOutcome =:= HumanWon,

	eventWinner(humanWins, HumanName),
	symbol(space, Space), symbol(pipe, Pipe),
	format(HumanName), 
	printChar(Space, 10),
	put(Pipe), nl.
printWinnerName(EventOutcome):-
	compOutcome(tie, Tie),
	EventOutcome =:= Tie,

	eventWinner(tied, Tied),
	symbol(space, Space), symbol(pipe, Pipe),
	format(Tied), 
	printChar(Space, 12),
	put(Pipe), nl.

% ******************************************************************************* 
% Clause Name: addProperSpaces
% Purpose: To add proper spaces between the winner and their score
% Parameters: 
%			Score, the score of the winner
%			MaxSpace, the maximum space between the name and the score

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
addProperSpaces(Score, MaxSpace):-
	
	findDigits(Score, NumDigits),
	NumSpaces is MaxSpace - NumDigits,

	symbol(space, Space), symbol(pipe, Pipe),
	printChar(Space, NumSpaces),
	put(Pipe).



%             *****************************************************************************************
%                                            Source Code for Menus and Inputs
%             *****************************************************************************************



% ************************************************
% Source Code to display a menu and get user input
% ************************************************

% ******************************************************************************* 
% Clause Name: menuSelection
% Purpose: To display a menu to the user and get an input as selection
% Parameters: 
%			Menu, the menu being displayed to the user
%			ValidOptions, the options that user can select

% Return Value: an integer, the selection of the user 
% Assistance Received: none 
% *******************************************************************************
menuSelection(Menu, ValidOptions, Selection):-

	%display the menu options
	displayMenu(Menu),

	%get user input
	getInput(ValidOptions, Selection, Outcome), nl,

	%user input must be numeric and valid
	Outcome. 
menuSelection(Menu, ValidOptions, Selection):- 
	nl, 
	menuSelection(Menu, ValidOptions, Selection).

displayMenu([]).
displayMenu([First|Rest]):- format(First), nl, displayMenu(Rest).

% ******************************************************************************* 
% Clause Name: getInput
% Purpose: To get input from the user and check it
% Parameters: 
%			ValidOptions, the options that user can select

% Return Value: 
%			Selection, the option selected by the user
%			true if input is valid and false otherwise
% Assistance Received: none 
% *******************************************************************************
getInput(ValidOptions, Selection, true):- 

	read(Selection), 

	%input must be an integer
	integer(Selection), 

	%input must be a valid option
	member(Selection, ValidOptions).
getInput(_, _, false).



% **************************
% Source Code for game menus
% **************************

% ******************************************************************************* 
% Clause Name: getMainMenu
% Purpose: To ask user whether to start a new game or load a game
% Parameters: None
% Return Value: an integer, the option selected by the user
% Assistance Received: none 
% *******************************************************************************
getMainMenu(Selection):-

	Menu = ["SELECT AN OPTION", "1) START NEW GAME", "2) LOAD GAME"],

	%the main menu options 
	mainMenu(newGame, NewGame),
	mainMenu(loadGame, LoadGame),

	ValidOptions = [NewGame, LoadGame], 

	menuSelection(Menu, ValidOptions, Selection).

% ******************************************************************************* 
% Clause Name: getCoinMenu
% Purpose: To ask user for a heads/tails call
% Parameters: None
% Return Value: an integer, the option selected by the user
% Assistance Received: none 
% *******************************************************************************
getCoinMenu(Selection):- 
	
	Menu = ["HEADS(0) OR TAILS (1)?"],
	
	coin(heads, Heads), coin(tails, Tails),
	ValidOptions = [Heads, Tails],

	menuSelection(Menu, ValidOptions, Selection).

% ******************************************************************************* 
% Clause Name: getActionMenu
% Purpose: To ask user to select the next action taken in the game
% Parameters: 
%			CurrentPlayer, the current player
% Return Value: an integer, the option selected by the user
% Assistance Received: none 
% *******************************************************************************
getActionMenu(CurrentPlayer, Selection):-

	%for computer player turn

	player(comp, Comp),
	CurrentPlayer =:= Comp,

	Menu = ["COMPUTER TURN",
			"SELECT AN OPTION",
			"1) SAVE GAME", 
			"2) LET COMPUTER MAKE A MOVE", 
			"3) ASK FOR HELP - N/A", 
			"4) QUIT GAME"],

	actionMenu(saveGame, Save),
	actionMenu(makeMove, Move),
	actionMenu(quitGame, Quit),

	ValidOptions = [Save, Move, Quit],

	%get user input
	menuSelection(Menu, ValidOptions, Selection).
getActionMenu(CurrentPlayer, Selection):-

	%for human player turn
	player(human, Human),
	CurrentPlayer =:= Human,

	Menu = ["YOUR TURN",
			"SELECT AN OPTION",
			"1) SAVE GAME", 
			"2) MAKE A MOVE", 
			"3) ASK FOR HELP", 
			"4) QUIT GAME"],

	actionMenu(saveGame, Save),
	actionMenu(makeMove, Move),
	actionMenu(getHelp, Help),
	actionMenu(quitGame, Quit),

	ValidOptions = [Save, Move, Help, Quit],

	%get user input
	menuSelection(Menu, ValidOptions, Selection).

% ******************************************************************************* 
% Clause Name: getAnotherRoundMenu
% Purpose: To ask user whether they would like to play another round
% Parameters: None
% Return Value: an integer, the option selected by the user
% Assistance Received: none 
% *******************************************************************************
getAnotherRoundMenu(Selection):-

	Menu = ["WOULD YOU LIKE TO PLAY ANOTHER ROUND?",
			"1) YES",
			"2) NO"],

	decision(yes, Yes),
	decision(no, No),

	ValidOptions = [Yes, No],

	%get user input
	menuSelection(Menu, ValidOptions, Selection).



%             *****************************************************************************************
%                                            Source Code for File Access
%             *****************************************************************************************



% ****************************************
% Source Code to load the game from a file
% ****************************************

% ******************************************************************************* 
% Clause Name: getFileName
% Purpose: To get the name of a file to load the game
% Parameters: None
% Return Value: a string, the filename
% Assistance Received: none 
% *******************************************************************************
getFileName(Filename):-
	format("ENTER FILENAME:"), nl,
	read(Filename), 
	exists_file(Filename).
getFileName(Filename):-
	nl, format("FILE NOT FOUND!"), nl,
	getFileName(Filename).

% ******************************************************************************* 
% Clause Name: loadGame
% Purpose: To load the game from a file
% Parameters: 
%			Filename, the name of the file to load from

% Return Value: a list, consisted of the entire game information
% Assistance Received: none 
% *******************************************************************************
loadGame(Filename, FullGame):-
	
	open(Filename, read, Stream),
    read(Stream, FileData), 
    close(Stream), 

    [RoundNum, CompScore, CompHand, CompTrain, HumanScore, 
    HumanHand, HumanTrain, MexicanTrain, Boneyard, CurrentPlayer|_] = FileData,

    %establish the game
    Game = [RoundNum, [CompScore, HumanScore]],

    %construct the train indicators
    modifyCompTrain(CompTrain, NewCompTrain),
    modifyHumanTrain(HumanTrain, NewHumanTrain),

    %no regular or orphan marker
    MexicanIndicator = [false, false],
    NewMexicanTrain = [MexicanIndicator|MexicanTrain],

    identifyCurrentPlayer(CurrentPlayer, NewCurrentPlayer),
    identifyEngine(RoundNum, EngineVal),

	%establish the round
    PlayerHands = [CompHand, HumanHand],
    Engine = [EngineVal, EngineVal],
    Trains = [NewCompTrain, NewHumanTrain, NewMexicanTrain],

    %the round indicators - series of booleans that indicate status of round
	%first false --> computer skips turn because boneyard is empty
	%second false --> human skips turn because boneyard is empty
	%third false --> round will be incomplete because user saves or quits
	%fourth false --> round is completed
    RoundIndicators = [NewCurrentPlayer, false, false, false, false],

    Round = [PlayerHands, Boneyard, Engine, Trains, RoundIndicators],

    %establish the full game
    FullGame = [Game, Round].

% ******************************************************************************* 
% Clause Name: modifyCompTrain
% Purpose: To modify the computer train read from the file into the game version
% Parameters: 
%			Train, computer train read from the file

% Return Value: a list, consisted of the new computer train
% Assistance Received: none 
% *******************************************************************************
modifyCompTrain(Train, NewTrain):-
	[Marker|Rest] = Train,
	Marker = m,

	%true --> regular marker
	%false --> orphan marker
	Indicator = [true, false],

	flipPile(Rest, FlippedTrain),
	NewTrain = [Indicator|FlippedTrain].
modifyCompTrain(Train, NewTrain):-
	Indicator = [false, false],
	%reverse(Train, ReversedTrain),
	flipPile(Train, FlippedTrain),
	NewTrain = [Indicator|FlippedTrain].

% ******************************************************************************* 
% Clause Name: modifyHumanTrain
% Purpose: To modify the human train read from the file into the game version
% Parameters: 
%			Train, human train read from the file

% Return Value: a list, consisted of the new human train
% Assistance Received: none 
% *******************************************************************************
modifyHumanTrain(Train, NewTrain):-

	getLastTile(Train, Marker),
	Marker = m,

	%true --> regular marker
	%false --> orphan marker
	Indicator = [true, false],
	deleteLastElem(Train, FinalTrain),
	NewTrain = [Indicator|FinalTrain].
modifyHumanTrain(Train, NewTrain):-
	Indicator = [false, false],
	NewTrain = [Indicator|Train].

% ******************************************************************************* 
% Clause Name: identifyCurrentPlayer
% Purpose: To identify current player read from file
% Parameters: 
%			Name, name of current player read from file 

% Return Value: an integer, indicating current player
% Assistance Received: none 
% *******************************************************************************
identifyCurrentPlayer(Name, CurrentPlayer):-
	Name = computer,
	player(comp, CurrentPlayer).
identifyCurrentPlayer(Name, CurrentPlayer):-
	Name = human,
	player(human, CurrentPlayer).



% **************************************
% Source Code to save the game to a file
% **************************************

% ******************************************************************************* 
% Clause Name: saveGame
% Purpose: To save the game to a file
% Parameters: 
%			FullGame, list consisted of the round and game elements

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
saveGame(FullGame):-
	%establish game elements
	getGame(FullGame, Game),
	getRoundNum(Game, RoundNum),
	getCompScore(Game, CompScore),
	getHumanScore(Game, HumanScore),

	%establish round elements
	getRound(FullGame, Round),
	getCompHand(Round, CompHand),
	getHumanHand(Round, HumanHand),
	getBoneyard(Round, Boneyard),

	getCompTrain(Round, CompTrain),
	getHumanTrain(Round, HumanTrain),
	getMexicanTrain(Round, MexicanTrain),
	
	%establish computer regular marker
	isTrainMarked(CompTrain, CompMarked),
	getTrainTiles(CompTrain, NewCompTrain),
	flipPile(NewCompTrain, FlippedCompTrain),
	addCompMarker(FlippedCompTrain, CompMarked, FinalCompTrain),

	%establish human regular marker
	isTrainMarked(HumanTrain, HumanMarked),
	getTrainTiles(HumanTrain, NewHumanTrain),
	addHumanMarker(NewHumanTrain, HumanMarked, FinalHumanTrain),

	getTrainTiles(MexicanTrain, FinalMexicanTrain),

	getCurrentPlayer(Round, CurrentPlayer),
	getCurrentPlayerWord(CurrentPlayer, CurrentPlayerName),

	Data = [RoundNum, CompScore, CompHand, FinalCompTrain, HumanScore, HumanHand, 
	FinalHumanTrain, FinalMexicanTrain, Boneyard, CurrentPlayerName],

	format("ENTER FILENAME"), nl, 
	read(Filename),

	open(Filename, write, OutStream),
    write(OutStream, Data),
    write(OutStream, "."),
    close(OutStream),

    format("GAME SUCCESSFULLY SAVED!"), nl.

% ******************************************************************************* 
% Clause Name: addCompMarker
% Purpose: To add the computer marker before saving to file
% Parameters: 
%			CompTrain, the computer train
%			Marker, a boolean

% Return Value: a list, the new computer train
% Assistance Received: none 
% *******************************************************************************
addCompMarker(CompTrain, true, NewCompTrain):-

	%add marker (if applicable)
	NewCompTrain = [m |CompTrain].
addCompMarker(CompTrain, false, NewCompTrain):-
	NewCompTrain = CompTrain.

% ******************************************************************************* 
% Clause Name: addHumanMarker
% Purpose: To add the human marker before saving to file
% Parameters: 
%			HumanTrain, the human train
%			Marker, a boolean

% Return Value: a list, the new human train
% Assistance Received: none 
% *******************************************************************************
addHumanMarker(HumanTrain, true, NewHumanTrain):-

	%add marker (if applicable)
	append(HumanTrain, [m], NewHumanTrain).
addHumanMarker(HumanTrain, false, NewHumanTrain):-
	NewHumanTrain = HumanTrain.

% ******************************************************************************* 
% Clause Name: getCurrentPlayerWord
% Purpose: To get the name of the current player for saving game 
% Parameters: 
%			CurrentPlayer, the current player

% Return Value: the name of the current player 
% Assistance Received: none 
% *******************************************************************************
getCurrentPlayerWord(CurrentPlayer, Name):-
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	Name = computer.
getCurrentPlayerWord(_, Name):- Name = human.



%             *****************************************************************************************
%                                       Source Code to play the Mexican Train Game
%             *****************************************************************************************



% **************************
% Source Code to play a game
% **************************

% ******************************************************************************* 
% Clause Name: startGame
% Purpose: To play the Mexican Train game
% Parameters: None
% Return Value: None
% Assistance Received: none 
% *******************************************************************************
startGame:- 
	
	displayWelcomeMsg,

	%prompt user to start new game or load game
	getMainMenu(Selection),

	%prepare the elements of the game
	prepGame(Selection, FullGame),

	%play the entire game
	playGame(FullGame, NewFullGame),

	getGame(NewFullGame, Game),
	getRound(NewFullGame, Round),

	%if user quit or saved during the round
	getIncompleteIndicator(Round, IncompleteIndicator),

	%display the results
	displayGameResults(Game, IncompleteIndicator).

% ******************************************************************************* 
% Clause Name: prepGame
% Purpose: To prepare the game initially
% Parameters: 
%			Selection, the option selected by the user
% Return Value: a list, consisted of the round and game elements
% Algorithm: 
%       	if user wants to start a new game
%       		set up the initial round number and scores
%       		set up player hands, boneyard, engine, trains, and first player
%       	end if 
%       	if user wants to load a game
%       		prompt user for a filename
%       		load the game from the file 
%       	end if 
% Assistance Received: none 
% *******************************************************************************
prepGame(Selection, FullGame):-

	%new game selected

	mainMenu(newGame, NewGame),

	%if user wants to start a new game
	Selection =:= NewGame,

	%set up the initial round number and scores
	setUpGame(Game),

	%set up player hands, boneyard, engine, trains, and first player
	setUpRound(Game, Round),

	%the full game 
	FullGame = [Game, Round].
prepGame(_, FullGame):-

	%load game selected
	
	%prompt user for a filename
	getFileName(Filename),

	%read a previously saved game from the file
	loadGame(Filename, FullGame).

% ******************************************************************************* 
% Clause Name: setUpGame
% Purpose: To prepare the game initially
% Parameters: None
% Return Value: a list, consisted of the game elements
% Assistance Received: none 
% *******************************************************************************
setUpGame(Game):-
	
	%the starting round
	RoundNum = 1,

	%player initial scores
	CompScore = 0,
	HumanScore = 0,
	PlayerScores = [CompScore, HumanScore],

	%the elements of the game
	Game = [RoundNum, PlayerScores].

% ******************************************************************************* 
% Clause Name: playGame
% Purpose: To play as many rounds as the user wants
% Parameters: 
%			FullGame, a list consisted of the round and game elements
% Return Value: a list, consisted of the round and game elements
% Assistance Received: none 
% *******************************************************************************
playGame(FullGame, FinalFullGame):-

	%play a round and update the scores
	playRound(FullGame, NewFullGame),

	%prompt user to play another round if user did not save or quit
	promptAnotherRound(NewFullGame, FinalFullGame).

% ******************************************************************************* 
% Clause Name: promptAnotherRound
% Purpose: To ask user if they want to player another round
% Parameters: 
%			FullGame, a list consisted of the round and game elements
% Return Value: a list, consisted of the round and game elements
% Assistance Received: none 
% *******************************************************************************
promptAnotherRound(FullGame, NewFullGame):-

	%if user saved or quit during this round
	getRound(FullGame, Round),
	getIncompleteIndicator(Round, IncompleteIndicator),
	IncompleteIndicator,

	NewFullGame = FullGame.
promptAnotherRound(FullGame, NewFullGame):-
	
	%if user completed the round
	getAnotherRoundMenu(Selection),

	%check if user selected yes
	playAnotherRound(FullGame, Selection, NewFullGame). 

% ******************************************************************************* 
% Clause Name: playAnotherRound
% Purpose: To player another round if user decides to do so
% Parameters: 
%			FullGame, a list consisted of the round and game elements
%			Selection, the option selected by the user
% Return Value: a list, consisted of the round and game elements
% Assistance Received: none 
% *******************************************************************************
playAnotherRound(FullGame, Selection, FinalFullGame):-

	%if user wants to play another round
	decision(yes, Yes),
	Selection =:= Yes,

	getGame(FullGame, Game),
	setUpRound(Game, NewRound),

	updateRound(FullGame, NewRound, NewFullGame),

	playGame(NewFullGame, FinalFullGame).
playAnotherRound(FullGame, _, FinalFullGame):-
	%if user does not want to play another round
	FinalFullGame = FullGame.

% ******************************************************************************* 
% Clause Name: displayGameResults
% Purpose: To display the game results
% Parameters: 
%			Game, a list consisted of the game elements
%			GameCompleted, a boolean
% Return Value: None
% Assistance Received: none 
% *******************************************************************************
displayGameResults(_, true):-
	
	%if user quit or saved during a round
	displayEndMsg.
displayGameResults(Game, false):-
	
	%if user did not quit or save during a round
	getCompScore(Game, CompScore),
	getHumanScore(Game, HumanScore),

	%determine the winner
	compareScores(CompScore, HumanScore, Outcome),

	%announce the winner
	event(game, EventGame),
	displayEventResult(EventGame, Outcome, CompScore, HumanScore),

	displayEndMsg.



% ***************************
% Source Code to play a round
% ***************************

% ******************************************************************************* 
% Clause Name: setUpRound
% Purpose: To set up a round
% Parameters: 
%			Game, a list consisted of the game elements

% Return Value: a list, Round list consisted of the round elements
% Algorithm: 
%	 (1) create the game deck 
%	 (2) identify the round engine
%	 (3) remove the engine from the deck
%	 (4) shuffle the deck
%	 (5) randomly distribute 16 tiles to each player from the deck 
%	 (6) place the remaining tiles in the boneyard
%	 (7) set up the default train markers (regular and orphan marker)
%	 (8) add the default markers to the game trains
%	 (9) identify the player starting the round 

% Assistance Received: none 
% *******************************************************************************

setUpRound(Game, Round):-

	%the maximum pip of a tile
	MaxPip = 9,
	
	createDeck(MaxPip, MaxPip, Deck),
	
	getRoundNum(Game, RoundNum),
	identifyEngine(RoundNum, EngineVal),
	Engine = [EngineVal, EngineVal],

	%remove the engine from the deck
	removeTile(Deck, Engine, NewDeck),

	shuffle(NewDeck, ShuffledDeck),

	%the number of tiles to distribute to each player
	NumTiles = 16,

	%distribute tiles to computer player
	distributeTiles(ShuffledDeck, NumTiles, CompHand),

	%remove the tiles in computer hand from deck
	removePile(ShuffledDeck, CompHand, DeckNoComp),

	%distribute tiles to human player
	distributeTiles(DeckNoComp, NumTiles, HumanHand),

	%remove the tiles in human hand from deck
	removePile(DeckNoComp, HumanHand, DeckNoHuman),

	%the player hands
	PlayerHands = [CompHand, HumanHand],

	%remaining tiles make up boneyard
	Boneyard = DeckNoHuman,

	%orphan double and marker indicators
	%initially no train is marked nor is orphan double
	%first false --> regular marker 
	%second false --> orphan double marker
	TrainIndicator = [false, false],

	%the trains in the game
	CompTrain = [TrainIndicator, Engine],
	HumanTrain = [TrainIndicator, Engine],
	MexicanTrain = [TrainIndicator, Engine],
	Trains = [CompTrain, HumanTrain, MexicanTrain],

	%the player scores
	getCompScore(Game, CompScore),
	getHumanScore(Game, HumanScore),

	%the player to start the round
	compareScores(CompScore, HumanScore, Outcome),
	identifyFirstPlayer(Outcome, CurrentPlayer),

	%the round indicators - series of booleans that indicate status of round
	%first false --> computer skips turn because boneyard is empty
	%second false --> human skips turn because boneyard is empty
	%third false --> round will be incomplete because user saves or quits
	%fourth false --> round is completed
	RoundIndicator = [CurrentPlayer, false, false, false, false],

	%the elements of the round 
	Round = [PlayerHands, Boneyard, Engine, Trains, RoundIndicator].

% ******************************************************************************* 
% Clause Name: playRound
% Purpose: To play a round
% Parameters: 
%			FullGame, a list consisted of the round and game elements

% Return Value: a list, the updated FullGame list
% Assistance Received: none 
% *******************************************************************************
playRound(FullGame, FinalFullGame):-
	
	%set up the turn --> DoublesPlaced = 0 
	%pickedFromBoneyard --> false
	%turn is over --> false
	Turn = [0, false, false],

	getRound(FullGame, Round),

	%establish orphan doubles
	getTrains(Round, Trains),
	establishOrphans(Trains, NewTrains),
	reverse(NewTrains, ReversedTrains),
	updateTrains(Round, ReversedTrains, NewRound),

	updateRound(FullGame, NewRound, NewFullGame),

	takeTurn(NewFullGame, Turn, FullGameAfterTurn),

	checkRoundProgress(FullGameAfterTurn, FinalFullGame).


% ***************************************************************
% Source Code to work with the deck, the engine, and player hands
% ***************************************************************

% ******************************************************************************* 
% Clause Name: createDeck
% Purpose: To create the game deck 
% Parameters: 
%			Front, the front value of a tile
%			Back, the back value of a tile

% Return Value: a list, the game deck
% Assistance Received: none 
% *******************************************************************************
createDeck(_, Back, []):- Back < 0.
createDeck(Front, Back, Deck):-
	Front =:= Back, Front > 0,
	NewFront is Front - 1,
	createDeck(NewFront, 9, NewDeck),
	Tile = [Front, Back],
	addToEnd(NewDeck, Tile, Deck).
createDeck(Front, Back, Deck):-
	NewBack is Back - 1, 
	createDeck(Front, NewBack, NewDeck),
	Tile = [Front, Back],
	addToEnd(NewDeck, Tile, Deck).

% ******************************************************************************* 
% Clause Name: identifyEngine
% Purpose: To find the engine for the current round
% Parameters: 
%			RoundNum, an integer indicating the current round number

% Return Value: an integer representing the engine value for the round	
% Assistance Received: none 
% *******************************************************************************
identifyEngine(RoundNum, EngineVal):-
	RoundNum > 10,
	NewRoundNum is RoundNum - 10,
	identifyEngine(NewRoundNum, EngineVal).
identifyEngine(RoundNum, EngineVal):-
	EngineVal is 10 - RoundNum.

% ******************************************************************************* 
% Clause Name: distributeTiles
% Purpose: To distribute tiles to players in the beginning of the round
% Parameters: 
%			Deck, a collection of tiles
%			NumTiles, an integer indicating the number of tiles

% Return Value: a list of tiles (player hand)
% Assistance Received: none 
% *******************************************************************************
distributeTiles(_, NumTiles, []):- NumTiles =:= 0. 
distributeTiles(Deck, NumTiles, Hand):-
	
	%randomly select a tile from the deck
	getRandomTile(Deck, Tile),

	%remove the tile from the deck
	removeTile(Deck, Tile, NewDeck),

	NewNumTiles is NumTiles - 1,
	distributeTiles(NewDeck, NewNumTiles, NewHand),

	%add the tile to the hand
	addToEnd(NewHand, Tile, Hand).



% **************************************************
% Source Code identify the player starting the round 
% **************************************************

% ******************************************************************************* 
% Clause Name: identifyFirstPlayer
% Purpose: To identify the player starting the round
% Parameters: 
%			CompOutcome, a comparison outcome of the player scores

% Return Value: an integer, indicating a player
% Assistance Received: none 
% *******************************************************************************
identifyFirstPlayer(CompOutcome, FirstPlayer):-
	compOutcome(compLower, CompLow),
	CompOutcome =:= CompLow,
	format("COMPUTER SCORE IS LOWER THAN YOUR SCORE. COMPUTER WILL START THE ROUND!"), nl,
	player(comp, FirstPlayer).
identifyFirstPlayer(CompOutcome, FirstPlayer):-
	compOutcome(humanLower, HumanLow),
	CompOutcome =:= HumanLow,
	format("YOUR SCORE IS LOWER THAN COMPUTER SCORE. YOU WILL START THE ROUND!"), nl,
	player(human, FirstPlayer).
identifyFirstPlayer(_, FirstPlayer):-
	format("THE GAME IS TIED. COIN IS TOSSED TO DETERMINE THE PLAYER THAT STARTS THE ROUND"), nl,
	
	%prompt user to select between heads or tails
	getCoinMenu(Selection),
	
	%check whether user gussed right
	performCoinToss(Selection, FirstPlayer).

% ******************************************************************************* 
% Clause Name: performCoinToss
% Purpose: To simulate a real life coin toss
% Parameters: 
%			Selection, the option selected by the user

% Return Value: an integer, indicating the coin toss winner
% Assistance Received: none 
% *******************************************************************************
performCoinToss(Selection, Winner):-

	%generate a random number (either 0 or 1)
	random(0, 2, RandomNum),

	%if selection matches the random numebr
	Selection =:= RandomNum,

	format("YOU WON THE COIN TOSS. YOU WILL START THE ROUND!"), nl,
	player(human, Winner).
performCoinToss(_, Winner):- 
	
	format("YOU LOST THE COIN TOSS. COMPUTER WILL START THE ROUND!"), nl,
	player(comp, Winner).

% ******************************************************************************* 
% Clause Name: compareScores
% Purpose: To compare player scores
% Parameters: 
%			CompScore, the computer score
%			HumanScore, the human score

% Return Value: an integer, a comparison outcome
% Assistance Received: none 
% *******************************************************************************
compareScores(CompScore, HumanScore, Outcome):- CompScore < HumanScore, compOutcome(compLower, Outcome).
compareScores(CompScore, HumanScore, Outcome):- CompScore > HumanScore, compOutcome(humanLower, Outcome).
compareScores(_, _, Outcome):- compOutcome(tie, Outcome).



% **************************
% Source Code to take a turn
% **************************

% ******************************************************************************* 
% Clause Name: takeTurn
% Purpose: To allow players to take a turn
% Parameters: 
%			FullGame, list consisted of the game and round elements
%			Turn, list consisted of turn elements

% Return Value: a list, consisted of the updated game and round elements
% Assistance Received: none 
% *******************************************************************************
takeTurn(FullGame, _, NewFullGame):-

	getRound(FullGame, Round),
	
	%if the round is completed
	isRoundCompleted(Round, Completed), Completed,

	%mark the round as completed
	updateCompleteIndicator(Round, NewRound),
	updateRound(FullGame, NewRound, NewFullGame),
	displayGame(NewFullGame).

takeTurn(FullGame, Turn, NewFullGame):-
	checkUserContinues(FullGame, Turn, NewFullGame).

% ******************************************************************************* 
% Clause Name: checkUserContinues
% Purpose: To check if user has quit or saved the game
% Parameters: 
%			FullGame, list consisted of the game and round elements
%			Turn, list consisted of turn elements

% Return Value: a list, consisted of the updated game and round elements
% Assistance Received: none 
% *******************************************************************************
checkUserContinues(FullGame, _, NewFullGame):-
	
	%if user has saved or quit the game
	getRound(FullGame, Round),
	getIncompleteIndicator(Round, IncompleteIndicator),
	IncompleteIndicator,

	NewFullGame = FullGame.
checkUserContinues(FullGame, Turn, NewFullGame):-

	%if user has not saved or quit the game

	displayGame(FullGame),

	getRound(FullGame, Round),
	getCurrentPlayer(Round, CurrentPlayer),

	%prompt user to select an action
	getActionMenu(CurrentPlayer, Selection),

	performAction(FullGame, Turn, Selection, NewFullGame).

% ******************************************************************************* 
% Clause Name: performAction
% Purpose: To allow a player to take an action
% Parameters: 
%			FullGame, list consisted of the game and round elements
%			Turn, list consisted of turn elements
%			Selection, the option selected by the user

% Return Value: a list, consisted of the updated game and round elements
% Algorithm:

%		if player wants to save the game
%			mark this round as incomplete
%			write the game to a text file
%		end if 
%
%		else if player wants to quit the game
%			mark this round as incomplete
%			display goodbye message
%		end else 
%
%		else if player wants to get help from computer (human only)
%			
%			if human has at least one possible move to make
%				inform player about which tile to play
%				inform player about which train to play the tile on
%			end if
%			
%			else 
%				inform player that they have no moves to make
%			end else
%
%			this player goes again
%		
%		end else if
%
%		else if player wants to make a move
%			allow player to take a turn
%		end else if
%	end if

% Assistance Received: none 
% *******************************************************************************
performAction(FullGame, _, Selection, FinalFullGame):- 
	actionMenu(saveGame, Save), 
	Selection =:= Save, 
	getRound(FullGame, Round),
	updateIncompleteIndicator(Round, NewRound),
	updateRound(FullGame, NewRound, FinalFullGame),

	saveGame(FinalFullGame).
performAction(FullGame, Turn, Selection, FinalFullGame):- 
	actionMenu(makeMove, Move),
	Selection =:= Move,
	getRound(FullGame, Round),
	getNumDoublesPlaced(Turn, NumDoubles),

	%if player can move
	canPlayerMove(Round, NumDoubles, CanMove),

	%player places one or more tiles
	playerMoves(FullGame, Turn, CanMove, FinalFullGame).
performAction(FullGame, Turn, Selection, FinalFullGame):- 

	actionMenu(getHelp, Help),
	Selection =:= Help,
	getRound(FullGame, Round),
	getNumDoublesPlaced(Turn, NumDoubles),
	getHelpFromComp(Round, NumDoubles),
	takeTurn(FullGame, Turn, FinalFullGame).
performAction(FullGame, _, Selection, FinalFullGame):-
	actionMenu(quitGame, Quit),
	Selection =:= Quit,
	getRound(FullGame, Round),
	updateIncompleteIndicator(Round, NewRound),
	updateRound(FullGame, NewRound, FinalFullGame).

% ******************************************************************************* 
% Clause Name: playerMoves
% Purpose: To allow player to place a tile on a train
% Parameters: 
%			FullGame, list consisted of the game and round elements
%			Turn, list consisted of turn elements
%			playerCanMove, a boolean
% Return Value: a list, consisted of the updated game and round elements
% Algorithm:
%			if player has no possible moves
%				attempt to draw from boneyard
%			else 
%				prompt player to select a tile 
%				prompt player to select a train
%
%				if the tile matches the train
%					add the tile to the train
%					remove the orphan double marker for this train (if applicable)
%					
%					if player placed tile on personal train
%						unmark player train (if applicable)
%					end if
%
%					if player placed a double
%						note that this player has placed a double
%						allow this player to pick from boneyard (if needed)
%						player goes again since a double is placed
%					end if 
%				end if 
%
%				else 
%					prompt player to select another pair of tile and train
%				end else 
%			end else

% Assistance Received: none 
% *******************************************************************************
playerMoves(FullGame, Turn, true, FinalFullGame):-
	
	%if player has a move 

	getRound(FullGame, Round),
	getNumDoublesPlaced(Turn, NumDoubles),

	promptTileTrainSelection(Round, NumDoubles, SelectedTile, SelectedTrain),

	%remove the tile from player hand
	getCurrentPlayerHand(Round, Hand),
	removeTile(Hand, SelectedTile, NewHand),

	%update the round with the new hand
	updateCurrentPlayerHand(Round, NewHand, RoundHand),

	%add the tile to the train
	getTrainByNum(RoundHand, SelectedTrain, Train),
	appendTileToTrain(Train, SelectedTile, TrainWithTile),

	%unmark personal train (if applicable)
	getCurrentPlayer(RoundHand, CurrentPlayer),
	unmarkPersonalTrain(TrainWithTile, SelectedTrain, CurrentPlayer, TrainWithMarker),

	%remove orphan double marker
	updateOrphanMarker(TrainWithMarker, false, FinalTrain),

	%update the round with the new train
	updateTrainByNum(RoundHand, SelectedTrain, FinalTrain, RoundTrain),

	%update the full game with the round
	updateRound(FullGame, RoundTrain, NewFullGame),

	%check if a double was placed to go again
	checkTilePlacement(Turn, SelectedTile, NewTurn),

	takeNextAction(NewFullGame, NewTurn, FinalFullGame).
playerMoves(FullGame, Turn, false, FinalFullGame):-
	
	%if player does not have a move 
	getRound(FullGame, Round),

	%attempt to draw from boneyard
	pickedFromBoneyard(Turn, Picked),
	drawFromBoneyard(Round, Turn, Picked, NewTurn, NewRound),

	%update the game
	updateRound(FullGame, NewRound, NewFullGame),

	takeNextAction(NewFullGame, NewTurn, FinalFullGame).

% ******************************************************************************* 
% Clause Name: getHelpFromComp
% Purpose: To get a tile and train suggestion from computer
% Parameters: 
%			Round, list consisted of the round elements
%			DoublesPlaced, number of doubles placed in this turn 

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
getHelpFromComp(Round, DoublesPlaced):-
	
	%if the human has any moves 
	canPlayerMove(Round, DoublesPlaced, CanMove), CanMove,
	
	%suggest a tile and train selection
	compSelectsTile(Round, DoublesPlaced, SelectedTile),
	compSelectsTrain(Round, SelectedTile, _).
getHelpFromComp(_, _):-
	
	%if the human has no moves 
	format("COMPUTER ADVICE: THERE ARE NO PLAYABLE TILES IN YOUR HAND"), nl.



% *************************************************
% Source Code to allow player to pick from boneyard
% *************************************************

% ******************************************************************************* 
% Clause Name: drawFromBoneyard
% Purpose: To draw a tile from the boneyard if possible
% Parameters: 
%			Round, list consisted of the round elements
%			Turn, list consisted of turn elements
%			pickedFromBoneyard, a boolean
%
% Return Value:
%			NewTurn, the updated Turn list
%			FinalRound, the updated Round list
% Algorithm:
%	if player has not yet picked from boneyard
%		attempt to pick from boneyard
%	else 
%		mark the player train
%	end else
% Assistance Received: none 
% *******************************************************************************
drawFromBoneyard(Round, Turn, false, NewTurn, FinalRound):-

	%if player has not picked from boneyard
	
	getBoneyard(Round, Boneyard),
	length(Boneyard, Size),

	attemptBoneyardPick(Round, Turn, Size, NewTurn, FinalRound). 
drawFromBoneyard(Round, Turn, true, NewTurn, FinalRound):-

	%if player has picked from boneyard

	getCurrentPlayer(Round, CurrentPlayer),

	%mark the player train
	getPersonalTrainNum(CurrentPlayer, TrainNum),

	getTrainByNum(Round, TrainNum, Train), 

	updateRegularMarker(Train, true, NewTrain),

	updateTrainByNum(Round, TrainNum, NewTrain, FinalRound),

	nl, format("TILE DRAWN FROM BONEYARD CANNOT BE PLAYED"), nl,

	getCurrentPlayerName(CurrentPlayer, Name),

	string_concat(Name, " TRAIN IS MARKED", Prompt), 

	format(Prompt), nl,

	%next player must go now
	setTurnOver(Turn, true, NewTurn).

% ******************************************************************************* 
% Clause Name: attemptBoneyardPick
% Purpose: To draw a tile from the boneyard if possible
% Parameters: 
%			Round, list consisted of the round elements
%			Turn, list consisted of turn elements
%			BoneyardSize, number of tiles in boneyard

% Return Value: a list, the updated Round list
% Algorithm:
%		if boneyard is not empty
%			pick a tile from boneyard
%			note that this player has picked from boneyard
%		end if
%
%		else 
%			note that player skipped turn because boneyard is empty
%		end else 
% Assistance Received: none 
% *******************************************************************************
attemptBoneyardPick(Round, Turn, 0, NewTurn, FinalRound):-
	
	%if boneyard is empty

	%note that player skipped turn because boneyard is empty
	setCurrentPlayerSkipIndicator(Round, FinalRound),

	getCurrentPlayer(Round, CurrentPlayer),
	getCurrentPlayerName(CurrentPlayer, Name),

	format("BONEYARD IS EMPTY. "), 
	format(Name), format(" SKIPS TURN!"), nl,

	%next player must go
	setTurnOver(Turn, true, NewTurn). 
attemptBoneyardPick(Round, Turn, BoneyardSize, NewTurn, FinalRound):-

	%if boneyard is not empty
	BoneyardSize > 0,

	getBoneyard(Round, Boneyard),
	getCurrentPlayerHand(Round, Hand),
	
	%note that the player is drawing from boneyard
	setBoneyardMarker(Turn, true, NewTurn),

	%get the tile on top of the boneyard
	getTopTile(Boneyard, TopTile),

	%remove the tile from boneyard
	removeTile(Boneyard, TopTile, NewBoneyard),

	%add the tile to player hand
	addToEnd(Hand, TopTile, NewHand),

	%update the round
	updateBoneyard(Round, NewBoneyard, NewRound),
	updateCurrentPlayerHand(NewRound, NewHand, FinalRound),

	getCurrentPlayer(FinalRound, CurrentPlayer),
	getCurrentPlayerName(CurrentPlayer, Name),
	string_concat(Name, " PICKED FROM BONEYARD", Prompt),
	format(Prompt), nl.

	%player goes again (to try playing tile drawn from boneyard)



% ****************************************
% Source Code to monitor status of a round
% ****************************************

% ******************************************************************************* 
% Clause Name: establishOrphans
% Purpose: To mark the trains that end with a double as orphan double
% Parameters: 
%			Trains, the game trains

% Return Value: a list, the updated Trains
% Assistance Received: none 
% *******************************************************************************
establishOrphans([], []).
establishOrphans(Trains, NewTrains):-

	[Train|Rest] = Trains,

	%if at least one tile is added to the train
	length(Train, Size), Size > 2,

	%if the train ends with a double
	getTail(Train, TailTile),
	isDouble(TailTile, DoubleTile), DoubleTile,
	
	establishOrphans(Rest, NewNewTrains),

	%mark the train
	updateOrphanMarker(Train, true, MarkedTrain),

	addToEnd(NewNewTrains, MarkedTrain, NewTrains).
establishOrphans(Trains, NewTrains):-
	[Train|Rest] = Trains,
	establishOrphans(Rest, NewNewTrains),
	addToEnd(NewNewTrains, Train, NewTrains).

% ******************************************************************************* 
% Clause Name: checkRoundProgress
% Purpose: To check the status of the round
% Parameters: 
%			FullGame, list consisted of the game and round elements

% Return Value: a list, the updated FullGame
% Algorithm:
%	if round is over
%		calculate pip sum for both hands
%		determine the winner
%		announce the winner
%		update the round number
%		update the player scores
%	end if
%	else if round is not over but user does not want to continue 
%		mark the round as incomplete
%	end else if
%	else 
%		switch to the next player
%		continue playing
%	end else
% Assistance Received: none 
% *******************************************************************************
checkRoundProgress(FullGame, FinalFullGame):-
	
	%if round is over
	getRound(FullGame, Round),
	getCompleteIndicator(Round, Completed),
	Completed,

	%calculate pip sum for both hands
	getCompHand(Round, CompHand),
	getHumanHand(Round, HumanHand),
	getPilePipSum(CompHand, CompHandSum),
	getPilePipSum(HumanHand, HumanHandSum),

	%determine the winner
	compareScores(CompHandSum, HumanHandSum, Outcome),

	%announce the winner
	event(round, EventRound),
	displayEventResult(EventRound, Outcome, CompHandSum, HumanHandSum),

	%update the round number
	getGame(FullGame, Game),
	incrementRoundNum(Game, NewGame),

	%update the player scores
	updateCompScore(NewGame, CompHandSum, NewCompGame),
	updateHumanScore(NewCompGame, HumanHandSum, FinalGame),

	%update the full game
	updateGame(FullGame, FinalGame, FinalFullGame).
checkRoundProgress(FullGame, FinalFullGame):-

	%if round is not over and user does not want to continue 

	getRound(FullGame, Round),
	getIncompleteIndicator(Round, IncompleteIndicator),
	IncompleteIndicator,

	FinalFullGame = FullGame.
checkRoundProgress(FullGame, FinalFullGame):-

	%if round is not over and user wants to continue

	getRound(FullGame, Round),

	%switch to the next player
	updateCurrentPlayer(Round, NewRound),

	updateRound(FullGame, NewRound, NewFullGame),	

	%continue playing
	playRound(NewFullGame, FinalFullGame).

% ******************************************************************************* 
% Clause Name: isRoundCompleted
% Purpose: To check whether the round is over
% Parameters: 
%			Round, list consisted of elements of the round

% Return Value: true if round is over and false otherwise
% Assistance Received: none 
% *******************************************************************************
isRoundCompleted(Round, Outcome):-
	
	getCompHand(Round, CompHand),
	getHumanHand(Round, HumanHand),
	length(CompHand, CompHandSize),
	length(HumanHand, HumanHandSize),
	getCompSkips(Round, CompSkips),
	getHumanSkips(Round, HumanSkips),

	roundEndCondMeets(CompHandSize, HumanHandSize, CompSkips, HumanSkips, Outcome).

% ******************************************************************************* 
% Clause Name: roundEndCondMeets
% Purpose: To check whether the round is over
% Parameters: 
%			Round, list consisted of elements of the round

% Return Value: true if round is over and false otherwise
% Assistance Received: none 
% *******************************************************************************
roundEndCondMeets(CompHandSize, HumanHandSize, _, _, true):- 
	
	%if there is no more tiles in a player hand
	(CompHandSize =:= 0 ; HumanHandSize =:= 0).
roundEndCondMeets(_,_, CompSkips, HumanSkips, true):- 
	
	%if both players skipped turns because boneyard is empty
	CompSkips, HumanSkips.
roundEndCondMeets(_, _, _, _, false).



% ***************************************
% Source Code to monitor status of a turn
% ***************************************

% ******************************************************************************* 
% Clause Name: canPlayerMove
% Purpose: To check if player has any moves
% Parameters: 
%			Round, list consisted of elements of the round
%			DoublesPlaced, the number of doubles placed this turn

% Return Value: true if player can move and false otherwise
% Assistance Received: none 
% *******************************************************************************
canPlayerMove(Round, DoublesPlaced, true):-
	retrieveEligibleTiles(Round, DoublesPlaced, EligibleTiles),

	%if there is an eligible tile, player has a move
	length(EligibleTiles, Size), Size > 0.
canPlayerMove(_, _, false).

% ******************************************************************************* 
% Clause Name: checkTilePlacement
% Purpose: To check if player has placed a double
% Parameters: 
%			Turn, list consisted of the turn elements
%			Tile, the placed tile

% Return Value: the updated Turn 
% Assistance Received: none 
% *******************************************************************************
checkTilePlacement(Turn, Tile, NewTurn):-
	isDouble(Tile, DoubleTile), DoubleTile,

	%note that a double is placed
	updateDoublesPlaced(Turn, TurnDoubles),

	%reset boneyard marker
	setBoneyardMarker(TurnDoubles, false, NewTurn).

	%turn is not over
checkTilePlacement(Turn, Tile, NewTurn):-
	isNonDouble(Tile, NonDoubleTile), NonDoubleTile,
	setTurnOver(Turn, true, NewTurn).

% ******************************************************************************* 
% Clause Name: takeNextAction
% Purpose: To take the next action in the game
% Parameters: 
%			FullGame, list consisted of the round and game elements
%			Turn, ist consisted of the turn elements

% Return Value: the updated FullGame
% Assistance Received: none 
% *******************************************************************************
takeNextAction(FullGame, Turn, NewFullGame):-

	isTurnOver(Turn, Over),
	Over,
	NewFullGame = FullGame.
takeNextAction(FullGame, Turn, NewFullGame):-
	takeTurn(FullGame, Turn, NewFullGame).



% **************************************
% Source Code to place a tile on a train
% **************************************

% ******************************************************************************* 
% Clause Name: promptTileTrainSelection
% Purpose: To allow players to select a tile and train
% Parameters: 
%			Round, list consisted of the round elements
%			DoublesPlaced, the number of doubles placed this turn

% Return Value:
%			SelectedTile, a tile
%			SelectedTrain, a train number
% Assistance Received: none 
% *******************************************************************************
promptTileTrainSelection(Round, DoublesPlaced, SelectedTile, SelectedTrain):-
	
	%player selects a tile
	selectTile(Round, DoublesPlaced, SelectedTile),

	%player selects a train
	selectTrain(Round, SelectedTile, SelectedTrain), 
	
	getTrainByNum(Round, SelectedTrain, Train),
	getTailVal(Train, TailVal),

	%if tile matches the train
	doesTileMatchVal(SelectedTile, TailVal, Matches), Matches.
promptTileTrainSelection(Round, DoublesPlaced, SelectedTile, SelectedTrain):-
	promptTileTrainSelection(Round, DoublesPlaced, SelectedTile, SelectedTrain).

% ******************************************************************************* 
% Clause Name: selectTile
% Purpose: To allow players to select a tile 
% Parameters: 
%			Round, list consisted of the round elements
%			DoublesPlaced, the number of doubles placed this turn

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
selectTile(Round, DoublesPlaced, SelectedTile):-
	getCurrentPlayer(Round, CurrentPlayer),
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	compSelectsTile(Round, DoublesPlaced, SelectedTile).
selectTile(Round, DoublesPlaced, SelectedTile):-
	getCurrentPlayer(Round, CurrentPlayer),
	player(human, Human),
	CurrentPlayer =:= Human,
	humanSelectsTile(Round, DoublesPlaced, SelectedTile).

% ******************************************************************************* 
% Clause Name: selectTrain
% Purpose: To allow players to select a train
% Parameters: 
%			Round, list consisted of the round elements
%			SelectedTile, the tile selected by the player

% Return Value: an integer, a train number
% Assistance Received: none 
% *******************************************************************************
selectTrain(Round, SelectedTile, SelectedTrain):-
	getCurrentPlayer(Round, CurrentPlayer),
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	compSelectsTrain(Round, SelectedTile, SelectedTrain).
selectTrain(Round, _, SelectedTrain):-
	getCurrentPlayer(Round, CurrentPlayer),
	player(human, Human),
	CurrentPlayer =:= Human,
	humanSelectsTrain(Round, SelectedTrain).

% ******************************************************************************* 
% Clause Name: appendTileToTrain
% Purpose: To add a tile to the end of a train
% Parameters: 
%			Train, a list of tiles
%			Tile, the tile to be placed

% Return Value: a list, the updated Train
% Assistance Received: none 
% *******************************************************************************
appendTileToTrain(Train, Tile, NewTrain):-
	
	%if tile is a non-double and its back matches the train
	getTailVal(Train, TailVal),
	isNonDouble(Tile, NonDoubleTile), NonDoubleTile,
	getBack(Tile, Back),
	Back =:= TailVal,
	flipTile(Tile, NewTile),
	addToEnd(Train, NewTile, NewTrain).
appendTileToTrain(Train, Tile, NewTrain):-
	addToEnd(Train, Tile, NewTrain).



% **********************************************
% Source Code to allow computer to select a tile
% **********************************************

%the strategies used by the computer to select a tile
tileStrategy(oneDouble, "ONLY PLAYABLE DOUBLE IN HAND").
tileStrategy(highestDouble, "PLAYABLE DOUBLE WITH THE HIGHEST PIP SUM").
tileStrategy(oneMatchingDouble, "ONLY PLAYABLE DOUBLE THAT HAS ANOTHER MATCHING TILE IN HAND").
tileStrategy(mostMatchingDouble, "PLAYABLE DOUBLE WITH THE MOST NUMBER OF TILES IN HAND THAT MATCH IT").
tileStrategy(mostMatchingDoubleMaxPip, "PLAYABLE DOUBLE WITH THE MOST NUMBER OF MATCHING TILES AND THE HIGHEST PIP SUM").
tileStrategy(oneTile, "ONLY PLAYABLE TILE").
tileStrategy(highestTile, "PLAYABLE TILE WITH THE HIGHEST PIP SUM").
tileStrategy(oneDoublePlayed, "ONLY PLAYABLE NON-DOUBLE WITH ITS DOUBLE(S) PLAYED").
tileStrategy(doublePlayedMaxPip, "PLAYABLE NON-DOUBLE WITH ITS DOUBLE(S) PLAYED AND THE HIGHEST PIP SUM").

% ******************************************************************************* 
% Clause Name: compSelectsTile
% Purpose: To allow computer to select a tile
% Parameters: 
%			Round, list consisted of the round elements
%			DoublesPlaced, the number of doubles placed this turn

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
compSelectsTile(Round, DoublesPlaced, SelectedTile):-

	printNewLines(3), 
	
	%identify all eligible tiles
	retrieveEligibleTiles(Round, DoublesPlaced, EligibleTiles),

	%get double tiles 
	getDoubles(EligibleTiles, Doubles),

	%pick a double or non-double tile
	pickFromTiles(Round, EligibleTiles, Doubles, SelectedTile).

% ******************************************************************************* 
% Clause Name: pickFromTiles
% Purpose: To pick from double and non-double tiles
% Parameters: 
%			Round, list consisted of the round elements
%			NonDoubles, the non-double eligible tiles
%			Doubles, the double eligible tiles

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
pickFromTiles(Round, _, Doubles, SelectedTile):-

	%if there is at least one double
	length(Doubles, Size),
	Size > 0,

	getCurrentPlayerHand(Round, Hand),
	getCurrentPlayer(Round, CurrentPlayer),
	pickFromDoubles(CurrentPlayer, Hand, Doubles, SelectedTile).
pickFromTiles(Round, NonDoubles, Doubles, SelectedTile):-
	
	%if there is no doubles (all non-doubles)
	length(Doubles, Size),
	Size =:= 0,
	pickFromNonDoubles(Round, NonDoubles, SelectedTile).

% ******************************************************************************* 
% Clause Name: pickFromDoubles
% Purpose: To pick from double tiles
% Parameters: 
%			CurrentPlayer, the current player
%			Hand, the tiles in player hand
%			Doubles, the double eligible tiles

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
pickFromDoubles(CurrentPlayer, Hand, Doubles, SelectedTile):-
	
	%if there is more than one double
	length(Doubles, Size),
	Size > 1,

	%identify all doubles that there is a matching tile for them in hand
	getMatchingDoubles(Hand, Doubles, MatchingDoubles),

	checkForMatchingDoubles(CurrentPlayer, Hand, Doubles, MatchingDoubles, SelectedTile).
pickFromDoubles(CurrentPlayer, _, Doubles, SelectedTile):-
	
	%if if there is only one double
	length(Doubles, Size),
	Size =:= 1,

	%select this one playable double in hand
	[SelectedTile|_] = Doubles,

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%only playable double in hand
	tileStrategy(oneDouble, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.

% ******************************************************************************* 
% Clause Name: checkForMatchingDoubles
% Purpose: To check for doubles that have matching tile(s)
% Parameters: 
%			CurrentPlayer, the current player
%			Hand, the tiles in player hand
%			Doubles, the double eligible tiles
%			MatchingDoubles, doubles that have a matching tile(s)

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
checkForMatchingDoubles(CurrentPlayer, Hand, _, MatchingDoubles, SelectedTile):-
	
	%if there is at least one double with a matching tile
	length(MatchingDoubles, Size),
	Size > 0,

	pickFromMatchingDoubles(CurrentPlayer, Hand, MatchingDoubles, SelectedTile).
checkForMatchingDoubles(CurrentPlayer, _, Doubles, MatchingDoubles, SelectedTile):-
	
	%if there is no double with a matching tile
	length(MatchingDoubles, Size),
	Size =:= 0,

	%select the double with the highest pip sum
	getMaxTile(Doubles, SelectedTile),

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%playable double with the highest pip sum in hand
	tileStrategy(highestDouble, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.

% ******************************************************************************* 
% Clause Name: pickFromMatchingDoubles
% Purpose: To pick from doubles that have matching tile(s)
% Parameters: 
%			CurrentPlayer, the current player
%			Hand, the tiles in player hand
%			MatchingDoubles, doubles that have a matching tile(s)

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
pickFromMatchingDoubles(CurrentPlayer, Hand, MatchingDoubles, SelectedTile):-

	%if there is more than one double with matching tile(s)
	length(MatchingDoubles, Size),
	Size > 1,

	%identify the max number of matching tiles for the doubles
	identifyMaxMatchingDoubleNum(Hand, MatchingDoubles, MaxMatch),

	%identify all doubles with matching tiles = max 
	getMostMatchingDoubles(Hand, MatchingDoubles, MaxMatch, MaxMatchingDoubles),

	pickFromMaxMatchingDoubles(CurrentPlayer, MaxMatchingDoubles, SelectedTile).
pickFromMatchingDoubles(CurrentPlayer, _, MatchingDoubles, SelectedTile):-

	%if there is only one double with matching tile(s)
	length(MatchingDoubles, Size),
	Size =:= 1,

	%select this one double with matching tile(s)
	[SelectedTile|_] = MatchingDoubles,

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%only playable double that has one or more matching tiles in hand
	tileStrategy(oneMatchingDouble, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.

% ******************************************************************************* 
% Clause Name: pickFromMaxMatchingDoubles
% Purpose: To pick from doubles that have matching tile(s) = max
% Parameters: 
%			CurrentPlayer, the current player
%			MaxMatchingDoubles, doubles that have a matching tile(s) = max

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
pickFromMaxMatchingDoubles(CurrentPlayer, MaxMatchingDoubles, SelectedTile):-
	
	%if there is more than one double with matching tiles = max
	length(MaxMatchingDoubles, Size),
	Size > 1,

	%select the double with the highest pip sum
	getMaxTile(MaxMatchingDoubles, SelectedTile),

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%playable double with the most number of matching tiles in hand and highest pip sum 
	tileStrategy(mostMatchingDoubleMaxPip, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.
pickFromMaxMatchingDoubles(CurrentPlayer, MaxMatchingDoubles, SelectedTile):-
	
	%if there is only one double with matching tiles = max
	length(MaxMatchingDoubles, Size),
	Size =:= 1,

	%select this one double with matching tiles = max 
	[SelectedTile|_] = MaxMatchingDoubles,

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%playable double with the most number of tiles in hand that could match it
	tileStrategy(mostMatchingDouble, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.

% ******************************************************************************* 
% Clause Name: pickFromNonDoubles
% Purpose: To pick from non-double tiles
% Parameters: 
%			Round, list consisted of the round elements
%			NonDoubles, the eligible non-double tiles

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
pickFromNonDoubles(Round, NonDoubles, SelectedTile):-

	%if there is more than one non-double
	length(NonDoubles, Size),
	Size > 1,

	%establish the doubles that have been played in the game (including the engine)
	identifyPlayedDoubles(Round, PlayedDoubles),

	%establish the non-doubles that at least one of their doubles is played
	getNonDoublesPlayed(NonDoubles, PlayedDoubles, PlayedNonDoubles),

	getCurrentPlayer(Round, CurrentPlayer),

	checkForPlayedNonDoubles(CurrentPlayer, NonDoubles, PlayedNonDoubles, SelectedTile).
pickFromNonDoubles(Round, NonDoubles, SelectedTile):-

	%if there is only one non-double
	length(NonDoubles, Size),
	Size =:= 1,

	%select this one playable tile
	[SelectedTile|_] = NonDoubles,

	getCurrentPlayer(Round, CurrentPlayer),
	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%only playable tile
	tileStrategy(oneTile, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.

% ******************************************************************************* 
% Clause Name: checkForPlayedNonDoubles
% Purpose: To check if there are any non-doubles that their double is played
% Parameters: 
%			CurrentPlayer, the current player
%			NonDoubles, the eligible non-double tiles
%			PlayedNonDoubles, the non-doubles that their double is played

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
checkForPlayedNonDoubles(CurrentPlayer, _, PlayedNonDoubles, SelectedTile):-

	%if there is at least one non-double for which its double(s) is played 
	length(PlayedNonDoubles, Size),
	Size > 0,

	pickFromPlayedNonDoubles(CurrentPlayer, PlayedNonDoubles, SelectedTile).
checkForPlayedNonDoubles(CurrentPlayer, NonDoubles, PlayedNonDoubles, SelectedTile):-

	%if there is no non-double for which one of its doubles is played 
	length(PlayedNonDoubles, Size),
	Size =:= 0,

	%select the non-double with the highest pip sum
	getMaxTile(NonDoubles, SelectedTile),

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%playable tile with the highest pip sum
	tileStrategy(highestTile, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.

% ******************************************************************************* 
% Clause Name: pickFromPlayedNonDoubles
% Purpose: To pick from non-doubles that their double is played
% Parameters: 
%			CurrentPlayer, the current player
%			PlayedNonDoubles, the non-doubles that their double is played

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
pickFromPlayedNonDoubles(CurrentPlayer, PlayedNonDoubles, SelectedTile):-
	
	%if there is more than one non-double for which one of its doubles is played
	length(PlayedNonDoubles, Size),
	Size > 1,

	%select the non-double with the highest pip sum
	getMaxTile(PlayedNonDoubles, SelectedTile),

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%playable non-double with its double(s) played and highest pip sum
	tileStrategy(doublePlayedMaxPip, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.
pickFromPlayedNonDoubles(CurrentPlayer, PlayedNonDoubles, SelectedTile):-
	
	%if there is only one non-double for which one of its doubles is played
	length(PlayedNonDoubles, Size),
	Size =:= 1,

	%select this one non-double that its double(s) is played
	[SelectedTile|_] = PlayedNonDoubles,

	printTileStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%only playable non-double with its double(s) played
	tileStrategy(oneDoublePlayed, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	print(SelectedTile), nl.

% ******************************************************************************* 
% Clause Name: identifyPlayedDoubles
% Purpose: To identify doubles that have been played on the trains
% Parameters: 
%			Round, list consisted of the round elements

% Return Value: a list, consisted of all the played doubles
% Assistance Received: none 
% *******************************************************************************
identifyPlayedDoubles(Round, NewDoubles):-

	%establish the game trains (remove train indicators)
	getCompTrain(Round, CompTrain),
	getTrainTiles(CompTrain, NewCompTrain),
	getDoubles(NewCompTrain, CompDoubles),

	getHumanTrain(Round, HumanTrain), 
	getTrainTiles(HumanTrain, NewHumanTrain),
	getDoubles(NewHumanTrain, HumanDoubles),

	getMexicanTrain(Round, MexicanTrain),
	getTrainTiles(MexicanTrain, NewMexicanTrain),
	getDoubles(NewMexicanTrain, MexicanDoubles),
	
	%combine the doubles
	append([CompDoubles, HumanDoubles, MexicanDoubles], Doubles),

	%remove duplicates (engines)
	sort(Doubles, NewDoubles).

% ******************************************************************************* 
% Clause Name: doesTileMatchAnyPlayedDoubles
% Purpose: To check if the double(s) of this non-double tile is played
% Parameters: 
%			PlayedDoubles, doubles that have been played on trains
%			NonDoubleTile, the tile to check

% Return Value: true of tile matches any double and false otherwise
% Assistance Received: none 
% *******************************************************************************
doesTileMatchAnyPlayedDoubles([], _, false).
doesTileMatchAnyPlayedDoubles(PlayedDoubles, NonDoubleTile, true):-
	
	[Double|_] = PlayedDoubles,
	getFront(Double, DoubleFront),

	%if the non-double matches this double
	doesTileMatchVal(NonDoubleTile, DoubleFront, Matches), Matches.
doesTileMatchAnyPlayedDoubles(PlayedDoubles, NonDoubleTile, Outcome):-

	[_|Rest] = PlayedDoubles,
	doesTileMatchAnyPlayedDoubles(Rest, NonDoubleTile, Outcome).

% ******************************************************************************* 
% Clause Name: getNonDoublesPlayed
% Purpose: To identify non-doubles that their double is played
% Parameters: 
%			NonDoubles, the eligible non-doubles
%			PlayedDoubles, doubles that have been played on trains

% Return Value: a list, consisted of all non-doubles that their double is played
% Assistance Received: none 
% *******************************************************************************
getNonDoublesPlayed([], _, []).
getNonDoublesPlayed(NonDoubles, PlayedDoubles, NonDoublesPlayed):-
	
	[NonDouble|Rest] = NonDoubles,

	%if the double(s) of this non-double is played
	doesTileMatchAnyPlayedDoubles(PlayedDoubles, NonDouble, Matches), Matches,
	getNonDoublesPlayed(Rest, PlayedDoubles, NewNonDoublesPlayed),
	addToEnd(NewNonDoublesPlayed, NonDouble, NonDoublesPlayed).
getNonDoublesPlayed(NonDoubles, PlayedDoubles, NonDoublesPlayed):-
	[_|Rest] = NonDoubles,
	getNonDoublesPlayed(Rest, PlayedDoubles, NonDoublesPlayed).

% ******************************************************************************* 
% Clause Name: getMatchingDoubles
% Purpose: To identify doubles that have a macthing tile in hand
% Parameters: 
%			Hand, the tiles in the player hand
%			Doubles, the eligible doubles

% Return Value: a list, consisted of doubles that have a macthing tile(s)
% Assistance Received: none 
% *******************************************************************************
getMatchingDoubles(_, [], []).
getMatchingDoubles(Hand, Doubles, MatchingDoubles):-

	%if this double has at least one matching tile
	[Double|Rest] = Doubles,
	getNumMatchingTiles(Hand, Double, NumMatches),
	NumMatches > 0,

	%it is a matching double
	getMatchingDoubles(Hand, Rest, NewMatchingDoubles),

	addToEnd(NewMatchingDoubles, Double, MatchingDoubles).
getMatchingDoubles(Hand, Doubles, MatchingDoubles):-
	[_|Rest] = Doubles,
	getMatchingDoubles(Hand, Rest, MatchingDoubles).
	
% ******************************************************************************* 
% Clause Name: getNumMatchingTiles
% Purpose: To find the number of tiles that match a given double
% Parameters: 
%			Hand, the tiles in the player hand
%			DoubleTile, the double

% Return Value: an integer, the number of tiles that match the double
% Assistance Received: none 
% *******************************************************************************
getNumMatchingTiles([], _, 0).
getNumMatchingTiles(Hand, DoubleTile, NumMatches):-

	[Tile|Rest] = Hand,
	getFront(DoubleTile, TileVal),

	%if this tile matches the double
	doesTileMatchVal(Tile, TileVal, Matches), Matches,
	isNotSameTile(Tile, DoubleTile, NotSame), NotSame,

	getNumMatchingTiles(Rest, DoubleTile, NewNumMatches),
	NumMatches is NewNumMatches + 1.
getNumMatchingTiles(Hand, DoubleTile, NumMatches):-
	[_|Rest] = Hand,
	getNumMatchingTiles(Rest, DoubleTile, NumMatches).

% ******************************************************************************* 
% Clause Name: identifyMaxMatchingDoubleNum
% Purpose: To find the maximum number of tiles that match a given double
% Parameters: 
%			Hand, the tiles in the player hand
%			Doubles, the eligible doubles

% Return Value: an integer, the maximum number of tiles that match the double
% Assistance Received: none 
% *******************************************************************************
identifyMaxMatchingDoubleNum(Hand, [FirstTile], FirstMaxMatch):- 
	getNumMatchingTiles(Hand, FirstTile, FirstMaxMatch).
identifyMaxMatchingDoubleNum(Hand, Doubles, MaxMatch):-
	
	%if this double has more matching tiles than previous ones 
	
	[FirstTile, SecondTile|Rest] = Doubles,
	identifyMaxMatchingDoubleNum(Hand, [SecondTile|Rest], MaxRest),
	getNumMatchingTiles(Hand, FirstTile, MatchingDoubles),
	max(MatchingDoubles, MaxRest, MaxMatch).

max(X, Y, X):- X >= Y.
max(X, Y, Y):- X < Y.

% ******************************************************************************* 
% Clause Name: getMostMatchingDoubles
% Purpose: To identify the doubles with the maximum number of tiles that match it
% Parameters: 
%			Hand, the tiles in the player hand
%			Doubles, the eligible doubles
%			MaxMatch, the maximum number of tiles that match a double in hand

% Return Value: an list, the doubles with maximum number of tiles that match it
% Assistance Received: none 
% *******************************************************************************
getMostMatchingDoubles(_, [], _, []).
getMostMatchingDoubles(Hand, Doubles, MaxMatch, MostMatchingDoubles):-

	%if this double has matching tiles = max
	[Double|Rest] = Doubles, 

	getNumMatchingTiles(Hand, Double, MatchingTiles), 
	MatchingTiles =:= MaxMatch,

	getMostMatchingDoubles(Hand, Rest, MaxMatch, NewMostMatchingDoubles),

	addToEnd(NewMostMatchingDoubles, Double, MostMatchingDoubles).
getMostMatchingDoubles(Hand, Doubles, MaxMatch, MostMatchingDoubles):-
	[_|Rest] = Doubles, 
	getMostMatchingDoubles(Hand, Rest, MaxMatch, MostMatchingDoubles).

% ******************************************************************************* 
% Clause Name: printTileStrategy
% Purpose: To inform user about the logistics behind computer tile selection
% Parameters: 
%			CurrentPlayer, the current player

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printTileStrategy(CurrentPlayer):-
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	format("THE COMPUTER PLAYED THIS TILE BECAUSE IT IS THE ").
printTileStrategy(CurrentPlayer):-
	player(human, Human),
	CurrentPlayer =:= Human,
	format("THE COMPUTER SUGGESTS PLAYING THIS TILE BECAUSE IT IS THE ").



% *******************************************
% Source Code to allow human to select a tile
% *******************************************

% ******************************************************************************* 
% Clause Name: humanSelectsTile
% Purpose: To allow human player to select a tile
% Parameters: 
%			Round, list consisted of the round elements
%			DoublesPlaced, the number of doubles placed in this turn

% Return Value: a tile
% Assistance Received: none 
% *******************************************************************************
humanSelectsTile(Round, DoublesPlaced, SelectedTile):-
	
	format("SELECT THE TILE YOU WOULD LIKE TO PLACE"), nl,
	read(SelectedTile),

	%must be a list 
	is_list(SelectedTile),

	%must have 2 elements
	length(SelectedTile, Size), Size =:= 2,

	%both elements must be integers
	getFront(SelectedTile, Front), integer(Front),
	getBack(SelectedTile, Back), integer(Back),

	%tile must be in the hand
	getCurrentPlayerHand(Round, Hand),
	isInPile(Hand, SelectedTile, Exists), Exists,

	%tile must be eligible
	retrieveEligibleTiles(Round, DoublesPlaced, EligibleTiles),
	isInPile(EligibleTiles, SelectedTile, IsEligible), IsEligible.
humanSelectsTile(Round, DoublesPlaced, SelectedTile):- 
	format("INVALID TILE SELECTION. PLEASE TRY AGAIN!"), nl, nl,
	humanSelectsTile(Round, DoublesPlaced, SelectedTile). 

% ******************************************************************************* 
% Clause Name: retrieveEligibleTiles
% Purpose: To identify all playable tiles in hand
% Parameters: 
%			Round, list consisted of the round elements
%			DoublesPlaced, the number of doubles placed in this turn

% Return Value: a list, consisted of all playable tiles
% Assistance Received: none 
% *******************************************************************************
retrieveEligibleTiles(Round, DoublesPlaced, EligibleTiles):-
	getCurrentPlayerHand(Round, Hand),
	retrieveEligibleTrainTails(Round, EligibleTails),
	identifyMatchingTiles(Hand, EligibleTails, MatchingTiles),
	identifyEligibleTiles(Hand, MatchingTiles, EligibleTails, DoublesPlaced, EligibleTiles).

% ******************************************************************************* 
% Clause Name: identifyMatchingTiles
% Purpose: To get the tiles that match the end of any eligible train
% Parameters: 
%			Hand, the tiles in the player hand
%			EligibleTails, list of train end values

% Return Value: a list, tiles that match the end of any eligible train
% Assistance Received: none 
% *******************************************************************************
identifyMatchingTiles([], _, []).
identifyMatchingTiles(Hand, EligibleTails, MatchingTiles):-
	[Tile|Rest] = Hand,
	doesTileMatchAnyTrain(Tile, EligibleTails, Matches),
	Matches,
	identifyMatchingTiles(Rest, EligibleTails, NewMatchingTiles),

	addToEnd(NewMatchingTiles, Tile, MatchingTiles).
identifyMatchingTiles([_|Rest], EligibleTails, MatchingTiles):-
	identifyMatchingTiles(Rest, EligibleTails, MatchingTiles).

% ******************************************************************************* 
% Clause Name: identifyEligibleTiles
% Purpose: To identify all playable tiles in hand
% Parameters: 
%			Hand, the tiles in the player hand
%			MatchingTiles, tiles that match ends of eligible trains
% 			EligibleTails, list of train end values
%			DoublesPlaced, the number of doubles placed in this turn
%
% Return Value: a list, consisted of all playable tiles
% Algorithm:
%
%		if 1 double is placed, this is double, there is no playing non-double in hand and this is not the last tile in hand
%			this tile is not a candidate
%		end if
%	
%		else if 2 doubles are placed already and this is a double
%			this tile is not a candidate
%		end else if
%
%		else 
%			this tile is a candidate
%		end else
%	 
% Assistance Received: none 
% *******************************************************************************
identifyEligibleTiles(_, [], _,  _, []).
identifyEligibleTiles(Hand, MatchingTiles, EligibleTails, DoublesPlaced, EligibleTiles):-

	[Tile|Rest] = MatchingTiles,

	%if this tile is a double and ...
	isDouble(Tile, DoubleTile), DoubleTile,

	%if 1 double is placed and ...
	DoublesPlaced =:= 1,

	%if there is no playing non-double in hand and ...
	playingNonDoubleExists(Hand, EligibleTails, Exists), 
	Exists, 
	negate(Exists, DoesNotExist), 
	DoesNotExist = true,

	%if this is not the last tile in hand and ...
	length(Hand, Size), Size =\= 1,

	identifyEligibleTiles(Hand, Rest, EligibleTails, DoublesPlaced, EligibleTiles).

	%not eligible because double candidates placed after first turn are only eligible 
	%if there is a playing non-double in hand
    %unless it is the last the tile in hand which does not apply here
identifyEligibleTiles(Hand, MatchingTiles, EligibleTails, DoublesPlaced, EligibleTiles):-

	[Tile|Rest] = MatchingTiles,

	%if this tile is a double
	isDouble(Tile, DoubleTile), DoubleTile,

	%if 2 doubles are placed 
	DoublesPlaced =:= 2,

	identifyEligibleTiles(Hand, Rest, EligibleTails, DoublesPlaced, EligibleTiles).

	%not eligible because player must now play a non-double
    %all doubles are ineligible
identifyEligibleTiles(Hand, MatchingTiles, EligibleTails, DoublesPlaced, EligibleTiles):-
	
	%otherwise all matching tiles are eligible

	[Tile|Rest] = MatchingTiles,
	identifyEligibleTiles(Hand, Rest, EligibleTails, DoublesPlaced, NewEligibleTiles),

	addToEnd(NewEligibleTiles, Tile, EligibleTiles).

% ******************************************************************************* 
% Clause Name: doesTileMatchAnyTrain
% Purpose: To check whether a tile matches the end of any eligible game trains
% Parameters: 
%			Tile, the tile to check
%			EligibleTails, list of train end values

% Return Value: true if there is a match and false otherwise
% Assistance Received: none 
% *******************************************************************************
doesTileMatchAnyTrain(_, [], false).		
doesTileMatchAnyTrain(Tile, [TailVal|_], true):-

	%recieves: EligibleTails
	%if front or back of tile matches the tail of the train
	doesTileMatchVal(Tile, TailVal, Matches),
	Matches.
doesTileMatchAnyTrain(Tile, [TailVal|Rest], Outcome):- 
	%if neither front or back of tile matches the tail of the train
	getFront(Tile, Front), 
	getBack(Tile, Back), 
	Front =\= TailVal, Back =\= TailVal, 
	doesTileMatchAnyTrain(Tile, Rest, Outcome).

% ******************************************************************************* 
% Clause Name: doesTileMatchVal
% Purpose: To check whether a tile matches a given value
% Parameters: 
%			Tile, the tile to check
%			Val, the train end value

% Return Value: true if it matches and false otherwise
% Assistance Received: none 
% *******************************************************************************
doesTileMatchVal(Tile, Val, true):-
	
	%if the front or back of tile matches the pip value
	getFront(Tile, Front), getBack(Tile, Back),
	(Front =:= Val ; Back =:= Val).
doesTileMatchVal(_, _, false).

% ******************************************************************************* 
% Clause Name: playingNonDoubleExists
% Purpose: To check whether a non-double in player hand is playable 
% Parameters: 
%			Hand, the player hand
%			EligibleTails, list of train end values

% Return Value: true if one exists and false otherwise
% Assistance Received: none 
% *******************************************************************************
playingNonDoubleExists([], _, false).
playingNonDoubleExists([Tile|_], EligibleTails, true):-
	
	%if there is a non-double in hand that matches an eligible train
	isNonDouble(Tile, NonDoubleTile),
	NonDoubleTile,

	doesTileMatchAnyTrain(Tile, EligibleTails, Matches),
	Matches.

playingNonDoubleExists([_|Rest], EligibleTails, Outcome):-
	playingNonDoubleExists(Rest, EligibleTails, Outcome).



% ***********************************************
% Source Code to allow computer to select a train
% ***********************************************

%the strategies used by the computer to select a train
trainStrategy(oneEligibleTrain, "IS THE ONLY ELIGIBLE TRAIN MATCHING THE SELECTED TILE").
trainStrategy(opponentUnavail, "COULD BE UNMARKED AND NOT AVAILABLE IN THE NEXT TURN").
trainStrategy(personalMexican, "IS ALMOST ALWAYS AVAILABLE TO THE OPPONENT").

% ******************************************************************************* 
% Clause Name: compSelectsTrain
% Purpose: To allow computer to select a train
% Parameters: 
%			Round, list consisted of round elements
%			SelectedTile, the selected tile

% Return Value: an integer, a train number
% Assistance Received: none 
% *******************************************************************************
compSelectsTrain(Round, SelectedTile, SelectedTrain):-

	%identify eligible trains
	getCompTrain(Round, CompTrain),
	getHumanTrain(Round, HumanTrain),
	getMexicanTrain(Round, MexicanTrain),
	getCurrentPlayer(Round, CurrentPlayer),

	%eligibleTrains is a boolean list (true/false true/false true/false)
	identifyEligibleTrains(CompTrain, HumanTrain, MexicanTrain, CurrentPlayer, EligibleTrains),

	%identify train that is eligible and matches the selected tile (eligible matching)

	%1 --> start of trains
	getEligibleMatchingTrains(Round, SelectedTile, EligibleTrains, 1, TrainNums),

	pickFromEligibleMatchingTrains(CurrentPlayer, TrainNums, SelectedTrain).

% ******************************************************************************* 
% Clause Name: getEligibleMatchingTrains
% Purpose: To find trains that are eligible and match the selected tile
% Parameters: 
%			Round, list consisted of round elements
%			SelectedTile, the selected tile
% 			EligibleTrains, the trains that are eligible
%			TrainNum, the starting number of the trains

% Return Value: a list of integers, indicating eligible train numbers
% Assistance Received: none 
% *******************************************************************************
getEligibleMatchingTrains(_, _, [], _, []).
getEligibleMatchingTrains(Round, SelectedTile, EligibleTrains, TrainNum, TrainNums):-

	NewTrainNum is TrainNum + 1,

	[Indicator|Rest] = EligibleTrains,

	%if train is eligible and matches the selected tile
	Indicator,
	getTrainByNum(Round, TrainNum, Train), 
	getTailVal(Train, TailVal), 
	 
	doesTileMatchVal(SelectedTile, TailVal, Matches), Matches, 

	getEligibleMatchingTrains(Round, SelectedTile, Rest, NewTrainNum, NewTrainNums),

	append(NewTrainNums, [TrainNum], TrainNums).
getEligibleMatchingTrains(Round, SelectedTile, EligibleTrains, TrainNum, TrainNums):-

	NewTrainNum is TrainNum + 1,
		
	[_|Rest] = EligibleTrains,

	getEligibleMatchingTrains(Round, SelectedTile, Rest, NewTrainNum, TrainNums).

% ******************************************************************************* 
% Clause Name: pickFromEligibleMatchingTrains
% Purpose: To select from eligible matching trains
% Parameters: 
%			CurrentPlayer, the current player
% 			EligibleMatchingTrains, the trains that are eligible and matching

% Return Value: an integer, a train number
% Assistance Received: none 
% *******************************************************************************
pickFromEligibleMatchingTrains(CurrentPlayer, EligibleMatchingTrains, SelectedTrain):-

	%if there is more than one matching eligible trains
	length(EligibleMatchingTrains, Size), 
	Size > 1,

	pickFromMultipleMatchingTrains(CurrentPlayer, EligibleMatchingTrains, SelectedTrain).
pickFromEligibleMatchingTrains(CurrentPlayer, EligibleMatchingTrains, SelectedTrain):-

	%if there is only one matching eligible train
	length(EligibleMatchingTrains, Size), 
	Size =:= 1,

	%select the only eligible train
	[SelectedTrain|_] = EligibleMatchingTrains,

	printTrainStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%only eligible train that matches the selected tile
	trainStrategy(oneEligibleTrain, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	getTrainName(SelectedTrain, Name), 
	format(Name), nl.

% ******************************************************************************* 
% Clause Name: pickFromMultipleMatchingTrains
% Purpose: To select from multiple eligible matching trains
% Parameters: 
%			CurrentPlayer, the current player
% 			EligibleMatchingTrains, the trains that are eligible and matching

% Return Value: an integer, a train number
% Assistance Received: none 
% *******************************************************************************
pickFromMultipleMatchingTrains(CurrentPlayer, EligibleMatchingTrains, SelectedTrain):-

	%if there is 2 eligible trains 
	length(EligibleMatchingTrains, Size), 
	Size =:= 2,

	%to get personal train to first slot
	sort(EligibleMatchingTrains, NewEligibleMatchingTrains),

	%if they are personal and mexican
	getPersonalTrainNum(CurrentPlayer, PersonalTrainNum),
	[FirstNum, SecondNum|_] = NewEligibleMatchingTrains,
	FirstNum =:= PersonalTrainNum,

	trainMenu(mexicanTrain, MexicanNum), 
	SecondNum =:= MexicanNum,

	%select mexican train
	SelectedTrain = MexicanNum,

	printTrainStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%mexican is almost always available to the opponent
	trainStrategy(personalMexican, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	getTrainName(SelectedTrain, Name), 
	format(Name), nl.
pickFromMultipleMatchingTrains(CurrentPlayer, _, SelectedTrain):-

	%otherwise
	%select opponent train
	getOpponentTrainNum(CurrentPlayer, SelectedTrain),

	printTrainStrategy(CurrentPlayer),

	%look up the strategy reasoning
	%opponent train could be unmarked and not available in the next turn
	trainStrategy(opponentUnavail, Strategy),

	%display the strategy
	format(Strategy),
	format(" --> "), 
	getTrainName(SelectedTrain, Name), 
	format(Name), nl.

% ******************************************************************************* 
% Clause Name: printTrainStrategy
% Purpose: To inform user about the logistics behind compuetr train selection
% Parameters: 
%			CurrentPlayer, the current player

% Return Value: None
% Assistance Received: none 
% *******************************************************************************
printTrainStrategy(CurrentPlayer):-
	player(comp, Comp),
	CurrentPlayer =:= Comp,
	format("THE COMPUTER SELECTED THE FOLLOWING TRAIN BECAUSE IT ").
printTrainStrategy(CurrentPlayer):-
	player(human, Human),
	CurrentPlayer =:= Human,
	format("THE COMPUTER SUGGESTS SELECTING THE FOLLOWING TRAIN BECAUSE IT ").

% ******************************************************************************* 
% Clause Name: getTrainName
% Purpose: To get the name of the game trains by number
% Parameters: 
%			TrainNum, the train number

% Return Value: a string, the train name
% Assistance Received: none 
% *******************************************************************************
getTrainName(TrainNum, TrainName):-
	trainMenu(compTrain, Comp),
	TrainNum =:= Comp, 
	TrainName = "COMPUTER TRAIN".
getTrainName(TrainNum, TrainName):-
	trainMenu(humanTrain, Human),
	TrainNum =:= Human, 
	TrainName = "HUMAN TRAIN".
getTrainName(TrainNum, TrainName):-
	trainMenu(mexicanTrain, Mexican),
	TrainNum =:= Mexican, 
	TrainName = "MEXICAN TRAIN".



% ********************************************
% Source Code to allow human to select a train
% ********************************************

% ******************************************************************************* 
% Clause Name: humanSelectsTrain
% Purpose: To allow human to select a train
% Parameters: 
%			Round, list consisted of the round elements

% Return Value: an integer, a train number
% Assistance Received: none 
% *******************************************************************************
humanSelectsTrain(Round, SelectedTrain):-
	
	getCompTrain(Round, CompTrain),
	getHumanTrain(Round, HumanTrain),
	getMexicanTrain(Round, MexicanTrain),
	getCurrentPlayer(Round, CurrentPlayer),

	%eligibleTrains is a boolean list (true/false true/false true/false)
	identifyEligibleTrains(CompTrain, HumanTrain, MexicanTrain, CurrentPlayer, EligibleTrains),

	TrainNames = ["1) COMPUTER TRAIN", "2) YOUR TRAIN", "3) MEXICAN TRAIN"],
	
	%returns TrainOptions and ValidOptions (1 --> start of menu)
	getTrainOptions(EligibleTrains, TrainNames, 1, TrainOptions, ValidOptions),

	reverse(TrainOptions, NewTrainOptions),

	Prompt = ["SELECT THE TRAIN YOU WOULD LIKE TO PLACE THE TILE ON"],

	append(Prompt, NewTrainOptions, Menu),

	%prompt user to select a train
	nl, menuSelection(Menu, ValidOptions, SelectedTrain).

% ******************************************************************************* 
% Clause Name: retrieveEligibleTrainTails
% Purpose: To identify the eligible train tails
% Parameters: 
%			Round, list consisted of the round elements

% Return Value: a list of integers, the eligible train tails
% Assistance Received: none 
% *******************************************************************************
retrieveEligibleTrainTails(Round, EligibleTails):-
	getCompTrain(Round, CompTrain),
	getHumanTrain(Round, HumanTrain),
	getMexicanTrain(Round, MexicanTrain),
	getCurrentPlayer(Round, CurrentPlayer),

	identifyEligibleTrains(CompTrain, HumanTrain, MexicanTrain, CurrentPlayer, Indicators),
	getTrains(Round, Trains),
	getEligibleTrainTails(Trains, Indicators, EligibleTails).

% ******************************************************************************* 
% Clause Name: identifyEligibleTrains
% Purpose: To identify the eligible trains
% Parameters: 
%			CompTrain, the computer train
%			HumanTrain, the human train
%			MexicanTrain, the mexican train
%			CurrentPlayer, the current player

% Return Value: a list of booleans
% Assistance Received: none 
% *******************************************************************************
identifyEligibleTrains(CompTrain, HumanTrain, MexicanTrain, _, EligibleTrains):-

	%establish orphan double markers
	isTrainOrphan(CompTrain, CompOrphan),
	isTrainOrphan(HumanTrain, HumanOrphan),
	isTrainOrphan(MexicanTrain, MexicanOrphan),

	%if any of the trains is orphan double
	(CompOrphan ; HumanOrphan ; MexicanOrphan),

	EligibleTrains = [CompOrphan, HumanOrphan, MexicanOrphan].
identifyEligibleTrains(CompTrain, HumanTrain, MexicanTrain, CurrentPlayer, EligibleTrains):-

	%establish orphan double markers
	isTrainOrphan(CompTrain, CompOrphan),
	isTrainOrphan(HumanTrain, HumanOrphan),
	isTrainOrphan(MexicanTrain, MexicanOrphan),

	%if there is no orphan doubles
	negate(CompOrphan, NewComp),
	negate(HumanOrphan, NewHuman),
	negate(MexicanOrphan, NewMexican),
	NewComp , NewHuman , NewMexican,

	identifyEligiblePersonals(CompTrain, HumanTrain, CurrentPlayer, EligibleTrains).
	

% ******************************************************************************* 
% Clause Name: identifyEligiblePersonals
% Purpose: To identify the eligible trains based on current player
% Parameters: 
%			CompTrain, the computer train
%			HumanTrain, the human train
%			CurrentPlayer, the current player

% Return Value: a list of booleans
% Assistance Received: none 
% *******************************************************************************
identifyEligiblePersonals(_, HumanTrain, CurrentPlayer, EligibleTrains):-
	
	%if current player is computer 
	player(comp, Comp),
	CurrentPlayer =:= Comp,

	%computer and mexican trains are eligible

	%opponent train is eligible if marked
	isTrainMarked(HumanTrain, HumanMarked),

	EligibleTrains = [true, HumanMarked, true].
identifyEligiblePersonals(CompTrain, _, CurrentPlayer, EligibleTrains):-
	
	%if current player is human
	player(human, Human),
	CurrentPlayer =:= Human,

	%human and mexican trains are eligible

	%opponent train is eligible if marked
	isTrainMarked(CompTrain, CompMarked),

	EligibleTrains = [CompMarked, true, true].

% ******************************************************************************* 
% Clause Name: getEligibleTrainTails
% Purpose: To identify the eligible train tails
% Parameters: 
%			Trains, the game trains
%			EligiblityMarkers, booleans that indicate train eligiblity
%
% Return Value: a list of integers, eligible train tails
% Assistance Received: none 
% *******************************************************************************
getEligibleTrainTails([], _, []).
getEligibleTrainTails([Train|Tail], [Indicator|Rest], EligibleTails):- 
	
	%if train is eligible
	Indicator,

	getEligibleTrainTails(Tail, Rest, NewTails),

	getTailVal(Train, TailVal),
	append(NewTails, [TailVal], EligibleTails).
getEligibleTrainTails([_|Tail], [Indicator|Rest], EligibleTails):- 
	
	%if train is not eligible
	negate(Indicator, NewIndicator),
	NewIndicator,

	getEligibleTrainTails(Tail, Rest, EligibleTails).

% ******************************************************************************* 
% Clause Name: getTrainOptions
% Purpose: To get the eligiblity options of the trains
% Parameters: 
%			EligibleTrains, booleans that indicate train eligiblity
%			TrainNames, the name of the game trains
%			TrainNum, the train being checked
%
% Return Value:
%			TrainOptions, list of strings with trains names
%			TrainNums, list of integers with train numbers
% Assistance Received: none 
% *******************************************************************************
getTrainOptions([], _,  _, [], []).
getTrainOptions(EligibleTrains, TrainNames, TrainNum, TrainOptions, TrainNums):-

	NewTrainNum is TrainNum + 1,

	[Indicator|Rest] = EligibleTrains,
	[Name|Tail] = TrainNames,

	%if train is eligible
	Indicator,

	getTrainOptions(Rest, Tail, NewTrainNum, NewTrainOptions, NewTrainNums),

	append(NewTrainOptions, [Name], TrainOptions),
	append(NewTrainNums, [TrainNum], TrainNums).
getTrainOptions(EligibleTrains, TrainNames, TrainNum, TrainOptions, TrainNums):-

	NewTrainNum is TrainNum + 1,
		
	[_|Rest] = EligibleTrains,
	[Name|Tail] = TrainNames,

	getTrainOptions(Rest, Tail, NewTrainNum, NewTrainOptions, TrainNums),

	string_concat(Name, " - NOT ELIGIBLE", Option),
	append(NewTrainOptions, [Option], TrainOptions).
