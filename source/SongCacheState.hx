package;

import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;

class SongCacheState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var songs:Array<String> = ["bopeebo", "fresh", "dadbattle", "spookeez", "south", "monster", "pico", "philly", "blammed", "satin-panties", "high", "milf", "avidity", "cocoa", "eggnog", "winter-horrorland", "senpai", "roses", "thorns" ];

	var controlsStrings:Array<String> = [];
	public static var gameVer:String = "0.2.7.1";
	public static var sniperengineversion:String = "0.1";
	var versionShit:FlxText;
	var done:FlxSprite;
	var magenta:FlxSprite;
	override function create()
	{
			{
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						Cache();
					});	
			}
		
		var done:FlxSprite = new FlxSprite(0,-80).loadGraphic(Paths.image('imagesdone'));
		done.scrollFactor.x = 0;
		done.scrollFactor.y = 0.18;
		done.setGraphicSize(Std.int(done.width * 1.1));
		done.updateHitbox();
		done.antialiasing = true;
		done.visible = false;
		add(done);

		
		var ctrl:Alphabet = new Alphabet(0, (70) + 30, "caching songs", true, false);
			ctrl.screenCenter();
		    add(ctrl);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		
			
		var versionShit:FlxText = new FlxText(0, 0 , CachedFramesimg5.progress, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
				}
			}

				{
					///done.visible = true;
					new FlxTimer().start(3.0, function(tmr:FlxTimer)
						{
						   FlxG.switchState(new TitleState());
						});		
				}
	
	}

	var isSettingControl:Bool = false;




	function Cache():Void
		{
			preloadSongs();
		}


		function preloadSongs()
			{
				for (i in songs) // caching all songs so loading is faster
				{
					FlxG.sound.cache(Paths.inst(i));
					trace('Loaded inst');
					FlxG.sound.cache(Paths.voices(i));
					trace('Loaded voices');
				}
		
			       // for some reason paths doesn't work???
			}
}
