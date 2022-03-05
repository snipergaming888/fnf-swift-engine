package;

#if cpp
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.Lib;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;

class ApperanceOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	var controlsStrings:Array<String> = [];
	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var descBG:FlxSprite;
	var camFollow:FlxObject;
	var sex:Alphabet;
	var menuBG:FlxSprite;
	override function create()
	{
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		menuBG.scrollFactor.set();
		menuBG.x -= 30;	
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD") + "\n" + (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF") + "\n" + (FlxG.save.data.hittimings ? "MS Timing info ON" : "MS Timing info OFF") + "\n" + (FlxG.save.data.showratings ? "ratings info ON" : "ratings info OFF") + "\n" + (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION off")+ "\n" + (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off")+ "\n" + (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF") + "\n" + (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF")  + "\n" + (FlxG.save.data.minscore ? "minimalize score info ON" : "minimalize score info OFF") + "\n" + (FlxG.save.data.nps ? "NPS ON" : "NPS OFF") + "\n" + (FlxG.save.data.healthcolor ? 'new healthbar on' : 'new healthbar off') + "\n" + (FlxG.save.data.newhealthheadbump ? 'new healthhead bump on' : 'new healthhead bump off') + "\n" + (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF") + "\n" + (FlxG.save.data.togglecap ? "FPS CAP ON" : "FPS CAP OFF") + "\n" + (FlxG.save.data.memoryMonitor ? "memoryMonitor ON" : "memoryMonitor OFF") + "\n" + (FlxG.save.data.middlecam ? "Camera focusing ON" : "Camera focusing OFF"));
		
		trace(controlsStrings);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
			{                                  //100
			var ctrl:Alphabet = new Alphabet(0, (80 * i) + 60, controlsStrings[i], true, false);
		    ctrl.ID = i;
			ctrl.y += 102;
			ctrl.x += 50;
		    grpControls.add(ctrl);
			}//70

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.scrollFactor.set();
		descBG.screenCenter(X);
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);


		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Appearance Options Menu", null);
		#end
		
		super.create();
	}

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				{
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					FlxG.switchState(new MenuState());
				}
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

			
				
					if (controls.UP_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							curSelected -= 1;
							for (item in grpControls.members)
								{
									if (item.targetY == 0)
									{
									
										camFollow.setPosition(item.getGraphicMidpoint().x + 600, item.getGraphicMidpoint().y);
										FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
											
										// item.setGraphicSize(Std.int(item.width));
									}
								}
						}
			
					if (controls.DOWN_P)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'));
							curSelected += 1;
							for (item in grpControls.members)
								{
									if (item.targetY == 0)
									{
									
										camFollow.setPosition(item.getGraphicMidpoint().x + 600, item.getGraphicMidpoint().y + 200);
										FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
											
											
										// item.setGraphicSize(Std.int(item.width));
									}
								}
						}
				

				if (curSelected < 0)
					curSelected = 0;
		
				if (curSelected > 17)
					curSelected = 17;
	
				grpControls.forEach(function(sex:Alphabet)
					{
			
						if (sex.ID == curSelected)
							sex.alpha = 1;
						else
							sex.alpha = 0.7;
					});
	
					/*grpControls.forEach(function(sex:Alphabet)
						{
							if (sex.ID == curSelected)
							{
								camFollow.setPosition(sex.getGraphicMidpoint().x + 600, sex.getGraphicMidpoint().y + 200);
								FlxG.camera.follow(camFollow, null, 0.06);
							}
						});*/
					var bullShit:Int = 0;
	
					for (item in grpControls.members)
						{
							item.targetY = bullShit - curSelected;
							bullShit++;
	
							item.alpha = 0.7;
							// item.setGraphicSize(Std.int(item.width * 0.8));
				
							if (item.targetY == 0)
							{
								item.alpha = 1;
								// item.setGraphicSize(Std.int(item.width));
							}
						}
			
			if (curSelected == 15)
				{
					var multiply:Float = 1;

					if (FlxG.keys.pressed.SHIFT && FlxG.save.data.fpsCap < 1000 && FlxG.save.data.fpsCap > 30 && FlxG.save.data.togglecap)
						multiply = 10;
			
					if (FlxG.keys.justPressed.RIGHT && FlxG.save.data.fpsCap < 1000 && FlxG.save.data.togglecap)
						{
								{
									FlxG.save.data.fpsCap += 1 * multiply;
									(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
									FlxG.updateFramerate = FlxG.save.data.fpsCap;
				                    FlxG.drawFramerate = FlxG.save.data.fpsCap;
								}
						}
					if (FlxG.keys.justPressed.LEFT && FlxG.save.data.fpsCap > 20 && FlxG.save.data.togglecap)
						{
								{
									FlxG.save.data.fpsCap -= 1 * multiply;
									(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
									FlxG.updateFramerate = FlxG.save.data.fpsCap;
				                    FlxG.drawFramerate = FlxG.save.data.fpsCap;
								}
						}
			
					if (FlxG.keys.justPressed.SPACE && FlxG.save.data.togglecap)
					{
						FlxG.save.data.fpsCap = 138;
						(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
					}
				}

			if (curSelected == 0)
				versionShit.text = "Hide all text and the healthbar.";

			if (curSelected == 1)
				versionShit.text = "Hide all UI, strumline, and notes.";

			if (curSelected == 2)
				versionShit.text = "Show in miliseconds how long it took for you to hit a note.";

			if (curSelected == 3)
				versionShit.text = "Show how many sicks, goods, bads and shits you get off to the side.";

			if (curSelected == 4)
				versionShit.text = "Show what position in the song you are.";

			if (curSelected == 5)
				versionShit.text = "Wether or not to have note trails transparent or not transparent.";

			if (curSelected == 6)
				versionShit.text = "Wether or not to have the CPU strums light up.";

			if (curSelected == 7)
				versionShit.text = "Wether or not to have the player strums light up.";

			if (curSelected == 8)
				versionShit.text = "Wether or not to have the camera zoom in on beat.";

			if (curSelected == 9)
				versionShit.text = "Wether or not to show engine watermarks. (will not remove botplay text)";

			if (curSelected == 10)
				versionShit.text = "Wether or not to show only score info.";

			if (curSelected == 11)
				versionShit.text = "Wether or not to show notes per second.";

			if (curSelected == 12)
				versionShit.text = "If the healthbar should be the color of the player (1 or 2).";

			if (curSelected == 13)
				versionShit.text = "If the healthbar heads should act like the ones from week 7. (new healthhead bump)";

			if (curSelected == 14)
				versionShit.text = "Toggle the FPS counter on and off.";
			
			if (curSelected == 15)
				versionShit.text = "Set the FPS cap. FPS: " + FlxG.save.data.fpsCap + " (Left, Right, Space to reset, Shift to go faster)";

			if (curSelected == 16)
				versionShit.text = "Toggle the memory monitor on and off.";

			if (curSelected == 17)
				versionShit.text = "Toggle if the camera should point at player 1 and 2 when they are singing.";


			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.hideHUD = !FlxG.save.data.hideHUD;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD"), true, false);
						ctrl.y += 102;
			        	ctrl.x += 50;
						ctrl.targetY = curSelected - 0;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
				    case 1:
						grpControls.remove(grpControls.members[curSelected]);
					    FlxG.save.data.cinematic = !FlxG.save.data.cinematic;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF"), true, false);
						ctrl.y += 102;
			        	ctrl.x += 50;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					 case 2:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.hittimings = !FlxG.save.data.hittimings;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.hittimings ? "MS Timing info ON" : "MS Timing info OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 3:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.showratings = !FlxG.save.data.showratings;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.showratings ? "Ratings info on" : "Ratings info on"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					 case 4:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 4;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
                     case 5:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.transparency = !FlxG.save.data.transparency;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 5;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 6:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.strumlights = !FlxG.save.data.strumlights;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 6;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 7:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.playerstrumlights = !FlxG.save.data.playerstrumlights;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 7;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 8:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.camzooming = !FlxG.save.data.camzooming;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 8;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 9:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.watermarks = !FlxG.save.data.watermarks;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 9;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 10:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.minscore = !FlxG.save.data.minscore;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.minscore ? "minimalize score info ON" : "minimalize score info OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 10;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 11:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.nps = !FlxG.save.data.nps;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.nps ? "NPS ON" : "NPS OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 11;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 12:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.healthcolor = !FlxG.save.data.healthcolor;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.healthcolor ? 'new healthbar on' : 'new healthbar off'), true, false);
						ctrl.x += 50;
						ctrl.y += 102;
						ctrl.targetY = curSelected - 12;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 13:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.newhealthheadbump = !FlxG.save.data.newhealthheadbump;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.newhealthheadbump ? 'new healthhead bump on' : 'new healthhead bump off'), true, false);
						ctrl.x += 50;
						ctrl.y += 102;
						ctrl.targetY = curSelected - 13;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 14:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.fps = !FlxG.save.data.fps;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF"), true, false);
						ctrl.x += 50;
						ctrl.y += 102;
						ctrl.targetY = curSelected - 14;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
						(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
					case 15:
						FlxG.save.data.togglecap = !FlxG.save.data.togglecap;
						if (!FlxG.save.data.togglecap)
							{
							    (cast (Lib.current.getChildAt(0), Main)).setFPSCap(138);
								FlxG.updateFramerate = 138;
				                FlxG.drawFramerate = 138;
							}
						else if (FlxG.save.data.togglecap)
							{
								(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
								FlxG.updateFramerate = FlxG.save.data.fpsCap;
				                FlxG.drawFramerate = FlxG.save.data.fpsCap;
							}
						grpControls.remove(grpControls.members[curSelected]);
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.togglecap ? "FPS CAP ON" : "FPS CAP OFF"), true, false);
						ctrl.x += 50;
						ctrl.y += 102;
						ctrl.targetY = curSelected - 15;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
						trace("pressed");
					case 16:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.memoryMonitor = !FlxG.save.data.memoryMonitor;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.memoryMonitor ? "memoryMonitor ON" : "memoryMonitor OFF"), true, false);
						ctrl.x += 50;
						ctrl.y += 102;
						ctrl.targetY = curSelected - 16;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
						(cast (Lib.current.getChildAt(0), Main)).togglememoryMonitor(FlxG.save.data.memoryMonitor);
					case 17:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.middlecam = !FlxG.save.data.middlecam;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.middlecam ? "camera focusing ON" : "camera focusing Off"), true, false);
						ctrl.x += 50;
						ctrl.y += 102;
						ctrl.targetY = curSelected - 17;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));									   	
				}
			}
	}

	var isSettingControl:Bool = false;


	override function beatHit()
		{
			super.beatHit();


			if (accepted)
				{
					bopOnBeat();
					///iconBop();
					trace(curBeat);
				}
		}

		function bopOnBeat()
			{
				if (accepted)
				{
					if (Conductor.bpm == 180 && curBeat >= 168 && curBeat < 200)
						{
							if (curBeat % 1 == 0)
								{
									FlxG.camera.zoom += 0.030;
								}
						}
						    if (curBeat % 1 == 0)
						    	{
									if (TitleState.old)
										{
											trace('no');
										}
										else if (FlxG.save.data.camzooming)
											{
												FlxG.camera.zoom += 0.015;
												camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
												trace('zoom');
											}
											else
											{
												trace('no');
											}
							    }

				}
			}

	var accepted:Bool = true;
}
