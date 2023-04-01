package util;

import haxe.io.Bytes;
import flixel.FlxG;
import openfl.Lib;
import lime.ui.Window;
import states.PlayState;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static inline function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static inline function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		return [for (item in daList) item.trim()];
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		return [for (num in min...max) num];
	}

	public static inline function getMainWindow():Window
	{
		return Lib.application.window;
	}

	public static inline function BytestoIntArray(bytes:Bytes):Array<Int> {
		return [for (idx in 0...bytes.length) bytes.getInt32(idx)];
	}
}

class FPSLerp
{
	public static function lerpValue(ratio:Float):Float
	{
		return FlxG.elapsed / (1 / 60) * ratio;
	}

	public static function lerp(a:Float, b:Float, ratio:Float)
	{
		return a + lerpValue(ratio) * (b - a);
	}
}
