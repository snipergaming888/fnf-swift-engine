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
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import openfl.Lib;
import flixel.FlxObject;
import flixel.tweens.FlxEase;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;

class MiscOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	var popup:Bool = false;
	var aming:Alphabet;
	var ok:Alphabet;
	var curframefloat:Float = 1;
	var menuBG:FlxSprite;
	var camFollow:FlxObject;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var descBG:FlxSprite;
	override function create()
	{
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		menuBG.scrollFactor.set();
		menuBG.x -= 30;	
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.freeplaysongs ? 'freeplay song previews on' : 'freeplay song previews off') +"\n" + (FlxG.save.data.discordrpc ? 'discord presence on' : 'discord presence off') +"\n" + (FlxG.save.data.disguiseaske142 ? 'KE four version txt on' : 'KE four version txt off') +"\n" + (FlxG.save.data.disguiseaske154 ? 'KE five version txt on' : 'KE five version txt off'));
		
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
			{                                  //100
			var ctrl:Alphabet = new Alphabet(0, (80 * i) + 60, controlsStrings[i], true, false);
		    ctrl.ID = i;
			ctrl.y += 102;
			ctrl.x += 50;
		    grpControls.add(ctrl);
			}//70

			camFollow = new FlxObject(0, 0, 1, 1);
		    add(camFollow);

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.screenCenter(X);
		descBG.scrollFactor.set();
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeSelection();
		///so shit gets highlighted


		var aming:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('this-setting-will-apply-on-restart'), true, false);
		aming.isMenuItem = false;
		aming.targetY = curSelected - 0;
		aming.screenCenter(X);

		var ok:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('ok'), true, false);
		ok.isMenuItem = true;
		ok.targetY = curSelected - 0;
		ok.screenCenter(X);

		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Miscellaneous Options Menu", null);
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

			if (curSelected == 0)
				versionShit.text = "Play songs in freeplay when hovering over them.";

			if (curSelected == 1)
				versionShit.text = "Disable or enable the games discord presence.";

			if (curSelected == 2)
				versionShit.text = "Enable Kade Engine 1.4.2 version text.";

			if (curSelected == 3)
				versionShit.text = "Enable Kade Engine 1.5.4 version text.";

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.freeplaysongs = !FlxG.save.data.freeplaysongs;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.freeplaysongs ? 'freeplay song previews on' : 'freeplay song previews off'), true, false);
						ctrl.y += 102;
			        	ctrl.x += 50;
						ctrl.targetY = curSelected - 0;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
					case 1:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.discordrpc = !FlxG.save.data.discordrpc;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.discordrpc ? 'discord presence on' : 'discord presence off'), true, false);
						ctrl.y += 102;
			        	ctrl.x += 50;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
						FlxG.sound.play(Paths.sound('scrollMenu'));
						#if cpp
						if (!FlxG.save.data.discordrpc)
							{
								DiscordClient.shutdown();
							}
							else
								{
									DiscordClient.initialize();
								}
						#end
					case 2:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.disguiseaske142 = !FlxG.save.data.disguiseaske142;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.disguiseaske142 ? 'KE four version txt on' : 'KE four version txt off'), true, false);
						ctrl.y += 102;
			        	ctrl.x += 50;
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
					case 3:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.disguiseaske154 = !FlxG.save.data.disguiseaske154;
						var ctrl:Alphabet = new Alphabet(0, (80 * curSelected) + 60, (FlxG.save.data.disguiseaske154 ? 'KE five version txt on' : 'KE five version txt off'), true, false);
						ctrl.y += 102;
			        	ctrl.x += 50;
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
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
		
					item.alpha = 0.6;
					// item.setGraphicSize(Std.int(item.width * 0.8));
		
					if (item.targetY == 0)
					{
						item.alpha = 1;
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

			function truncateFloat( number : Float, precision : Int): Float {
				var num = number;
				num = num * Math.pow(10, precision);
				num = Math.round( num ) / Math.pow(10, precision);
				return num;
				}

	var accepted:Bool = true;


}	



