package;

#if cpp
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import openfl.Lib;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import lime.utils.Assets;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;

class OptionsMenu extends MusicBeatState

{
	var selector:FlxText;
	var curSelected:Int = 1;
	var keypress:FlxSprite;
	var menuBG:FlxSprite;
	var keytext:FlxText;
	var aming:Alphabet;
	var item:Alphabet;
	var CYAN:FlxColor = 0xFF00FFFF;
	var LIME:FlxColor = 0xFF00FF00;
	var camZoom:FlxTween;
	var camFollow:FlxObject;
	var sex:Alphabet;
	var versionShit:FlxText;

	var controlsStrings:Array<String> = [];
	var controlLabel:Alphabet;
	private var grpControls:FlxTypedGroup<Alphabet>;
	private var grpControlsnew:FlxTypedGroup<Alphabet>;
	private var grpControlsnew2:FlxTypedGroup<Alphabet>;
	private var grpControlsnew3:FlxTypedGroup<Alphabet>;
	private var grpControlsnew4:FlxTypedGroup<Alphabet>;
	private var keyalphabet:FlxTypedGroup<Alphabet>;
	public static var gameVer:String = "0.2.7.1";
	public static var sniperengineversion:String = "0.1";
	var descBG:FlxSprite;
	/// be prepared for some horrable code
	/// i had no idea how to remove alpabets from groups so uhhhh
	override function create()
	{
		trace('default selected: ' + curSelected);
		curSelected = 0;
		///should fix zero bug
		trace('UR BINDS ARE:');
        trace('${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}');

		///controlsStrings = CoolUtil.coolTextFile(Paths.txt('controlsmenu'));
		controlsStrings = CoolUtil.coolStringFile(FlxG.save.data.leftBind + "\n" + FlxG.save.data.downBind + "\n" + FlxG.save.data.upBind + "\n" + FlxG.save.data.rightBind + "\n" + "reset-all" );

		
		trace(controlsStrings);
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		else
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = 0xFFea71fd;
		menuBG.scrollFactor.set();
		menuBG.x -= 30;	
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		grpControlsnew = new FlxTypedGroup<Alphabet>();
		grpControlsnew2 = new FlxTypedGroup<Alphabet>();
		grpControlsnew3 = new FlxTypedGroup<Alphabet>();
		grpControlsnew4 = new FlxTypedGroup<Alphabet>();
		keyalphabet = new FlxTypedGroup<Alphabet>();
		add(grpControls);
		add(grpControlsnew);
		add(grpControlsnew2);
		add(grpControlsnew3);
		add(grpControlsnew4);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		for (i in 0...controlsStrings.length)
			{                                  //100
			var ctrl:Alphabet = new Alphabet(0, (80 * i) + 60, controlsStrings[i], true, false);
		    ctrl.ID = i;
			ctrl.y += 102;
			ctrl.x += 50;
		    grpControls.add(ctrl);
			}//70

		TitleState.keyCheck();
		trace('CHECKING BINDS');

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.scrollFactor.set();
		descBG.screenCenter(X);
		add(descBG);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Press enter on the key you want to rebind then press the key you want to rebind it to.", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var aming:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('press-any-key'), true, false);
								aming.isMenuItem = false;
								aming.targetY = curSelected - 0;
								aming.screenCenter(X);
								aming.scrollFactor.set();
								keyalphabet.add(aming);
		if(keytextbool)
			{
			}
			else
				{
				}
				
				trace("ur binds are not zero, good");
		///so shit gets highlighted

		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Rebinding Keys", null);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (isSettingControlup)
				{
					add(keyalphabet);		
					waitingInputup();
				}
				else if (isSettingControldown)
					{
						add(keyalphabet);		
						waitingInputdown();
					}
					 else if (isSettingControlleft)
						{
							add(keyalphabet);
							waitingInputleft();
						}
						else if (isSettingControlright)
							{
								add(keyalphabet);
								waitingInputright();
							}
			{
				if (controls.BACK)
					{
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
						FlxG.switchState(new MenuState());
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


				if (abletochange)
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
			

			if (curSelected < 0)
				curSelected = 0;
	
			if (curSelected > 4)
				curSelected = 4;

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

				if (controls.BACK)
					{
						PlayerSettings.player1.controls.loadKeyBinds();
						trace('SAVED BINDS');
						FlxG.save.data.controls = true;
						FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
					}

					
			}
			if (controls.ACCEPT)
				{
					switch(curSelected)
					{
						case 0:
							isSettingControlleft = true;
							abletochange = false;
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						case 1:
							isSettingControldown = true;
							abletochange = false;
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						case 2:
							isSettingControlup = true;
							abletochange = false;
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						case 3:
							isSettingControlright = true;
							abletochange = false;
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						case 4:
							///controls.setKeyboardScheme(Solo);
							TitleState.resetBinds();
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;
							FlxG.resetState();
					}
				}
			
	}

	var isSettingControlup:Bool = false;
	var isSettingControldown:Bool = false;
	var isSettingControlleft:Bool = false;
	var isSettingControlright:Bool = false;
	var keytextbool:Bool = false;
	var abletochange:Bool = true;
	var isnewmenu:Bool = false;
	var isnewmenu2:Bool = false;
	var isnewmenu3:Bool = false;
	var isnewmenu4:Bool = false;



		function regenMenu():Void
			{
				for (i in 0...grpControls.members.length)
					grpControls.remove(grpControls.members[0], true);
		
				for (i in 0...controlsStrings.length)
				{
					var ctrl:Alphabet = new Alphabet(0, (80 * i) + 60, controlsStrings[i], true, false);
					ctrl.ID = i;
					ctrl.y += 102;
					ctrl.x += 50;
					grpControls.add(ctrl);	
				}
			}





	function waitingInputup():Void
		{
			///THIS KEYBINDSTATE TOOK ME LIKE 2 FUCKING DAYS TO MAKE
			///FUCKKKKKKK
			if (FlxG.keys.justPressed.ANY || FlxG.keys.justPressed.Z)
			{
				PlayerSettings.player1.controls.replaceBinding(Control.UP, Keys, FlxG.keys.getIsDown()[0].ID, null);
				FlxG.save.data.upBind = FlxG.keys.getIsDown()[0].ID.toString();
				trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
				trace(FlxG.save.data.upBind + " | SET KEY");
				isSettingControlup = false;
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{
						abletochange = true;
						remove(keyalphabet);
						keyalphabet.remove(aming);
						remove(aming);
						controlsStrings = [FlxG.save.data.leftBind, FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, 'reset-all'];
						regenMenu();
						#if cpp
						// Updating Discord Rich Presence
						DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
						FlxG.sound.play(Paths.sound('scrollMenu'));
						#end
					});
			}
			// PlayerSettings.player1.controls.replaceBinding(Control)
		}

