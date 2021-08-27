package;

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
import flixel.util.FlxColor;
import lime.utils.Assets;

class PerformanceOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
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

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
			

			if (controls.ACCEPT)
			{
				if (curSelected != 4)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Antialiasing " + (FlxG.save.data.antialiasing ? "on" : "off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
						
					case 1:
						FlxG.save.data.optimizations = !FlxG.save.data.optimizations;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "optimizations " + (FlxG.save.data.optimizations ? "on" : "off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						#if windows
						ctrl.color = FlxColor.CYAN;
						#end
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Antialiasing " + (FlxG.save.data.antialiasing ? "on" : "off"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
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
				item.color = FlxColor.CYAN;
				#end
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
