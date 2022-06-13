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
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxStringUtil;
import openfl.Lib;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import openfl.display.Stage;
import lime.ui.Window;
import openfl.Lib;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;

using StringTools;

class PerformanceOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	private var boyfriend:Boyfriend;
	var ISDESKTOP:Bool = false;
	var descBG:FlxSprite;
	var menuBG:FlxSprite;
	var camFollow:FlxObject;
	var scaleMode:ScaleMode;
	var flashing:Bool = false;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var desc:FlxText;
	var scaleModes:Array<ScaleMode> = [RATIO_DEFAULT, RATIO_FILL_SCREEN, FIXED, RELATIVE, FILL];
	var scaleModeIndex:Int = 0;
	var width:Int = 1280;
	var height:Int = 720;
	override function create()
	{
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		menuBG.scrollFactor.set();
		menuBG.x -= 30;	
		#if cpp
		ISDESKTOP = true;
		#end
		if (ISDESKTOP)
		controlsStrings = CoolUtil.coolStringFile("\nAntialiasing " + (FlxG.save.data.antialiasing ? "on" : "off") + "\noptimizations " + (FlxG.save.data.optimizations ? "on" : "off") + "\ndeprecated loading " + (FlxG.save.data.usedeprecatedloading ? "on" : "off") + "\n" + "CACHING" + "\n" + 'Set ScaleMode' + "\n" + 'Set Windowed Resolution' + "\npersistent caching " + (FlxG.save.data.graphicpersist ? "on" : "off"));
		else
			controlsStrings = CoolUtil.coolStringFile("\nAntialiasing " + (FlxG.save.data.antialiasing ? "on" : "off") + "\noptimizations " + (FlxG.save.data.optimizations ? "on" : "off") + "\ndeprecated loading " + (FlxG.save.data.usedeprecatedloading ? "on" : "off") + "\n" + 'Set ScaleMode' + "\n" + 'Set Windowed Resolution' + "\npersistent caching " + (FlxG.save.data.graphicpersist ? "on" : "off"));
		
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

		
         
		if (FlxG.save.data.antialiasing)
			{
				versionShit = new FlxText(1000, 200, "ANTIALIASING ON", 12);
				versionShit.scrollFactor.set();
				versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				add(versionShit);
			}
			else
				{
					versionShit = new FlxText(1000, 200, "ANTIALIASING OFF", 12);
					versionShit.scrollFactor.set();
					versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					add(versionShit);
				}

				desc = new FlxText(5, FlxG.height - 18, 0, "", 12);
				desc.scrollFactor.set();
				desc.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				add(desc);
				

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
        
		boyfriend = new Boyfriend(850 ,300 ,"bf-opt");
		if (FlxG.save.data.antialiasing)
		 {
			 boyfriend.antialiasing = true;
		 }
		 else
			 {
				 boyfriend.antialiasing = false;	
			 }
			 boyfriend.visible = false;
			 boyfriend.scrollFactor.set();
			 add(boyfriend);

			 #if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Peformance Options Menu", null);
		#end
			
		super.create();
	}

	override function update(elapsed:Float)
	{
       
		if (curSelected == 0)
			{
				boyfriend.visible = true;
				versionShit.visible = true;
			}
			else
				{
                    boyfriend.visible = false;
					versionShit.visible = false;
				}

				if (FlxG.save.data.antialiasing)
					{
						boyfriend.antialiasing = true;
						versionShit.text = "ANTIALIASING ON";
						versionShit.antialiasing = true;
					}
					else
						{
							boyfriend.antialiasing = false;
							versionShit.text = "ANTIALIASING OFF";
							versionShit.antialiasing = false;	
						}

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				{
					FlxG.switchState(new MenuState());
				}
				if (controls.UP_P && !flashing)
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

							if (curSelected == 4)
								desc.text = "Set the Scaling mode. Mode: " + scaleMode;
							if (curSelected == 3 && !ISDESKTOP)
								desc.text = "Set the Scaling mode. Mode: " + scaleMode;
					}
		
				if (controls.DOWN_P && !flashing)
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

							if (curSelected == 4)
								desc.text = "Set the Scaling mode. Mode: " + scaleMode;
							if (curSelected == 3 && !ISDESKTOP)
								desc.text = "Set the Scaling mode. Mode: " + scaleMode;
					}
			

			if (curSelected < 0)
				curSelected = 0;

			if (ISDESKTOP)
				{
					if (curSelected > 6)
						curSelected = 6;
				}
				else
					{
						if (curSelected > 5)
							curSelected = 5;
					}
	

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
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
			
			if (FlxG.keys.pressed.K)
				{
					boyfriend.playAnim('singUP');
				}
			if (FlxG.keys.pressed.S)
				{
					boyfriend.playAnim('singDOWN');
				}
			if (FlxG.keys.pressed.A)
				{
					boyfriend.playAnim('singLEFT');
				}
			if (FlxG.keys.pressed.L)
				{
					boyfriend.playAnim('singRIGHT');
				}

				if (curSelected == 0)
					desc.text = "Wether or not to smooth out pixels at the cost of performance. off = better performance.";

				if (curSelected == 1)
					desc.text = "Wether or not to use compressed assets and disable some background animations.";

				if (curSelected == 2)
					desc.text = "Use the deprecated way to load things in-game. load times are slower than using the new loading scheme.";

				if (curSelected == 3 && ISDESKTOP)
					desc.text = "Cache assets.";


				if (curSelected == 5 && ISDESKTOP)
					desc.text = "Set the resolution of the game." + " Width: " + width + " height: " + height + " (Left, Right , shift to go faster, enter to confirm, Hold CTRL for height adjustment)";

				if (curSelected == 4 && !ISDESKTOP)
					desc.text = "Set the resolution of the game." + " Width: " + width + " height: " + height + " (Left, Right , shift to go faster, enter to confirm, Hold CTRL for height adjustment)";

				if (curSelected == 6 && ISDESKTOP)
					desc.text = "Graphic caching persist through each state.";

				if (curSelected == 5 && !ISDESKTOP)
					desc.text = "Graphic caching persist through each state.";

				if (ISDESKTOP)
					{
						if (curSelected == 5 && !FlxG.keys.pressed.CONTROL)
							{
								var multiply:Int = 1;
			
								if (FlxG.keys.pressed.SHIFT && width > 10)
									multiply = 10;
						
								if (FlxG.keys.justPressed.RIGHT && width > 0)
									{
											{
												width += 1 * multiply;
											}
									}
								if (FlxG.keys.justPressed.LEFT && width > 0)
									{
											{
												width -= 1 * multiply;
											}
									}
						
								if (FlxG.keys.justPressed.SPACE)
								{
									width = 1280;
									height = 720;
								}
							}
		
					if (curSelected == 5 && FlxG.keys.pressed.CONTROL)
							{
								var multiply:Int = 1;
			
								if (FlxG.keys.pressed.SHIFT && height > 10)
									multiply = 10;
						
								if (FlxG.keys.justPressed.RIGHT && height > 0)
									{
											{
												height += 1 * multiply;
											}
									}
								if (FlxG.keys.justPressed.LEFT && height > 0)
									{
											{
												height -= 1 * multiply;
											}
									}
						
								if (FlxG.keys.justPressed.SPACE)
								{
									width = 1280;
									height = 720;
								}
							}		
					}
					else
						{
							if (curSelected == 4 && !FlxG.keys.pressed.CONTROL && !ISDESKTOP)
								{
									var multiply:Int = 1;
				
									if (FlxG.keys.pressed.SHIFT && width > 10)
										multiply = 10;
							
									if (FlxG.keys.justPressed.RIGHT && width > 0)
										{
												{
													width += 1 * multiply;
												}
										}
									if (FlxG.keys.justPressed.LEFT && width > 0)
										{
												{
													width -= 1 * multiply;
												}
										}
							
									if (FlxG.keys.justPressed.SPACE)
									{
										width = 1280;
										height = 720;
									}
								}
			
						if (curSelected == 4 && FlxG.keys.pressed.CONTROL && !ISDESKTOP)
								{
									var multiply:Int = 1;
				
									if (FlxG.keys.pressed.SHIFT && height > 10)
										multiply = 10;
							
									if (FlxG.keys.justPressed.RIGHT && height > 0)
										{
												{
													height += 1 * multiply;
												}
										}
									if (FlxG.keys.justPressed.LEFT && height > 0)
										{
												{
													height -= 1 * multiply;
												}
										}
							
									if (FlxG.keys.justPressed.SPACE)
									{
										width = 1280;
										height = 720;
									}
								}	
						}
				

			if (controls.ACCEPT)
			{
				
		    if (curSelected == 0)
			    {
                  remove(boyfriend);
				  add(boyfriend);
			    }
				                flashing = true;
								FlxG.sound.play(Paths.sound('confirmMenu'));
								FlxFlicker.flicker(grpControls.members[curSelected], 1, 0.06, false, true, function(flick:FlxFlicker)
									{
										flashing = false;
										//FlxTransitionableState.skipNextTransIn = true;
										//FlxTransitionableState.skipNextTransOut = true;
										if (ISDESKTOP)
											{
												switch(curSelected)
												{			
															case 0:
																grpControls.remove(grpControls.members[curSelected]);
																FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
																var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "Antialiasing " + (FlxG.save.data.antialiasing ? "on" : "off"), true, false);
																ctrl.y += 102;
																ctrl.x += 50;
																ctrl.targetY = curSelected - 0;
																grpControls.add(ctrl);
																FlxG.sound.play(Paths.sound('scrollMenu'));
																
															case 1:
																grpControls.remove(grpControls.members[curSelected]);
																FlxG.save.data.optimizations = !FlxG.save.data.optimizations;
																var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "optimizations " + (FlxG.save.data.optimizations ? "on" : "off"), true, false);
																ctrl.y += 102;
																ctrl.x += 50;
																ctrl.targetY = curSelected - 1;
																grpControls.add(ctrl);
																FlxG.sound.play(Paths.sound('scrollMenu'));
															case 2:
																grpControls.remove(grpControls.members[curSelected]);
																FlxG.save.data.usedeprecatedloading = !FlxG.save.data.usedeprecatedloading;
																var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "deprecated loading " + (FlxG.save.data.usedeprecatedloading ? "on" : "off"), true, false);
																ctrl.y += 102;
																ctrl.x += 50;
																ctrl.targetY = curSelected - 2;
																grpControls.add(ctrl);
																FlxG.sound.play(Paths.sound('scrollMenu'));
															case 3:
																FlxG.switchState(new CacheState());
															case 4:
																grpControls.remove(grpControls.members[curSelected]);
																var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "Set ScaleMode", true, false);
																ctrl.y += 102;
																ctrl.x += 50;
																ctrl.targetY = curSelected - 4;
																grpControls.add(ctrl);
																FlxG.sound.play(Paths.sound('scrollMenu'));
																scaleModeIndex = FlxMath.wrap(scaleModeIndex + 1, 0, scaleModes.length - 1);
																setScaleMode(scaleModes[scaleModeIndex]);
															case 5:
																grpControls.remove(grpControls.members[curSelected]);
																var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "Set Windowed Resolution", true, false);
																ctrl.y += 102;
																ctrl.x += 50;
																ctrl.targetY = curSelected - 5;
																grpControls.add(ctrl);
																FlxG.sound.play(Paths.sound('scrollMenu'));
																Lib.application.window.resize(width, height);
															case 6:
																grpControls.remove(grpControls.members[curSelected]);
																FlxG.save.data.graphicpersist = !FlxG.save.data.graphicpersist;
																var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "persistent caching " + (FlxG.save.data.graphicpersist ? "on" : "off"), true, false);
																ctrl.y += 102;
																ctrl.x += 50;
																ctrl.targetY = curSelected - 6;
																grpControls.add(ctrl);
																FlxG.sound.play(Paths.sound('scrollMenu'));	
																FlxGraphic.defaultPersist = FlxG.save.data.graphicpersist;						
											}
										}
										else
											{
												switch(curSelected)
												{
													case 0:
														grpControls.remove(grpControls.members[curSelected]);
														FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
														var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "Antialiasing " + (FlxG.save.data.antialiasing ? "on" : "off"), true, false);
														ctrl.y += 102;
														ctrl.x += 50;
														ctrl.targetY = curSelected - 0;
														grpControls.add(ctrl);
														FlxG.sound.play(Paths.sound('scrollMenu'));
														
													case 1:
														grpControls.remove(grpControls.members[curSelected]);
														FlxG.save.data.optimizations = !FlxG.save.data.optimizations;
														var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "optimizations " + (FlxG.save.data.optimizations ? "on" : "off"), true, false);
														ctrl.y += 102;
														ctrl.x += 50;
														ctrl.targetY = curSelected - 1;
														grpControls.add(ctrl);
														FlxG.sound.play(Paths.sound('scrollMenu'));
													case 2:
														grpControls.remove(grpControls.members[curSelected]);
														FlxG.save.data.usedeprecatedloading = !FlxG.save.data.usedeprecatedloading;
														var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "deprecated loading " + (FlxG.save.data.usedeprecatedloading ? "on" : "off"), true, false);
														ctrl.y += 102;
														ctrl.x += 50;
														ctrl.targetY = curSelected - 2;
														grpControls.add(ctrl);
														FlxG.sound.play(Paths.sound('scrollMenu'));
													case 3:
														grpControls.remove(grpControls.members[curSelected]);
														var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "Set ScaleMode", true, false);
														ctrl.y += 102;
														ctrl.x += 50;
														ctrl.targetY = curSelected - 3;
														grpControls.add(ctrl);
														FlxG.sound.play(Paths.sound('scrollMenu'));
														scaleModeIndex = FlxMath.wrap(scaleModeIndex + 1, 0, scaleModes.length - 1);
														setScaleMode(scaleModes[scaleModeIndex]);
													case 4:
														grpControls.remove(grpControls.members[curSelected]);
														var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "Set Windowed Resolution", true, false);
														ctrl.y += 102;
														ctrl.x += 50;
														ctrl.targetY = curSelected - 4;
														grpControls.add(ctrl);
														FlxG.sound.play(Paths.sound('scrollMenu'));
														Lib.application.window.resize(width, height);
													case 5:
														grpControls.remove(grpControls.members[curSelected]);
														FlxG.save.data.graphicpersist = !FlxG.save.data.graphicpersist;
														var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, "persistent caching " + (FlxG.save.data.graphicpersist ? "on" : "off"), true, false);
														ctrl.y += 102;
														ctrl.x += 50;
														ctrl.targetY = curSelected - 5;
														grpControls.add(ctrl);
														FlxG.sound.play(Paths.sound('scrollMenu'));
														FlxGraphic.defaultPersist = FlxG.save.data.graphicpersist;								
												}
						
											}
											//flick.destroy();
									});	
			}
	}

	var isSettingControl:Bool = false;


	override function beatHit()
		{
			super.beatHit();

			
			if (curSelected == 0)
				{
					if (curBeat % 2 == 0)
						{
									{
										boyfriend.playAnim('idle');
										trace('dance');
									}									
						}	
				}

			if (accepted)
				{
					bopOnBeat();
					///iconBop();
					trace(curBeat);
				}
		}

		function setScaleMode(scaleMode:ScaleMode)
			{
				if (curSelected == 4 && ISDESKTOP)
					desc.text = "Set the Scaling mode. Mode: " + scaleMode;
				if (curSelected == 3 && !ISDESKTOP)
					desc.text = "Set the Scaling mode. Mode: " + scaleMode;

				FlxG.scaleMode = switch (scaleMode)
				{
					case ScaleMode.RATIO_DEFAULT:
						new RatioScaleMode();
		
					case ScaleMode.RATIO_FILL_SCREEN:
						new RatioScaleMode(true);
		
					case ScaleMode.FIXED:
						new FixedScaleMode();
		
					case ScaleMode.RELATIVE:
						new RelativeScaleMode(0.75, 0.75);
		
					case ScaleMode.FILL:
						new FillScaleMode();
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
								 if (FlxG.save.data.camzooming)
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

@:enum
abstract ScaleMode(String) to String
{
	var RATIO_DEFAULT = "ratio";
	var RATIO_FILL_SCREEN = "ratio screenfill";
	var FIXED = "fixed";
	var RELATIVE = "relative 75%";
	var FILL = "fill";
}
