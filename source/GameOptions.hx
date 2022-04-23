package;

#if cpp
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import Controls.KeyboardScheme;
import flixel.FlxSubState;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import openfl.Lib;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;

class GameOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	var HITVOL:Float = FlxG.save.data.hitsoundvolume;
	var scrollspeed:Float = FlxG.save.data.speedamount;
	var descBG:FlxSprite;
	var bg:FlxSprite;
	var text:FlxText;
	var ischeating:Bool = false;
	var camFollow:FlxObject;
	public static var ghosttappinghitsoundsenabled:Bool = false;
	var menuBG:FlxSprite;
	var sex:Alphabet;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		if (!Settings.enablebotplay)
			{
				FlxG.save.data.botplay = false;
			}			
		if (FlxG.save.data.ghosttappinghitsoundsenabled)
			{
				ghosttappinghitsoundsenabled = true;
			}
	    menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		menuBG.scrollFactor.set();
		menuBG.x -= 30;		
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\n" + (FlxG.save.data.middlescroll ? "middlescroll on" : "middlescroll off") + "\n" + (FlxG.save.data.ghosttapping ? "Ghost Tapping" : "No Ghost Tapping") + "\n" + (FlxG.save.data.oldinput ? "OLD INPUT ON" : "OLD INPUT OFF") + "\n" + (FlxG.save.data.antimash ? "anti mash ON" : " anti mash OFF") + "\n" + (FlxG.save.data.reset ? "RESET BUTTON ON" : "RESET BUTTON OFF") + "\n" + (FlxG.save.data.pausecount ? "pause counter on" : "pause counter off") + "\n" + (FlxG.save.data.repeat ? 'loop current song on' : 'loop current song off') + "\n" + (FlxG.save.data.hitsounds ? 'hitsounds on' : 'hitsounds off')  + "\n" + (FlxG.save.data.songspeed ? 'SET SCROLL SPEED ON' : 'SET SCROLL SPEED OFF') + "\n" + (FlxG.save.data.botplay ? 'BOTPLAY ON' : 'BOTPLAY OFF') + "\n" + (FlxG.save.data.missnotes ? 'miss sounds on' : 'miss sounds off') + "\n" + (FlxG.save.data.instantRespawn ? 'instant respawn on' : 'instant respawn off') + "\n" + "EDIT OFFSET");
		
		trace(controlsStrings);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		//FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		//FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		// ADD AUTO PAUSE TOGGLE FlxG.autoPause = false; (ADD TO PAUSE OPTIONS)
		// same with FlxGraphic.defaultPersist = true;

		menuBG.color = 0xFFea71fd;                 //1.1
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

		///so shit gets highlighted

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.scrollFactor.set();
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);


		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Game Options Menu", null);
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
				{
					FlxG.save.data.hitsoundvolume = HITVOL;
					trace(FlxG.save.data.hitsoundvolume);
					FlxG.save.data.speedamount = scrollspeed;
					trace(FlxG.save.data.speedamount);
				}

				if (!ischeating)
					{
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
					}
			

			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

			if (curSelected < 0)
				curSelected = 0;
	
			if (curSelected > 13)
				curSelected = 13;

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

			if (curSelected == 0)
				versionShit.text = "If the notes will scroll down or not.";
			if (curSelected == 1)
				versionShit.text = "If the notes should appear in the middle of the screen.";
			if (curSelected == 2)
				versionShit.text = "Wether or not you should have a health penalty for pressing keys not on a note.";
			if (curSelected == 3)
				versionShit.text = "Weather or not to use old input. (default FNF input)";
			if (curSelected == 4)
				versionShit.text = "Wether or not to allow spamming of keys with ghost tapping.";
			if (curSelected == 5)
				versionShit.text = "Wether or not the reset button (R) should be on.";
			if (curSelected == 6)
				versionShit.text = "Should there be a 'ready', 'set', 'go!' counter after unpauseing.";
			if (curSelected == 7)
				versionShit.text = "Wether or not to play the current song again after it ends.";
			if (curSelected == 8)
				versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
			if (curSelected == 9)
				versionShit.text = "Wether or not to enable an editable scroll speed. scroll speed: " + truncateFloat(scrollspeed, 2) + " (Left, Right)";
			if (curSelected == 10)
				versionShit.text = "If a CPU should play the game for you.";
			if (curSelected == 11)
				versionShit.text = "Wether or not to play miss sounds.";
			if (curSelected == 12)
				versionShit.text = "Wether or not to instantly respawn after death.";
			if (curSelected == 13)
				versionShit.text = "Edit Your note timing offset.";


            #if debug
			if (FlxG.keys.justPressed.I)
				{
					Settings.enablebotplay = false;
					trace('DISABLED BOTPLAY');
				}
			#end

			if (FlxG.keys.justPressed.G && curSelected == 8)
				{
				versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
				if (!ghosttappinghitsoundsenabled)
					{
						ghosttappinghitsoundsenabled = true;
						FlxG.save.data.ghosttappinghitsoundsenabled = true;
						trace('ghost tapping hitsounds enabled: ' + ghosttappinghitsoundsenabled);
						trace('ghost tapping hitsounds save data enabled: ' + FlxG.save.data.ghosttappinghitsoundsenabled);
					}
					else if (ghosttappinghitsoundsenabled)
						{
							ghosttappinghitsoundsenabled = false;
							FlxG.save.data.ghosttappinghitsoundsenabled = false;
							trace('ghost tapping hitsounds enabled: ' + ghosttappinghitsoundsenabled);
							trace('ghost tapping hitsounds save data enabled: ' + FlxG.save.data.ghosttappinghitsoundsenabled);
						}
				}


			if (controls.RIGHT_R && curSelected == 8)
				{
					HITVOL += 0.1;
					FlxG.save.data.hitsoundvolume = HITVOL;
					trace(HITVOL);
					versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
				}
	
				if (controls.LEFT_R && curSelected == 8)
					{
						HITVOL -= 0.1;
						trace(HITVOL);
						FlxG.save.data.hitsoundvolume = HITVOL;
						versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
					}

					if (controls.RIGHT_R && curSelected == 9)
						{
							scrollspeed += 0.1;
							FlxG.save.data.speedamount = scrollspeed;
							trace(scrollspeed);
							versionShit.text = "Wether or not to enable an editable scroll speed. scroll speed: " + truncateFloat(scrollspeed, 2) + " (Left, Right)";
						}
			
						if (controls.LEFT_R && curSelected == 9)
							{
								scrollspeed -= 0.1;
								trace(scrollspeed);
								FlxG.save.data.speedamount = scrollspeed;
								versionShit.text = "Wether or not to enable an editable scroll speed. scroll speed: " + truncateFloat(scrollspeed, 2) + " (Left, Right)";
							}
		
			

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.y += 102;
			        	ctrl.x += 50;
						ctrl.targetY = curSelected - 0;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 1:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.middlescroll ? 'middlescroll on' : 'middlescroll off'), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 2:
						grpControls.remove(grpControls.members[curSelected]);
						/// ok but fr why it default to no ghost tappin bruh
						FlxG.save.data.ghosttapping = !FlxG.save.data.ghosttapping;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.ghosttapping ? "Ghost Tapping" : "No Ghost Tapping"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 3:
						grpControls.remove(grpControls.members[curSelected]);
						/// ok but fr why it default to no ghost tappin bruh
						FlxG.save.data.oldinput = !FlxG.save.data.oldinput;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.oldinput ? "old input on" : "old input off"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 4:
						grpControls.remove(grpControls.members[curSelected]);
						/// ok but fr why it default to no ghost tappin bruh
						FlxG.save.data.antimash = !FlxG.save.data.antimash;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.antimash ? "anti mash ON" : "anti mash OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 4;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					 case 5:
					   grpControls.remove(grpControls.members[curSelected]);
					   FlxG.save.data.reset = !FlxG.save.data.reset;
					   var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.reset ? "RESET BUTTON ON" : "RESET BUTTON OFF"), true, false);
					   ctrl.y += 102;
					   ctrl.x += 50;
					   ctrl.targetY = curSelected - 5;
					   grpControls.add(ctrl);
					   FlxG.sound.play(Paths.sound('scrollMenu'));
					 case 6:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.pausecount = !FlxG.save.data.pausecount;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.pausecount ? "pause counter on" : "pause counter off"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 6;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					 case 7:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.repeat = !FlxG.save.data.repeat;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.repeat ? "loop current song on" : "loop current song off"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 7;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 8:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.hitsounds = !FlxG.save.data.hitsounds;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.hitsounds ? "hitsounds on" : "hitsounds off"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 8;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 9:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.songspeed = !FlxG.save.data.songspeed;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.songspeed ? "SET SCROLL SPEED ON" : "SET SCROLL SPEED OFF"), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 9;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 10:
						if (Settings.enablebotplay && !ischeating)
							{
								grpControls.remove(grpControls.members[curSelected]);
								FlxG.save.data.botplay = !FlxG.save.data.botplay;
								var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.botplay ? 'BOTPLAY ON' : 'BOTPLAY OFF'), true, false);
						        ctrl.y += 102;
								ctrl.x += 50;
								ctrl.targetY = curSelected - 10;
						        grpControls.add(ctrl);
						        FlxG.sound.play(Paths.sound('scrollMenu'));
							}
							else
								{
									FlxG.save.data.botplay = false;
									/*bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
									bg.alpha = 0.4;
									bg.scrollFactor.set();
									add(bg);
							
									text = new FlxText(5, FlxG.height - 18, 0, "No cheating!", 12);
									text.scrollFactor.set();
									text.setFormat("VCR OSD Mono", 100, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
									text.screenCenter();
									add(text);
									ischeating = true;
									new FlxTimer().start(2.5, function(tmr:FlxTimer)
										{
											ischeating = false;
											remove(bg);
											remove(text);
											trace('reset');	
										});*/
										FlxG.sound.play(Paths.sound('denied'));
								}
					case 11:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.missnotes = !FlxG.save.data.missnotes;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.missnotes ? 'miss sounds on' : 'miss sounds off'), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 11;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 12:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.instantRespawn = !FlxG.save.data.instantRespawn;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.instantRespawn ? 'instant respawn on' : 'instant respawn off'), true, false);
						ctrl.y += 102;
						ctrl.x += 50;
						ctrl.targetY = curSelected - 12;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
						case 13:
						LoadingStateLatency.loadAndSwitchState(new LatencyState());
						Conductor.changeBPM(120);			   	
				}
			}
	}

	var isSettingControl:Bool = false;


	override function openSubState(SubState:FlxSubState)
		{	
			super.openSubState(SubState);
		}


	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}



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
