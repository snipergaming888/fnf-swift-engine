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
	var animationstylenumber:Int = 0;
	var animationstyle:String = '';
	var animationstyletext:String = '';
	var c1added:Bool = true;
	private var boyfriend:Boyfriend;
	public var sniperenginemark:FlxText;
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

	    sniperenginemark = new FlxText(4,695, "Current Animation Style: ", 20);
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

		if (animationstylenumber == 0)
			{
				animationstyle = 'bf';
				sniperenginemark.text = 'Current Animation Style: Default animations.';
			}

		if (animationstylenumber == 1)
			{
				animationstyle = 'bf-smooth';
				sniperenginemark.text = 'Current Animation Style: Smooth animations.';
			}

		if (animationstylenumber == 2)
			{
				animationstyle = 'bf-sqishy';
				sniperenginemark.text = 'Current Animation Style: Sqishy animations.';
			}


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

		boyfriend = new Boyfriend(400, 100, animationstyle);
		boyfriend.scrollFactor.set();
		add(boyfriend);

		super.create();

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

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

						if (FlxG.keys.justPressed.R)
							{
								animationstylenumber = 0;
							}
			
						if (FlxG.keys.justPressed.RIGHT && animationstylenumber >= 0 && animationstylenumber < 2)
							{
								animationstylenumber += 1;
							}
			
						if (FlxG.keys.justPressed.LEFT && animationstylenumber > 0 && animationstylenumber <= 2)
							{
								animationstylenumber -= 1;
							}

							if (animationstylenumber == 0)
								{
									animationstyle = 'bf';
									sniperenginemark.text = 'Current Animation Style: Default animations.';
									FlxG.save.data.smoothanims = false;
									FlxG.save.data.sqishyanims = false;
									updatebf();
								}

							if (animationstylenumber == 1)
								{
									animationstyle = 'bf-smooth';
									sniperenginemark.text = 'Current Animation Style: Smooth animations.';
									FlxG.save.data.smoothanims = true;
									FlxG.save.data.sqishyanims = false;
									updatebf();
								}

							if (animationstylenumber == 2)
								{
									animationstyle = 'bf-sqishy';
									sniperenginemark.text = 'Current Animation Style: Sqishy animations.';
									FlxG.save.data.smoothanims = false;
									FlxG.save.data.sqishyanims = true;
									updatebf();
								}
				

			if (controls.BACK)
			FlxG.switchState(new StoryMenuState());
			if (controls.BACK)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
				}
			

			if (controls.ACCEPT)
			{

			}
	}

	function updatebf():Void
		{
			remove(boyfriend);
			boyfriend = new Boyfriend (400, 100, animationstyle);
			boyfriend.scrollFactor.set();
			add(boyfriend);
		}

	var isSettingControl:Bool = false;

	override function beatHit()
		{
			super.beatHit();

			if (curBeat % 2 == 0)
				{
					boyfriend.playAnim('idle');
					trace('dance');
				}
				
		}

}