		function waitingInputdown():Void
			{
				if (FlxG.keys.justPressed.ANY || FlxG.keys.justPressed.Z)
				{
					PlayerSettings.player1.controls.replaceBinding(Control.DOWN, Keys, FlxG.keys.getIsDown()[0].ID, null);
					FlxG.save.data.downBind = FlxG.keys.getIsDown()[0].ID.toString();
					trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
					trace(FlxG.save.data.downBind + " | SET KEY");
					isSettingControldown = false;
					new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							abletochange = true;
							remove(keyalphabet);
							keyalphabet.remove(aming);
							remove(aming);
							controlsStrings = [FlxG.save.data.leftBind, FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, 'reset-all'];
							regenMenu();
							#if cpp
							// Updating Discord Rich Presence
							DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
							FlxG.sound.play(Paths.sound('scrollMenu'));
							#end
						});
				}
				// PlayerSettings.player1.controls.replaceBinding(Control)
			}


			function waitingInputleft():Void
				{
					if (FlxG.keys.justPressed.ANY || FlxG.keys.justPressed.Z)
					{
						PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
						FlxG.save.data.leftBind = FlxG.keys.getIsDown()[0].ID.toString();
						trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
					    trace(FlxG.save.data.leftBind + " | SET KEY");
						isSettingControlleft = false;
						new FlxTimer().start(0.01, function(tmr:FlxTimer)
							{
								abletochange = true;
								remove(keyalphabet);
								keyalphabet.remove(aming);
								remove(aming);
								controlsStrings = [FlxG.save.data.leftBind, FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, 'reset-all'];
								regenMenu();
								#if cpp
								// Updating Discord Rich Presence
								DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
								FlxG.sound.play(Paths.sound('scrollMenu'));
								#end
							});
					}
					// PlayerSettings.player1.controls.replaceBinding(Control)
				}


				function waitingInputright():Void
					{
						if (FlxG.keys.justPressed.ANY || FlxG.keys.justPressed.Z)
						{
							PlayerSettings.player1.controls.replaceBinding(Control.RIGHT, Keys, FlxG.keys.getIsDown()[0].ID, null);
							FlxG.save.data.rightBind = FlxG.keys.getIsDown()[0].ID.toString();
							trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
					        trace(FlxG.save.data.rightBind + " | SET KEY");
							isSettingControlright = false;
							new FlxTimer().start(0.01, function(tmr:FlxTimer)
								{
									abletochange = true;
									remove(keyalphabet);
									keyalphabet.remove(aming);
									remove(aming);
									controlsStrings = [FlxG.save.data.leftBind, FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, 'reset-all'];
									regenMenu();
									#if cpp
									// Updating Discord Rich Presence
									DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
									FlxG.sound.play(Paths.sound('scrollMenu'));
									#end
								});
						}
						// PlayerSettings.player1.controls.replaceBinding(Control)
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
