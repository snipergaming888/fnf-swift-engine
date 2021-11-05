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

class ApperanceOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD") + "\n" + (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF") + "\n" + (FlxG.save.data.hittimings ? "MS Timing text ON" : "MS Timing text OFF")+ "\n" + (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION off")+ "\n" + (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off")+ "\n" + (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF") + "\n" + (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF")  + "\n" + (FlxG.save.data.minscore ? "minimalize score info ON" : "minimalize score info OFF") + "\n" + (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF"));
		
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

		versionShit = new FlxText(5, FlxG.height - 18, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeSelection();
		///so shit gets highlighted
		
		super.create();
	}

	override function update(elapsed:Float)
	{

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

			if (curSelected == 0)
				versionShit.text = "Hide all text and the healthbar.";

			if (curSelected == 1)
				versionShit.text = "Hide all UI, strumline, and notes.";

			if (curSelected == 2)
				versionShit.text = "Show in miliseconds how long it took for you to hit a note.";

			if (curSelected == 3)
				versionShit.text = "Show what position in the song you are.";

			if (curSelected == 4)
				versionShit.text = "Wether or not to have note trails transparent or not transparent.";

			if (curSelected == 5)
				versionShit.text = "Wether or not to have the CPU strums light up.";

			if (curSelected == 6)
				versionShit.text = "Wether or not to have the player strums light up.";

			if (curSelected == 7)
				versionShit.text = "Wether or not to have the camera zoom in on beat.";

			if (curSelected == 8)
				versionShit.text = "Wether or not to show engine watermarks (will not remove botplay text).";

			if (curSelected == 9)
				versionShit.text = "Wether or not to show only score info.";

			if (curSelected == 10)
				versionShit.text = "Toggle the FPS counter on and off. (applies after restart)";


			if (controls.ACCEPT)
			{
				if (curSelected != 4)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.hideHUD = !FlxG.save.data.hideHUD;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
				    case 1:
						grpControls.remove(grpControls.members[curSelected]);
					    FlxG.save.data.cinematic = !FlxG.save.data.cinematic;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					 case 2:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.hittimings = !FlxG.save.data.hittimings;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.hittimings ? "MS Timing text ON" : "MS Timing text OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					 case 3:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
                     case 4:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.transparency = !FlxG.save.data.transparency;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 5:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.strumlights = !FlxG.save.data.strumlights;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 5;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
							grpControls.add(ctrl);
					case 6:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.playerstrumlights = !FlxG.save.data.playerstrumlights;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 6;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 7:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.camzooming = !FlxG.save.data.camzooming;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 7;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 8:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.watermarks = !FlxG.save.data.watermarks;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 8;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 9:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.minscore = !FlxG.save.data.minscore;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.minscore ? "minimalize score info ON" : "minimalize score info OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 9;
						#if windows
						ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 10:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.fps = !FlxG.save.data.fps;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 10;
						#if windows
						ctrl.color = FlxColor.YELLOW;
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
				if (curSelected != 5)
					{
						#if windows
						///if debug is current selection
						/// ITS BACKWARDS!?!?!?!?! WHAT THE FUCK?
						item.color = FlxColor.YELLOW;
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
