extends Control

export(Array, NodePath) var TilesArray;

var TilesPosition = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,-1]
var gameOver:bool = false;

func _ready():
	NewGame();
	pass

func NewGame():
	SuffleTiles();
	PlaceTiles();
	
	gameOver = false;


func SuffleTiles():
	randomize();
	Reset();
	Shuffle();
	
	while(!IsSolvable()): # make it until grid be solvable
		Reset();
		Shuffle();

func Reset():
	TilesPosition = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,-1]

#function shuffle(o){
#for(var i = 0; i < o.length; ++i)
#{
#var j = Math.floor(Math.random() * i);
#var x = o[i];
#o[i] = o[j];
#o[j] = x;
#}
#//console.log(o);
#var inversiones = 0;
#var emptyIndex = 8;
#for(var i2 = 0; i2 < o.length - 1; ++i2)
#{
#if(o[i2] === 8) emptyIndex = i2;
#for(var j2 = i2 + 1; j2 < o.length; ++j2)
#{
#if(o[i2] !== 8 && o[j2] !== 8 && o[i2] < o[j2])
#inversiones += 1;
#}
#}
#//console.log(inversiones);
#
#if(inversiones%2 !== 0) //No solvable
#{
#if(emptyIndex <= 1) //change last tiles
#{
#var a = o[8];
#o[8] = o[7];
#o[7] = a;
#}
#else
#{
#var b = o[1];
#o[1] = o[0];
#o[0] = b;
#}
#}
#
#return o;
#}

func Shuffle():
	# don't include the blank tile in the shuffle, leave in the solved position
	var n:int = 15;
	
	while (n > 1):
		n = n - 1;
		var r:int = randi() % n;
		var tmp:int = TilesPosition[r];
		TilesPosition[r] = TilesPosition[n];
		TilesPosition[n] = tmp;


func IsSolvable()->bool:
	var numInversions:int = NumOfInversions();
	
	#The grid is even and empty is always odd (row 1 from bottom)
	var isNumInversionsEven:bool = (numInversions % 2) == 0;
	return isNumInversionsEven;


func NumOfInversions()->int:
	var inversions:int = 0;
	for i in range(0,14):
		for j in range(i,15):
			if (TilesPosition[i] > TilesPosition[j]):
				inversions += 1;
	return inversions;


func isSolved() -> bool:
	if (TilesPosition[15] != -1): #if blank tile is not in the solved position ==> not solved
		return false;
	
	for i in range(0, 15):
		if (TilesPosition[i] != i):
			return false;
	
	return true;


func PlaceTiles():
	for i in range(0,16):
		if TilesPosition[i] == -1:
			continue;
		var idx:int = TilesPosition[i];
		var x:int = (i % 4) * 60;
		var y:int = (i / 4) * 60;
		
		get_node(TilesArray[idx]).rect_position = Vector2(x,y);


func TrySlideTile(tileNum:int):
	#get the index position from tileNum
	var tilePos:int = TilesPosition.find(tileNum);
	
	#if the empty tile is not next to this return
	var x:int = (tilePos % 4);
	var y:int = (tilePos / 4);
	
	var leftTile:int = tilePos - 1 if x > 0 else -1;
	var rightTile:int = tilePos + 1 if x < 3 else -1;
	var upTile:int = tilePos - 4 if y > 0 else -1 ;
	var downTile:int = tilePos + 4 if y < 3 else -1;
		
	var nextPosition = Vector2(x*60,y*60);
	if leftTile != -1 and TilesPosition[leftTile] == -1: #has leftTile and is empty
		moveToTile(tileNum, tilePos, leftTile);
	elif rightTile != -1 and TilesPosition[rightTile] == -1: #has rrigthTile and is empty
		moveToTile(tileNum, tilePos, rightTile);
	elif upTile != -1 and TilesPosition[upTile] == -1: #has upTile and is empty
		moveToTile(tileNum, tilePos, upTile);
	elif downTile != -1 and TilesPosition[downTile] == -1: #has downTile and is empty
		moveToTile(tileNum, tilePos, downTile);


func moveToTile(tileNum:int, from:int, to:int) -> void:
	var x:int = (from % 4);
	var y:int = (from / 4);
	var currentPosition = Vector2(x*60,y*60);
	
	var next_x:int = (to % 4);
	var next_y:int = (to / 4);
	var nextPosition = Vector2(next_x*60,next_y*60)
	
	#move the tiles index in array
	TilesPosition[from] = -1;
	TilesPosition[to] = tileNum;
	
	#set tween to move the tile and block the tiles
	$slide.interpolate_property(get_node(TilesArray[tileNum]), "rect_position",
		currentPosition, nextPosition, 0.5);
	#run tween
	$slide.start();


func _on_slide_tween_completed(object, key):
	#add one to move countr
	#check if win game
	#unblock the tiles
	pass # Replace with function body.
