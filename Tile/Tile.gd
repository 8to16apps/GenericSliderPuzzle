tool
extends Control

signal TrySlide(tileNum)

export var TileColor:Color = Color.white setget SetTileColor, GetTileColor
export var TileNum:int = 0 setget SetTileNum, GetTileNum

var _tileNum:int = 0;
var _tileColor:Color = Color.white;

func _ready():
	pass


func SetTileColor(value:Color):
	_tileColor = value;
	$ColorRect.modulate = value;


func GetTileColor()->Color:
	return _tileColor;


func SetTileNum(value:int):
	_tileNum = value;
	var temp:String = String(value).pad_zeros(2);
	$Label.text = temp;


func GetTileNum()->int:
	return _tileNum;


func _on_Tile_pressed():
	print("Hola " + str(_tileNum) );
	emit_signal("TrySlide", _tileNum);
