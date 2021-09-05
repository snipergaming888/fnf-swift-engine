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
import flixel.util.FlxTimer;

class CharacterSelectState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var CYAN:FlxColor = 0xFF00FFFF;
	var character1:FlxSprite;
	var c1added:Bool = true;
	var curDifficulty:Int = 1;
	var curWeek:Int = 0;
	private var boyfriend:Boyfriend;
	var sniperenginemark:FlxText;
	var wip:FlxText;
	var ENTER:FlxText;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile('' + "\n" + "" + "\n" + "" + "\n" + "");
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
	    add(menuBG);

		var sniperenginemark = new FlxText(4,695, "Current Character: BOYFRIEND", 20);
		sniperenginemark.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		sniperenginemark.scrollFactor.set();
		if (FlxG.save.data.antialiasing)
			{
				sniperenginemark.antialiasing = false;
			}
			else
				{
					sniperenginemark.antialiasing = true;
				}
		add(sniperenginemark);


		var wip = new FlxText(100,4, "The character select menu is currently a work in progress, so only boyfriend is avilible.", 20);
		wip.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		wip.scrollFactor.set();
		if (FlxG.save.data.antialiasing)
			{
				wip.antialiasing = false;
			}
			else
				{
					wip.antialiasing = true;
				}
		add(wip);

		var ENTER = new FlxText(993,695, "Press enter to continue.", 20);
		ENTER.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		ENTER.scrollFactor.set();
		if (FlxG.save.data.antialiasing)
			{
				ENTER.antialiasing = false;
			}
			else
				{
					ENTER.antialiasing = true;
				}
		add(ENTER);

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

		if (FlxG.keys.justPressed.D)
			{
				boyfriend.playAnim('singLEFT');
			}

			if (FlxG.keys.justPressed.F)
				{
					boyfriend.playAnim('singDOWN');
				}

				if (FlxG.keys.justPressed.J)
					{
						boyfriend.playAnim('singUP');
					}

					if (FlxG.keys.justPressed.K)
						{
							boyfriend.playAnim('singRIGHT');
						}

			if (curSelected != 1)
				{
					if (c1added)
						{
							#if windows
							boyfriend = new Boyfriend(400, 100, 'bf');
							add(boyfriend);
							new FlxTimer().start(0.65, function(tmr:FlxTimer)///boyfriend.animation.curAnim.namestartswith DOESN'T WORK!?!?!?!??!
								{
									if (boyfriend.animation.curAnim.name == ("singLEFT"))
										{
											tmr.reset();
											trace('do not idle bitch');
										}
										else if (boyfriend.animation.curAnim.name == ("singRIGHT"))
											{
												tmr.reset();
												trace('do not idle bitch');
											}
										else if (boyfriend.animation.curAnim.name == ("singUP"))
											{
											    tmr.reset();
											    trace('do not idle bitch');
									     	}
										else if (boyfriend.animation.curAnim.name == ("singDOWN"))
											{
												tmr.reset();
												trace('do not idle bitch');
											}
											else
											{
												boyfriend.playAnim('idle');
												trace(boyfriend.animation.curAnim.name);
												tmr.reset();
											}
								});
								new FlxTimer().start(1.3, function(tmr:FlxTimer)
									{
												{
													boyfriend.playAnim('idle');
													trace(boyfriend.animation.curAnim.name);
													tmr.reset();
												}
									});
								#end
							c1added = false;
						}	
				}
			if (curSelected != 4)
				{
					///remove(boyfriend);
				}

				if (curSelected != 2)
					{
						///remove(boyfriend);
					}

					if (curSelected != 3)
						{
							///remove(boyfriend);
						}

			if (controls.BACK)
				FlxG.switchState(new StoryMenuState());
			if (controls.LEFT_P)
				changeSelection(-1);
			if (controls.RIGHT_P)
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

					case 1:
						FlxG.switchState(new OptionsMenu());
					case 2:
						FlxG.switchState(new PerformanceOptions());
					case 3:
						FlxG.switchState(new MiscOptions());
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




	function resetall()
		{
			c1added = true;
		}
}
