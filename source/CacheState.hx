package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import openfl.Lib;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
class CacheState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	var camFollow:FlxObject;

	var controlsStrings:Array<String> = [];
	var descBG:FlxSprite;
	var menuBG:FlxSprite;
	var flashing:Bool = false;

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		menuBG.scrollFactor.set();
		menuBG.x -= 30;	
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.imagecache ? 'IMAGE CACHING ON' : 'IMAGE CACHING OFF') + "\n" + (FlxG.save.data.songcache ? 'SONG CACHING ON' : 'SONG CACHING OFF') + "\n" + (FlxG.save.data.soundcache ? 'SOUND CACHING ON' : 'SOUND CACHING OFF') + "\n" + (FlxG.save.data.musiccache ? 'MUSIC CACHING ON' : 'MUSIC CACHING OFF'));
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

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
		descBG.screenCenter(X);
		descBG.scrollFactor.set();
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "WARNING: CACHING WILL USE LARGE AMOUNTS OF SYSTEM RAM AND IS BETA! IT MAY NOT WORK PROPERLY!");
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		

		super.create();
	}

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				{
					FlxG.switchState(new PerformanceOptions());
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
					}
			

			if (curSelected < 0)
				curSelected = 0;

				
			if (curSelected > 3)
				curSelected = 3;
				
	

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

			if (controls.ACCEPT)
			{
				                flashing = true;
								FlxG.sound.play(Paths.sound('confirmMenu'));
								FlxFlicker.flicker(grpControls.members[curSelected], 1, 0.06, true, false, function(flick:FlxFlicker)
									{
										flashing = false;
										//FlxTransitionableState.skipNextTransIn = true;
										//FlxTransitionableState.skipNextTransOut = true;
										switch(curSelected)
										{
											case 0:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.imagecache = !FlxG.save.data.imagecache;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.imagecache ? 'IMAGE CACHING ON' : 'IMAGE CACHING OFF'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 0;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 1:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.songcache = !FlxG.save.data.songcache;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.songcache ? 'SONG CACHING ON' : 'SONG CACHING OFF'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 1;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 2:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.soundcache = !FlxG.save.data.soundcache;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.soundcache ? 'SOUND CACHING ON' : 'SOUND CACHING OFF'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 1;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));
											case 3:
												grpControls.remove(grpControls.members[curSelected]);
												FlxG.save.data.musiccache = !FlxG.save.data.musiccache;
												var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.musiccache ? 'MUSIC CACHING ON' : 'MUSIC CACHING OFF'), true, false);
												ctrl.y += 102;
												ctrl.x += 50;
												ctrl.targetY = curSelected - 1;
												grpControls.add(ctrl);
												FlxG.sound.play(Paths.sound('scrollMenu'));	   	
										}
										//flick.destroy();
									});	
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
