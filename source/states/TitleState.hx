package states;

import openfl.Lib;
#if hlvideo
import display.objects.HashlinkVideo.Video;
#end
import flixel.util.FlxGradient;
import sys.FileSystem;
import flixel.group.FlxSpriteGroup;
import display.objects.Notification;
import flixel.ui.FlxButton;
import openfl.filters.ShaderFilter;
import display.shaders.ColorSwap;
import flixel.addons.display.FlxBackdrop;
import openfl.display.BitmapData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileSquare;
import display.objects.ScrollableSprite;
import haxe.xml.Fast;
import display.objects.Flixel;
import haxe.Json;
import classes.Mod;
import states.abstr.UIBaseState;
import classes.Options;
import classes.Conductor;
import classes.Highscore;
import classes.PlayerSettings;
import display.objects.Alphabet;
#if (discord_rpc || hldiscord)
import classes.Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
import states.abstr.MusicBeatState;

using StringTools;

class TitleState extends UIBaseState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	override public function create():Void
	{
		backgroundSettings = {
			enabled: true,
			bgColor: 0xFF000000,
			imageFile: "",
			scrollFactor: [0, 0],
			bgColorGradient: [0xFF3B0651, 0xFF110810],
			gradientMix: 1,
			gradientAngle: -90
		}

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT
		trace('yes?: ${Options.getValue("Yes")}');

		super.create();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		UIBaseState.switchState(FreeplayState);
		#elseif CHARTING
		UIBaseState.switchState(ChartingState);
		#else
		startIntro();
		#end

		#if (discord_rpc || hldiscord)
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var stupid:ColorSwap;
	var thingy:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var backdrop:FlxBackdrop;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = Paths.image("square");
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			// FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.BLACK, 0.7, new FlxPoint(-1, 0), {asset: diamond, width: 32, height: 32},
				// new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			// FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.BLACK, 0.7, new FlxPoint(1, 0),
				// {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			
				// FlxTransitionableState.defaultTransOut.tweenOptions.ease = FlxEase.quartOut;
				// FlxTransitionableState.defaultTransIn.tweenOptions.ease = FlxEase.circOut;

			// transIn = FlxTransitionableState.defaultTransIn;
			// transOut = FlxTransitionableState.defaultTransOut;
		}

		
		FlxG.sound.playMusic(Paths.music('freakyMenu'), true);

		FlxG.sound.music.fadeIn(4, 0, 0.7);

		var settings = Json.parse(Paths.getTextFromFile("data/freakyMenu.json"));
		Conductor.bpm = settings.bpm;

		persistentUpdate = true;

		var grid:BitmapData = FlxGridOverlay.createGrid(Std.int(512 / 8), Std.int(512 / 8), 512, 512, true, 0xFFFFFFFF, 0x00000000);

		backdrop = new FlxBackdrop(grid);
		backdrop.blend = SCREEN;
		backdrop.alpha = 0.25;
		backdrop.velocity.x = -100;
		add(backdrop);

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);
		
		stupid = new ColorSwap();
		var filter:ShaderFilter = new ShaderFilter(stupid.shader);
		filter.blendMode = NORMAL; // this is stupid, i've made a fix for this just now https://github.com/openfl/openfl/pull/2619
		FlxG.camera.setFilters([filter]);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		thingy = FlxGradient.createGradientFlxSprite(Std.int(bg.width), Std.int(bg.height), [0xFFFFFFFF, 0x00FFFFFF], 0, 90, true);
		// thingy.blend = OVERLAY;
		// thingy.alpha = 0.75;
		add(thingy);

		FlxG.mouse.visible = true;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		#if hlvideo
		var video = new Video();
		video.loadPath("D:/Documents/hlvideotest/res/Untitledav1.mkv");
		video.scale.x = (FlxG.width / 256);
		video.scale.y = (FlxG.height / 144);
		video.updateHitbox();
		add(video);
		#end

		// var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));
		// var text:FlxText = new FlxText(0,0, FlxG.width, "", 16, true);
		// text.textField.htmlText = md;
		// text.screenCenter(Y);
		// text.alignment = CENTER;
		// var scroll:ScrollableSprite = new ScrollableSprite(0, 0, FlxG.width, FlxG.height);
		// scroll.add(text);
		// add(scroll);

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (!initialized)
			return;


		if (FlxG.keys.pressed.LEFT)
			stupid.update(-elapsed * 0.15);

		if (FlxG.keys.pressed.RIGHT)
			stupid.update(elapsed * 0.15);

		if (FlxG.sound.music != null) {
			Conductor.songPosition = FlxG.sound.music.time;
		}

		if (backdrop != null)
			backdrop.y = Math.abs(Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * Math.PI) * 20);

		
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Check if version is outdated

				#if newgrounds
				var version:String = "v" + Application.current.meta.get('version');
				#else
				var version:String = "";
				#end

				// if (version.trim() != NGio.GAME_VER_NUMS.trim() && !OutdatedSubState.leftState)
				// {
				// 	FlxG.switchState(new OutdatedSubState());
				// 	trace('OLD VERSION!');
				// 	trace('old ver');
				// 	trace(version.trim());
				// 	trace('cur ver');
				// 	trace(NGio.GAME_VER_NUMS.trim());
				// }
				// else
				// {
				UIBaseState.switchState(MainMenuState);
				// }
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (logoBl != null)
			logoBl.animation.play('bump');
		danceLeft = !danceLeft;

		if (gfDance != null)
		{
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				createCoolText(['In association', 'with']);
			case 7:
				addMoreText('newgrounds');
				ngSpr.visible = true;
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText('Friday');
			// credTextShit.visible = true;
			case 14:
				addMoreText('Night');
			// credTextShit.text += '\nNight';
			case 15:
				addMoreText('Funkin'); // credTextShit.text += '\nFunkin';

			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
