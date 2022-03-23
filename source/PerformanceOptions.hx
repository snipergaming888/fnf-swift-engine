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

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var desc:FlxText;
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
		controlsStrings = CoolUtil.coolStringFile("\nAntialiasing " + (FlxG.save.data.antialiasing ? "on" : "off") + "\noptimizations " + (FlxG.save.data.optimizations ? "on" : "off") + "\ndeprecated loading " + (FlxG.save.data.usedeprecatedloading ? "on" : "off") + "\n" + "CACHING");
		else
			controlsStrings = CoolUtil.coolStringFile("\nAntialiasing " + (FlxG.save.data.antialiasing ? "on" : "off") + "\noptimizations " + (FlxG.save.data.optimizations ? "on" : "off") + "\ndeprecated loading " + (FlxG.save.data.usedeprecatedloading ? "on" : "off"));
		
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
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					FlxG.switchState(new MenuState());
				}
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

			if (ISDESKTOP)
				{
					if (curSelected > 3)
						curSelected = 3;
				}
				else
					{
						if (curSelected > 2)
							curSelected = 2;
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

				if (curSelected == 3)
					desc.text = "Cache assets.";
				

			if (controls.ACCEPT)
			{
				
		    if (curSelected == 0)
			    {
                  remove(boyfriend);
				  add(boyfriend);
			    }
				
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
							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;
							FlxG.switchState(new CacheState());
				}
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
