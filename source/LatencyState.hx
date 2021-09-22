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

class LatencyState extends FlxState
{
	var offsetText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;

	override function create()
	{
		FlxG.sound.playMusic(Paths.sound('soundTest', 'shared'));

		noteGrp = new FlxTypedGroup<Note>();
		add(noteGrp);

		for (i in 0...200)
		{
			var note:Note = new Note(Conductor.crochet * i, 1);
			noteGrp.add(note);
		}

		offsetText = new FlxText(500,700);
		add(offsetText);

		strumLine = new FlxSprite(FlxG.width / 2, 100).makeGraphic(FlxG.width, 5);
		add(strumLine);

		Conductor.changeBPM(120);

		super.create();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + Conductor.offset + "ms | left and right arrow to change, hold down SHIFT to go faster.";

		Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

		var multiply:Float = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
			Conductor.offset += 1 * multiply;
		if (FlxG.keys.justPressed.LEFT)
			Conductor.offset -= 1 * multiply;

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();

			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new GameOptions());
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.sound.music.stop();
		noteGrp.forEach(function(daNote:Note)
		{
			daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * 0.45);
			daNote.x = strumLine.x + 30;

			if (daNote.y < strumLine.y)
				daNote.kill();
		});

		super.update(elapsed);
	}
}
