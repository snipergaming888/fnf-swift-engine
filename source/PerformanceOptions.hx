package;

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

using StringTools;

class PerformanceOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	private var boyfriend:Boyfriend;
	var ISWINDOWS:Bool = false;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		#if windows
		ISWINDOWS = true;
		#end
		if (ISWINDOWS)
		controlsStrings = CoolUtil.coolStringFile("\nAntialiasing " + (FlxG.save.data.antialiasing ? "on" : "off") + "\noptimizations " + (FlxG.save.data.optimizations ? "on" : "off") + "\n" + "CACHING");
		else
			controlsStrings = CoolUtil.coolStringFile("\nAntialiasing " + (FlxG.save.data.antialiasing ? "on" : "off") + "\noptimizations " + (FlxG.save.data.optimizations ? "on" : "off"));
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		changeSelection();
		///so shit gets highlighted
		
         #if desktop
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
				#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
        #if desktop
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
			 add(boyfriend);
			 #end
		super.create();
	}

	override function update(elapsed:Float)
	{
        #if desktop
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
						#end

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
			#if desktop
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
				#end

			if (controls.ACCEPT)
			{
				#if desktop
		    if (curSelected == 0)
			    {
                  remove(boyfriend);
				  add(boyfriend);
			    }
				#end
				switch(curSelected)
				{
					case 0:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Antialiasing " + (FlxG.save.data.antialiasing ? "on" : "off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
						
					case 1:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.optimizations = !FlxG.save.data.optimizations;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "optimizations " + (FlxG.save.data.optimizations ? "on" : "off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
						case 2:
							FlxG.switchState(new CacheState());
				}
			}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			#if windows
			item.color = FlxColor.WHITE;
            #end
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				#if windows
				item.color = FlxColor.YELLOW;
				#end
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}


	override function beatHit()
		{
			super.beatHit();

			
			if (curSelected == 0)
				{
					#if desktop
					if (curBeat % 2 == 0)
						{
									{
										boyfriend.playAnim('idle');
										trace('dance');
									}									
						}
						#end
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
