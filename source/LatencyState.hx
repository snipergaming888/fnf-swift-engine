package;

#if desktop
import Discord.DiscordClient;
#end
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


class LatencyState extends FlxState
{
	var offsetText:FlxText;
	var noteGrp:FlxTypedGroup<Note>;
	var strumLine:FlxSprite;
	var magenta:FlxSprite;

	override function create()
	{
		FlxG.sound.playMusic(Paths.sound('soundTest'));

		if (FreeplayState.voicesplaying)
			{
				FreeplayState.voicesplaying = false;
				FreeplayState.voices.stop();
			}
        if (FlxG.save.data.optimizations)
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat-opt'));
		else
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = true;
		magenta.color = 0xFF00ff51;
		add(magenta);

		noteGrp = new FlxTypedGroup<Note>();
		add(noteGrp);

		new FlxTimer().start(15.0, function(tmr:FlxTimer)
			{
				FlxG.sound.music.stop();

				FlxG.resetState();
				tmr.reset();
			});

		for (i in 0...200)
		{
			var note:Note = new Note(Conductor.crochet * i, 1);
			noteGrp.add(note);                           ///1
		}

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.screenCenter(X);
		add(descBG);

		offsetText = new FlxText(200,700);
		offsetText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(offsetText);

		strumLine = new FlxSprite(0, 100).makeGraphic(FlxG.width, 5);
		add(strumLine);         ///FlxG.width / 2

		Conductor.changeBPM(120);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Editing their Offset" + " (Offset: " + FlxG.save.data.offset + ")", null);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + FlxG.save.data.offset + "ms | left and right arrow to change, hold down SHIFT to go faster. Press SPACE to Reset.";

		Conductor.songPosition = FlxG.sound.music.time - FlxG.save.data.offset;

		var multiply:Float = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
			FlxG.save.data.offset += 1 * multiply;
		if (FlxG.keys.justPressed.LEFT)
			FlxG.save.data.offset -= 1 * multiply;

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.save.data.offset = 0;
		}

		if (FlxG.keys.justPressed.R)
			{
			  FlxG.sound.music.stop();

			  FlxG.resetState();
			}

			#if desktop
		    // Updating Discord Rich Presence
		    DiscordClient.changePresence("Editing their Offset" + " (Offset: " + FlxG.save.data.offset + ")", null);
		    #end

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new GameOptions());
		
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.sound.music.stop();
		noteGrp.forEach(function(daNote:Note)
		{
			daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * 0.45);
			daNote.x = strumLine.x + 600;

			if (daNote.y < strumLine.y)
				daNote.kill();
		});

		super.update(elapsed);
	}
}
