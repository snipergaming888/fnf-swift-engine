package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxBasic;
import Controls.KeyboardScheme;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxCamera;

class OptionsSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	#if debug
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Change Speed', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to freeplay menu', 'Exit to main menu'];
	#else
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Change Speed', 'Chart Editor', 'Exit to freeplay menu', 'Exit to main menu'];
	#end
	var curSelected:Int = 0;
	public static var daPixelZoom:Float = 6;
	private var camHUD:FlxCamera;
	var startTimer:FlxTimer;
	var isnotcountingdown:Bool = true;
	var set:FlxSprite;
	var ready:FlxSprite;
	var go:FlxSprite;
	var pauseMusic:FlxSound;
	var speedbool:Bool = false;

	var difficultyChoices:Array<String> = ['EASY', 'NORMAL', 'HARD', 'BACK'];
	var speed:Array<String> = ['SPEED', 'BACK'];

	public function new()
	{
		super();
        ///thanks small things engine (there engine is cool): https://github.com/AyeTSG/Funkin_SmallThings/blob/master/source/PauseSubState.hx
		#if debug
		if (PlayState.isStoryMode) {
			if (PlayState.storyPlaylist.length != 1) {
				menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Change Speed', 'Animation Debug dad', 'Animation Debug bf', 'Exit to storymode menu', 'Exit to main menu'];
			}
			else
				{
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Change Speed', 'Animation Debug dad', 'Animation Debug bf', 'Exit to freeplay menu', 'Exit to main menu'];
				}
		}
		#else
		if (PlayState.isStoryMode) {
			if (PlayState.storyPlaylist.length != 1) {
				menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Change Speed', 'Chart Editor', 'Exit to storymode menu', 'Exit to main menu'];
			}
			else
				{
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Change Speed', 'Chart Editor', 'Exit to freeplay menu', 'Exit to main menu'];
				}
		}
		#end

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			songText.screenCenter(X);
			grpMenuShit.add(songText);
		}

		changeSelection();

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		levelInfo.screenCenter(X);
		levelDifficulty.screenCenter(X);

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	function regenMenu():Void
		{
			for (i in 0...grpMenuShit.members.length)
				grpMenuShit.remove(grpMenuShit.members[0], true);
	
			for (i in 0...menuItems.length)
			{
				var item = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
				item.isMenuItem = true;
				item.targetY = i;
				item.screenCenter(X);
				grpMenuShit.add(item);
			}
	
			curSelected = 0;
			changeSelection();
		}

	override function update(elapsed:Float)
	{
		if (PauseSubState.pauseMusic.volume < 0.5)
			PauseSubState.pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		for (item in grpMenuShit.members)
			{
				item.screenCenter(X);
			}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted && isnotcountingdown)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
		
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		if (!speedbool)
			{
				curSelected += change;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
				if (curSelected >= menuItems.length)
					curSelected = 0;
		
				var bullShit:Int = 0;
		
				for (item in grpMenuShit.members)
				{
					item.targetY = bullShit - curSelected;
					bullShit++;
					item.screenCenter(X);
		
					item.alpha = 0.6;
					#if windows
					item.color = FlxColor.WHITE;
					#end
					// item.setGraphicSize(Std.int(item.width * 0.8));
		
					if (item.targetY == 0)
					{
						item.alpha = 1;
						// item.setGraphicSize(Std.int(item.width));
					}
				}
			}
	}
}
