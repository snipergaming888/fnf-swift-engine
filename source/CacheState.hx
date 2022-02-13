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
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;

class CacheState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;

	var controlsStrings:Array<String> = [];
	var descBG:FlxSprite;

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.imagecache ? 'IMAGE CACHING ON' : 'IMAGE CACHING OFF') + "\n" + (FlxG.save.data.songcache ? 'SONG CACHING ON' : 'SONG CACHING OFF') + "\n" + (FlxG.save.data.soundcache ? 'SOUND CACHING ON' : 'SOUND CACHING OFF') + "\n" + (FlxG.save.data.musiccache ? 'MUSIC CACHING ON' : 'MUSIC CACHING OFF'));
		
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
				controlLabel.screenCenter(X);
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		changeSelection();
		///so shit gets highlighted

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.screenCenter(X);
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "WARNING: CHACHING WILL USE LARGE AMOUNTS OF RAM! ENABLE AT YOUR OWN RISK!");
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
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					FlxG.switchState(new PerformanceOptions());
				}
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

			for (item in grpControls.members)
				{
					item.screenCenter(X);
				}

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.imagecache = !FlxG.save.data.imagecache;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.imagecache ? 'IMAGE CACHING ON' : 'IMAGE CACHING OFF'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						#if windows
						//ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 1:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.songcache = !FlxG.save.data.songcache;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.songcache ? 'SONG CACHING ON' : 'SONG CACHING OFF'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						#if windows
						//ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 2:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.soundcache = !FlxG.save.data.soundcache;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.soundcache ? 'SOUND CACHING ON' : 'SOUND CACHING OFF'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						#if windows
						//ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 3:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.musiccache = !FlxG.save.data.musiccache;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.musiccache ? 'MUSIC CACHING ON' : 'MUSIC CACHING OFF'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						#if windows
						//ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);						   	
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
			item.screenCenter(X);

			item.alpha = 0.6;
			#if windows
			//item.color = FlxColor.WHITE;
            #end
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				#if windows
				//item.color = FlxColor.YELLOW;
				#end
				if (curSelected != 3)
					{
						#if windows
						///if debug is current selection
						/// ITS BACKWARDS!?!?!?!?! WHAT THE FUCK?
						//item.color = FlxColor.YELLOW;
						#end
					}
				
				// item.setGraphicSize(Std.int(item.width));
			}
		}
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
