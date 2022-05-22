package;

#if cpp
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.math.FlxMath;
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
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import lime.ui.Window;
using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;
	public static var old:Bool = false;
	public static var gamepad:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var CYAN:FlxColor = 0xFF00FFFF;
	var LIGHTBLUE:FlxColor = 0xFF00eaff;
	var logo:FlxSprite;
	var _controlsSave:FlxSave;
	public static var abletocache:Bool = false;

	var curWacky:Array<String> = [];
	var curWacky2:Array<String> = [];
	var curWacky3:Array<String> = [];
	var curWacky4:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{

		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "\\assets\\replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "\\assets\\replays");
		#end

		PlayerSettings.init();

		curWacky = FlxG.random.getObject(getIntroTextShit());
		curWacky2 = FlxG.random.getObject(getIntroTextShit2());
		curWacky3 = FlxG.random.getObject(getIntroTextShit3());
		curWacky4 = FlxG.random.getObject(getIntroTextShit4());


		// DEBUG BULLSHIT

		super.create();

		Settings.loadsettings();

		
		trace('default selected: ' + FlxG.save.data.curselected);
		
			
		FlxG.save.bind('swiftengine', 'snipergaming888');

		Highscore.load();
		keyCheck();

		#if cpp
		if (FlxG.save.data.discordrpc)
			{
				DiscordClient.initialize();
		
				Application.current.onExit.add (function (exitCode) {
					DiscordClient.shutdown();
				 });
			}
		#end

		#if cpp
		if (FlxG.save.data.discordrpc)
			DiscordClient.changePresence("Looking at the Title Menu", null);
		// Updating Discord Rich Presence
		#end

		

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

		
				new FlxTimer().start(0.0, function(tmr:FlxTimer)
					{
						if (FlxG.save.data.imagecache && Caching.notyetcached || FlxG.save.data.soundcache && Caching.notyetcached || FlxG.save.data.musiccache && Caching.notyetcached || FlxG.save.data.songcache && Caching.notyetcached)
							{
								FlxG.switchState(new Caching());
							}
							else
								{
								   startIntro();
								}
											
										
					});

	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			
				if (FlxG.save.data.togglecap)
					{
						openfl.Lib.current.stage.frameRate = FlxG.save.data.fpsCap;
						trace('CAP CAP CAP CAP');
					}
				
			trace('liam is a nerd');
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

					
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			old = false;			

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			trace('hi');
		}
				{
				 Conductor.changeBPM(102);
				}

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

			logoBl = new FlxSprite(-150, 0);
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
			if (FlxG.save.data.optimizations)
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin-opt');
			if (FlxG.save.data.antialiasing)
			logoBl.antialiasing = true;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
			logoBl.animation.play('bump');
			logoBl.updateHitbox();
			FlxTween.tween(logoBl, {y: -100 }, 0.5, { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut, startDelay: 0, loopDelay: 0.0});
			// logoBl.screenCenter();
			// logoBl.color = FlxColor.BLACK;
	
			gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
			gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
			if (FlxG.save.data.optimizations)
			gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle-opt');	
			gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			if (FlxG.save.data.antialiasing)
			gfDance.antialiasing = true;
			add(gfDance);
			add(logoBl);
	
			titleText = new FlxSprite(100, FlxG.height * 0.8);
			titleText.frames = Paths.getSparrowAtlas('titleEnter');
			if (FlxG.save.data.optimizations)
			titleText.frames = Paths.getSparrowAtlas('titleEnter-opt');		
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
			titleText.antialiasing = true;
			titleText.animation.play('idle');
			titleText.updateHitbox();
			// titleText.screenCenter(X);
			add(titleText);
		
		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		if (FlxG.save.data.optimizations)
		logo = new FlxSprite().loadGraphic(Paths.image('logo-opt'));
		logo.screenCenter();
		if (FlxG.save.data.antialiasing)
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
		if (FlxG.save.data.optimizations)
		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo-opt'));
		else
		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		if (FlxG.save.data.antialiasing)
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);

		if (FlxG.mouse.visible = true)
			{
				FlxG.mouse.visible = false;
				trace('no mouse');
			}
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

	function getIntroTextShit2():Array<Array<String>>
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

		function getIntroTextShit3():Array<Array<String>>
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

			function getIntroTextShit4():Array<Array<String>>
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

		if (FlxG.keys.justPressed.T)
			{
				FlxG.switchState(new TestState());
			}
			
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
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
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			titleText.animation.play('press');
			FlxG.camera.flash(FlxColor.WHITE, 1);
			if (old)
				{
					FlxG.sound.play(Paths.sound('titleShoot'), 0.7);
				}
				else
					{
						FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
					}
					

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{

			    {
					{
						FlxG.switchState(new MainMenuState());
					}
				}

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
			money.y -= 350;
			FlxTween.tween(money, {y: money.y + 350}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.0});
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
		coolText.y -= 350;
		FlxTween.tween(coolText, {y: coolText.y + 350}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.0});
	}

		function addMoreTextcolorsnipergaming(text:String)
			{
				var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
				coolText.screenCenter(X);
				coolText.color = FlxColor.BROWN;
				coolText.y += (textGroup.length * 60) + 200;
				credGroup.add(coolText);
				textGroup.add(coolText);
				coolText.y -= 350;
				FlxTween.tween(coolText, {y: coolText.y + 350}, 0.5, {ease: FlxEase.expoOut, startDelay: 0.0});
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
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;
		if (FlxG.save.data.camzooming)
			{
				FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});	
			}
			else
				{
					trace('no zomming');
				}
		///poly i thought you used flx camera lerp but i guess not
		FlxG.log.add(curBeat);
		danceLeft = !danceLeft;
			
				logoBl.animation.play('bump');

				if (danceLeft)
					gfDance.animation.play('danceRight');
				else
					gfDance.animation.play('danceLeft');


		FlxG.log.add(curBeat);

		if (old)
			{
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
					 createCoolText(['swift engine', 'by']);
				 case 7:
					 #if cpp
					 addMoreTextcolorsnipergaming('sniper gaming');
					 #else
					 addMoreText('sniper gaming');
					 #end
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
					 createCoolText([curWacky2[0]]);	
				 // credTextShit.visible = true;
				 case 14:
					 addMoreText(curWacky2[1]);
				 // credTextShit.text += '\nlmao';
				 case 15:
					 deleteCoolText();
				 // credTextShit.visible = false;
				 // credTextShit.text = "Friday";
				 // credTextShit.screenCenter();
				 case 16:
					 createCoolText([curWacky3[0]]);	
				 // credTextShit.visible = true;
				 case 17:
					 addMoreText(curWacky3[1]);
				 // credTextShit.text += '\nlmao';
				 case 18:
					 deleteCoolText();
				 // credTextShit.visible = false;
				 // credTextShit.text = "Friday";
				 // credTextShit.screenCenter();
				 case 19:
					 createCoolText([curWacky4[0]]);	
				 // credTextShit.visible = true;
				 case 20:
					 addMoreText(curWacky4[1]);
				 // credTextShit.text += '\nlmao';
				 case 21:
					 deleteCoolText();
                 case 22:
					    createCoolText(['what do i put here']);
					// credTextShit.visible = true;
					case 23:
						addMoreText('umm idk');
					// credTextShit.text += '\nlmao';
					case 24:
						deleteCoolText();

					case 25:
						createCoolText(['Xentidoe']);
						// credTextShit.visible = true;
					case 26:
						addMoreText('i love you');
						// credTextShit.text += '\nlmao';
					case 27:
							deleteCoolText();
				 case 28:
					 addMoreText('Friday');
				 // credTextShit.visible = true;
				 /// friday night funkin night funkin
				 case 29:
					 addMoreText('Night');
				 // credTextShit.text += '\nNight';
				 case 30:
					 addMoreText('Funkin'); // credTextShit.text += '\nFunkin';

				case 31:
					 addMoreText('swift Engine'); // credTextShit.text += '\nFunkin';
	 
				 case 32:
					 skipIntro();
				}
			}
			else
				{
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
							createCoolText(['swift engine', 'by']);
						case 7:
							#if cpp
							addMoreTextcolorsnipergaming('sniper gaming');
							#else
							addMoreText('sniper gaming');
							#end
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
						/// friday night funkin night funkin
						case 14:
							addMoreText('Night');
						// credTextShit.text += '\nNight';
						case 15:
							addMoreText('Funkin'); // credTextShit.text += '\nFunkin';
			
						case 16:
							skipIntro();
					}
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
	


	public static function resetBinds():Void{

        FlxG.save.data.upBind = "UP";
        FlxG.save.data.downBind = "DOWN";
        FlxG.save.data.leftBind = "LEFT";
        FlxG.save.data.rightBind = "RIGHT";
		PlayerSettings.player1.controls.loadKeyBinds();
		trace('RESET BINDS TO:');
		trace('${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}');
	}

    public static function keyCheck():Void
    {
        if(FlxG.save.data.upBind == null){
            FlxG.save.data.upBind = "UP";
			trace("DEFAULT BIND");
        }
        if(FlxG.save.data.downBind == null){
            FlxG.save.data.downBind = "DOWN";
			trace("DEFAULT BIND");
        }
        if(FlxG.save.data.leftBind == null){
            FlxG.save.data.leftBind = "LEFT";
			trace("DEFAULT BIND");
        }
        if(FlxG.save.data.rightBind == null){
            FlxG.save.data.rightBind = "RIGHT";
			trace("DEFAULT BIND");
        }

		if(FlxG.save.data.upBind == "enter"){
            FlxG.save.data.upBind = "UP";
			trace("NOT BINDABLE");
        }
        if(FlxG.save.data.downBind == "enter"){
            FlxG.save.data.downBind = "DOWN";
			trace("NOT BINDABLE");
        }
        if(FlxG.save.data.leftBind == "enter"){
            FlxG.save.data.leftBind = "LEFT";
			trace("NOT BINDABLE");
        }
        if(FlxG.save.data.rightBind == "enter"){
            FlxG.save.data.rightBind = "RIGHT";
			trace("NOT BINDABLE");
        }

		if(FlxG.save.data.upBind == "0"){
            FlxG.save.data.upBind = "UP";
			trace("NOT BINDABLE");
        }
        if(FlxG.save.data.downBind == "0"){
            FlxG.save.data.downBind = "DOWN";
			trace("NOT BINDABLE");
        }
        if(FlxG.save.data.leftBind == "0"){
            FlxG.save.data.leftBind = "LEFT";
			trace("NOT BINDABLE");
        }
        if(FlxG.save.data.rightBind == "0"){
            FlxG.save.data.rightBind = "RIGHT";
			trace("NOT BINDABLE");
        }

		trace('UR BINDS ARE:');
        trace('${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}');
    }
}
