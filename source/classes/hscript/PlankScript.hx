package classes.hscript;

import display.objects.Alphabet;
import display.objects.Character;
import states.PlayState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;

// TODO: make this class
class PlankScript {
    public static var parser:Parser = new Parser();
    public static var scripts:Array<PlankScript> = [];

    var source:String;
    var expression:Expr;
    public var interp:Interp;

    public var variables(get, null):Map<String, Dynamic>;

    public function new(code:String) {
        this.source = code;
        this.interp = new Interp();
        parser.allowTypes = true;
        parser.allowJSON = true;

        expression = parser.parseString(source);
        setupVariables();
        parser.parseModule(source);
    }

    private function setupVariables() {
        setVariable('FlxG', FlxG);
		setVariable('FlxSprite', FlxSprite);
		setVariable('FlxCamera', FlxCamera);
		setVariable('FlxTimer', FlxTimer);
		setVariable('FlxTween', FlxTween);
		setVariable('FlxEase', FlxEase);
		setVariable('PlayState', PlayState);
		setVariable('Paths', Paths);
		setVariable('Mod', Mod);
		setVariable('Conductor', Conductor);
		setVariable('Character', Character);
		setVariable('Alphabet', Alphabet);
		setVariable('StringTools', StringTools);

		setVariable('sendMessage', function(value:Array<Dynamic>)
		{
			sendMessage(value);
		});
    }

    public function sendMessage(value:Array<Dynamic>) {
        for (script in scripts)
            script.callFunction("onMessage", value);
    }

    public function callFunction(functionName:String, arguments:Array<Dynamic>) {
        @:privateAccess
        var callReturn:Dynamic = interp.fcall(expression, functionName, arguments);
        
        return callReturn;
    }

	function get_variables():Map<String, Dynamic> {
		return interp.variables;
	}

    function setVariable(name:String, varber:Dynamic) {
        interp.variables.set(name, varber);
    }
}