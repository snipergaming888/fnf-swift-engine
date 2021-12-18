package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class MenuState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var camZoom:FlxTween;
	var CYAN:FlxColor = 0xFF00FFFF;
	var desc:FlxText;
	var voices:FlxSound;
	var descBG:FlxSprite;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		#if web
		controlsStrings = CoolUtil.coolStringFile('GAMEPLAY' + "\n" + "APPEARANCE" + "\n" + "KEYBINDS" + "\n" + "PERFORMANCE");
		#else
		controlsStrings = CoolUtil.coolStringFile('GAMEPLAY' + "\n" + "APPEARANCE" + "\n" + "KEYBINDS" + "\n" + "PERFORMANCE" + "\n" + "MISC");
		#end
		
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

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.screenCenter(X);
		add(descBG);

		desc = new FlxText(5, FlxG.height - 18, 0, "", 12);
		desc.scrollFactor.set();
		desc.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(desc);

		changeSelection();
		///so shit gets highlighted

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Options Menu", null);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		for (item in grpControls.members)
			{
				item.screenCenter(X);
			}

		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.BACK)
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

			if (curSelected == 0)
				desc.text = "In-game options menu.";

			if (curSelected == 1)
				desc.text = "In-game appearance menu.";

			if (curSelected == 2)
				desc.text = "Configure your keybinds.";

			if (curSelected == 3)
				desc.text = "In-game performance menu.";

			if (curSelected == 4)
				desc.text = "miscellaneous options menu.";
			

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						FlxG.switchState(new GameOptions());
					case 1:
						FlxG.switchState(new ApperanceOptions());
					case 2:
						FlxG.switchState(new OptionsMenu());
					case 3:
						FlxG.switchState(new PerformanceOptions());
					case 4:
						FlxG.switchState(new MiscOptions());
				}
			}
	}

	override public function onFocusLost():Void
		{
			#if PRELOAD_ALL
			if (FreeplayState.voicesplaying)
				FreeplayState.voices.pause();
			#end
			
			super.onFocusLost();
		}

		override public function onFocus():Void
			{
				#if PRELOAD_ALL
				if (FreeplayState.voicesplaying)
					{
						FreeplayState.voices.play();	
					}
				#end	

			   super.onFocus();
			}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		for (item in grpControls.members)
			{
				item.screenCenter(X);
			}
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
			item.screenCenter(X);
			bullShit++;
			

			item.alpha = 0.6;

			/*#if windows
			item.color = FlxColor.WHITE;
           */// #end
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				/*#if windows
				item.color = FlxColor.YELLOW;
				 *///#end
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
