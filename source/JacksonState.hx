package;

import Controls.KeyboardScheme;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;


class JacksonState extends FlxState
{
	var offsetText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;
	var magenta:FlxSprite;
	var piss:FlxSprite;

	override function create()
	{
		FlxG.sound.music.stop();
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = true;
		add(magenta);

		
		FlxG.sound.play(Paths.sound('Sniper_negativevocalization03'));
		piss = new FlxSprite(-80).loadGraphic(Paths.image('Jarate_Icon'));
		piss.scrollFactor.x = 0;
		piss.scrollFactor.y = 0.18;
		piss.setGraphicSize(Std.int(piss.width * 1.1));
		piss.updateHitbox();
		piss.screenCenter();
		piss.antialiasing = true;
		add(piss);


		super.create();
	}

	override function update(elapsed:Float)
	{

		var multiply:Float = 1;

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new MainMenuState());
		
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.sound.music.stop();


		super.update(elapsed);
	}
}
