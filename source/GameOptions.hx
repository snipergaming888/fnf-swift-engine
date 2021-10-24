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

class GameOptions extends MusicBeatState
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
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\n" + (FlxG.save.data.middlescroll ? "middlescroll on" : "middlescroll off") + "\n" + (FlxG.save.data.ghosttapping ? "Ghost Tapping" : "No Ghost Tapping") + "\n" + (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD") + "\n" + (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF") + "\n" + (FlxG.save.data.debug ? "debug MODE ON" : "debug MODE OFF") + "\n" + (FlxG.save.data.reset ? "RESET BUTTON ON" : "RESET BUTTON OFF") + "\n" + (FlxG.save.data.pausecount ? "pause counter on" : "pause counter off")+ "\n" + (FlxG.save.data.hittimings ? "MS Timing text ON" : "MS Timing text OFF")+ "\n" + (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION off")+ "\n" + (FlxG.save.data.strumlights ? "STRUM LIGHTS ON" : "STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF") + "\n" + "EDIT OFFSET");
		
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



		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
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
				FlxG.switchState(new MenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);



			if (controls.RIGHT_R)
				{
					FlxG.save.data.offset++;
					versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
				}
	
				if (controls.LEFT_R)
					{
						FlxG.save.data.offset--;
						versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
					}
		
			

			if (controls.ACCEPT)
			{
				if (curSelected != 4)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);

					case 1:
						FlxG.save.data.middlescroll = !FlxG.save.data.middlescroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.middlescroll ? 'middlescroll on' : 'middlescroll off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
						
					case 2:
						/// ok but fr why it default to no ghost tappin bruh
						FlxG.save.data.ghosttapping = !FlxG.save.data.ghosttapping;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.ghosttapping ? "Ghost Tapping" : "No Ghost Tapping"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.hideHUD = !FlxG.save.data.hideHUD;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
				    case 4:
						grpControls.remove(grpControls.members[curSelected]);
					    FlxG.save.data.cinematic = !FlxG.save.data.cinematic;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
					case 5:
					   grpControls.remove(grpControls.members[curSelected]);
					   FlxG.save.data.debug = !FlxG.save.data.debug;
					   var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.debug ? "debug MODE ON" : "debug MODE OFF"), true, false);
					   ctrl.isMenuItem = true;
					   ctrl.targetY = curSelected - 5;
					   #if windows
						ctrl.color = FlxColor.RED;
						#end
					   grpControls.add(ctrl);
					 case 6:
					   grpControls.remove(grpControls.members[curSelected]);
					   FlxG.save.data.reset = !FlxG.save.data.reset;
					   var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.reset ? "RESET BUTTON ON" : "RESET BUTTON OFF"), true, false);
					   ctrl.isMenuItem = true;
					   ctrl.targetY = curSelected - 6;
					   #if windows
						ctrl.color = FlxColor.CYAN;
						#end
					   grpControls.add(ctrl);
					 case 7:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.pausecount = !FlxG.save.data.pausecount;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.pausecount ? "pause counter on" : "pause counter off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 7;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
					 case 8:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.hittimings = !FlxG.save.data.hittimings;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.hittimings ? "MS Timing text ON" : "MS Timing text OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 8;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
					 case 9:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 9;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
					case 10:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.strumlights = !FlxG.save.data.strumlights;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.strumlights ? "STRUM LIGHTS ON" : "STRUM LIGHTS OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 10;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
							grpControls.add(ctrl);
					case 11:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.playerstrumlights = !FlxG.save.data.playerstrumlights;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 11;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
						case 12:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.switchState(new LatencyState());
						Conductor.changeBPM(120);
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "EDIT OFFSET");
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 12;
						#if windows
						ctrl.color = FlxColor.CYAN;
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
				item.color = FlxColor.RED;
				#end
				if (curSelected != 5)
					{
						#if windows
						///if debug is current selection
						/// ITS BACKWARDS!?!?!?!?! WHAT THE FUCK?
						item.color = FlxColor.CYAN;
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
										else
											{
												FlxG.camera.zoom += 0.015;
												camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
												trace('zoom');
											}
							    }

				}
			}

	var accepted:Bool = true;
}
