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

class Cache extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var songs:Array<String> = [
		"glitcher"
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
			});
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile('Caching...');
		
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

		new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{

				var done:FlxSprite = new FlxSprite(0,-80).loadGraphic(Paths.image('imagesdone'));
								done.scrollFactor.x = 0;
								done.scrollFactor.y = 0.18;
								done.setGraphicSize(Std.int(done.width * 1.1));
								done.updateHitbox();
								done.antialiasing = true;
								add(done);

								new FlxTimer().start(0.5, function(tmr:FlxTimer)
									{
										var poop:String = Highscore.formatSong('glitcher', 2);

										trace(poop);
					
										PlayState.SONG = Song.loadFromJson(poop, 'glitcher');
										PlayState.isStoryMode = false;
										PlayState.storyDifficulty = 2;
										PlayState.storyWeek = 1;
										LoadingState.loadAndSwitchState(new PlayState());
										trace('glitcher');
									});
							
				
			});
			
				
				
			
       
							
					
			


		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer + " FNF - " + sniperengineversion + " Sniper Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

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
			CachedFrames.loadEverything();
		}


		function preloadSongs()
			{
				for (i in songs) // caching all songs so loading is faster
				{
					FlxG.sound.cache(Paths.inst(i));
					trace('Loaded inst');
				}
		
			       // for some reason paths doesn't work???
		
				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					var done:FlxSprite = new FlxSprite(0,-160).loadGraphic(Paths.image('musicdone'));
								done.scrollFactor.x = 0;
								done.scrollFactor.y = 0.18;
								done.setGraphicSize(Std.int(done.width * 1.1));
								done.updateHitbox();
								done.antialiasing = true;
								add(done);

				});
			}
}
