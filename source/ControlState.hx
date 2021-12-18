package;

#if desktop
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

class ControlState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var camZoom:FlxTween;
	var CYAN:FlxColor = 0xFF00FFFF;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile('DFJK' + "\n" + "WASD" + "\n" + "ZX TWO THREE" + "\n" + "ASKL" + "\n" + "ARROWS" + "\n" + "CUSTOM");
		
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

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Control Options Menu", null);
		#end

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
			
			for (item in grpControls.members)
				{
					item.screenCenter(X);
				}
			
			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
						FlxG.save.data.DFJK = true;
						FlxG.save.data.WASD = false;
						FlxG.save.data.ZX23 = false;
						FlxG.save.data.ASKL = false;
						FlxG.save.data.ARROWS = false;
						trace('DFJK = ' + FlxG.save.data.DFJK);
						trace('WASD = ' + FlxG.save.data.WASD);
						trace('ZX23 = ' + FlxG.save.data.ZX23);
						trace('ASKL = ' + FlxG.save.data.ASKL);
						trace('ARROWS = ' + FlxG.save.data.ARROWS);
						FlxG.switchState(new ControlState());
					case 1:
						controls.setKeyboardScheme(KeyboardScheme.Duo(false), true);
						FlxG.save.data.WASD = true;
						FlxG.save.data.DFJK = false;
						FlxG.save.data.ZX23 = false;
						FlxG.save.data.ASKL = false;
						FlxG.save.data.ARROWS = false;
						trace('DFJK = ' + FlxG.save.data.DFJK);
						trace('WASD = ' + FlxG.save.data.WASD);
						trace('ZX23 = ' + FlxG.save.data.ZX23);
						trace('ASKL = ' + FlxG.save.data.ASKL);
						trace('ARROWS = ' + FlxG.save.data.ARROWS);
						FlxG.switchState(new ControlState());
					case 2:
						controls.setKeyboardScheme(KeyboardScheme.Woops, true);
						FlxG.save.data.ZX23 = true;
						FlxG.save.data.DFJK = false;
						FlxG.save.data.WASD = false;
						FlxG.save.data.ASKL = false;
						FlxG.save.data.ARROWS = false;
						trace('DFJK = ' + FlxG.save.data.DFJK);
						trace('WASD = ' + FlxG.save.data.WASD);
						trace('ZX23 = ' + FlxG.save.data.ZX23);
						trace('ASKL = ' + FlxG.save.data.ASKL);
						trace('ARROWS = ' + FlxG.save.data.ARROWS);
						FlxG.switchState(new ControlState());
					case 3:
						controls.setKeyboardScheme(KeyboardScheme.Augustine, true);
						FlxG.save.data.ASKL = true;
						FlxG.save.data.DFJK = false;
						FlxG.save.data.WASD = false;
						FlxG.save.data.ZX23 = false;
						FlxG.save.data.ARROWS = false;
						trace('DFJK = ' + FlxG.save.data.DFJK);
						trace('WASD = ' + FlxG.save.data.WASD);
						trace('ZX23 = ' + FlxG.save.data.ZX23);
						trace('ASKL = ' + FlxG.save.data.ASKL);
						trace('ARROWS = ' + FlxG.save.data.ARROWS);
						FlxG.switchState(new ControlState());
					case 4:
						controls.setKeyboardScheme(KeyboardScheme.Solo, true);
						FlxG.save.data.ARROWS = true;
						FlxG.save.data.DFJK = false;
						FlxG.save.data.WASD = false;
						FlxG.save.data.ZX23 = false;
						FlxG.save.data.ASKL = false;
						trace('DFJK = ' + FlxG.save.data.DFJK);
						trace('WASD = ' + FlxG.save.data.WASD);
						trace('ZX23 = ' + FlxG.save.data.ZX23);
						trace('ASKL = ' + FlxG.save.data.ASKL);
						trace('ARROWS = ' + FlxG.save.data.ARROWS);
						FlxG.switchState(new ControlState());
					case 5:
						controls.setKeyboardScheme(KeyboardScheme.Custom, true);
						FlxG.save.data.DFJK = false;
						FlxG.save.data.WASD = false;
						FlxG.save.data.ZX23 = false;
						FlxG.save.data.ASKL = false;
						FlxG.save.data.ARROWS = false;
						trace('DFJK = ' + FlxG.save.data.DFJK);
						trace('WASD = ' + FlxG.save.data.WASD);
						trace('ZX23 = ' + FlxG.save.data.ZX23);
						trace('ASKL = ' + FlxG.save.data.ASKL);
						trace('ARROWS = ' + FlxG.save.data.ARROWS);
						FlxG.switchState(new OptionsMenu());
						///TitleState.resetBinds();
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
