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

class CacheRock extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var songs:Array<String> = [
		"rockefeller-street-nightcore"
	];

	var controlsStrings:Array<String> = [];
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var gameVer:String = "0.2.7.1";
	public static var sniperengineversion:String = "0.1";
	var versionShit:FlxText;
	var done:FlxSprite;
	override function create()
	{
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				Cache();
				FlxG.sound.music.stop();
				FlxG.sound.music.volume = 0;
			});


		new FlxTimer().start(2.0, function(tmr:FlxTimer)
			{

								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										var poop:String = Highscore.formatSong('rockefeller-street-nightcore', 2);

										trace(poop);
					
										PlayState.SONG = Song.loadFromJson(poop, 'rockefeller-street-nightcore');
										PlayState.isStoryMode = false;
										PlayState.storyDifficulty = 2;
										PlayState.storyWeek = 1;
										LoadingState.loadAndSwitchState(new PlayState());
										trace('rockefeller-street-nightcore HARD');
									});
							
				
			});
			
				
				
			
       
							
					
			

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
				}
			}
	
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		

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
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}



	function Cache():Void
		{
			CachedFramesRock.loadEverything();
		}


		function preloadSongs()
			{
				for (i in songs) // caching all songs so loading is faster
				{
					FlxG.sound.cache(Paths.inst(i));
					trace('Loaded inst');
				}
		
			       // for some reason paths doesn't work???
		
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
				{

				});
			}
}
