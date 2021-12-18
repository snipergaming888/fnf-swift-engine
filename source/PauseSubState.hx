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

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	#if debug
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to freeplay menu', 'Exit to main menu'];
	#else
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Exit to freeplay menu', 'Exit to main menu'];
	#end
	var curSelected:Int = 0;
	public static var daPixelZoom:Float = 6;
	private var camHUD:FlxCamera;
	var startTimer:FlxTimer;
	var iscountingdown:Bool = true;
	var set:FlxSprite;
	var ready:FlxSprite;
	var go:FlxSprite;
	var pauseMusic:FlxSound;

	var difficultyChoices:Array<String> = ['EASY', 'NORMAL', 'HARD', 'BACK'];

	public function new(x:Float, y:Float)
	{
		super();
        ///thanks small things engine (there engine is cool): https://github.com/AyeTSG/Funkin_SmallThings/blob/master/source/PauseSubState.hx
		#if debug
		if (PlayState.isStoryMode) {
			if (PlayState.storyPlaylist.length != 1) {
				menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to storymode menu', 'Exit to main menu'];
			}
			else
				{
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to freeplay menu', 'Exit to main menu'];
				}
		}
		#else
		if (PlayState.isStoryMode) {
			if (PlayState.storyPlaylist.length != 1) {
				menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Exit to storymode menu', 'Exit to main menu'];
			}
			else
				{
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Exit to freeplay menu', 'Exit to main menu'];
				}
		}
		#end
				{
					pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
					pauseMusic.volume = 0;
					pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
			
					FlxG.sound.list.add(pauseMusic);
				}

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
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

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

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					if (FlxG.save.data.cinematic)
						{
							PlayState.camHUD.visible = false;
						}
					      if (FlxG.save.data.pausecount && iscountingdown)
							{
                              /// this is so you dont have to hit enter and instantly go back to your layout to hit one note
							var swagCounter:Int = 0;
					
							startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
							{
								var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
								introAssets.set('default', ['ready', "set", "go"]);
								introAssets.set('school', [
									'weeb/pixelUI/ready-pixel',
									'weeb/pixelUI/set-pixel',
									'weeb/pixelUI/date-pixel'
								]);
								introAssets.set('schoolEvil', [
									'weeb/pixelUI/ready-pixel',
									'weeb/pixelUI/set-pixel',
									'weeb/pixelUI/date-pixel'
								]);
					
								var introAlts:Array<String> = introAssets.get('default');
								var altSuffix:String = "";

								if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
									{
										for (value in introAssets.keys())
											{
												{
													introAlts = introAssets.get(value);
													altSuffix = '-pixel';
												}
											}
									}
					
					
								switch (swagCounter)
					
								{
									case 0:
										trace('3');
										FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
									case 1:
										var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0] + altSuffix));
										ready.scrollFactor.set();
										ready.updateHitbox();

										if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
											ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
					
					
										ready.screenCenter();
										add(ready);
										FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
											ease: FlxEase.cubeInOut,
											onComplete: function(twn:FlxTween)
											{
												ready.destroy();
											}
										});
										FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
										trace('2');
									case 2:
										var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1] + altSuffix));
										set.scrollFactor.set();

										if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
											set.setGraphicSize(Std.int(set.width * daPixelZoom));
					
					
										set.screenCenter();
										add(set);
										FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
											ease: FlxEase.cubeInOut,
											onComplete: function(twn:FlxTween)
											{
												set.destroy();
											}
										});
										FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
										trace('1');
									case 3:
										trace('go');
										var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2] + altSuffix));
										go.scrollFactor.set();

										if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
											go.setGraphicSize(Std.int(go.width * daPixelZoom));
					
										go.updateHitbox();
					
										go.screenCenter();
										add(go);
										FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
											ease: FlxEase.cubeInOut,
											onComplete: function(twn:FlxTween)
											{
												go.destroy();
											}
										});
										FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
									case 4:
										close();
								}
					
								swagCounter += 1;
								// generateSong('fresh');
							}, 5);
							}
							else
								{
								close();
								}
						

				///close();
				#if debug
				case "Chart Editor":
					FlxG.switchState(new ChartingState());	
				case "Restart Song":
					FlxG.resetState();
				case "Skip Song":
					PlayState.storyPlaylist.remove(PlayState.storyPlaylist[0]);

					var difficulty:String = "";

					if (PlayState.storyDifficulty == 0) {
						difficulty = '-easy';
					}

					if (PlayState.storyDifficulty == 2) {
						difficulty = '-hard';
					}

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					LoadingState.loadAndSwitchState(new PlayState());
				case "Exit to storymode menu":
					FlxG.switchState(new StoryMenuState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					case "Exit to freeplay menu":
						#if web
						trace("Freeplay HTML5");
						FlxG.switchState(new FreeplayStateHTML5());
						FlxG.timeScale = 1;
						#else
						FlxG.switchState(new FreeplayState());
						trace("Freeplay Menu");
						FlxG.timeScale = 1;
						#end	
				case "Exit to main menu":
					FlxG.switchState(new MainMenuState());
					FlxG.timeScale = 1;
					case "Animation Debug dad":
						FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
					case "Animation Debug bf":
						FlxG.switchState(new AnimationDebug(PlayState.SONG.player1));	
				case "Change Difficulty":
					menuItems = difficultyChoices;
					regenMenu();
				case "EASY" | "NORMAL" | "HARD":
					PlayState.SONG = Song.loadFromJson(Highscore.formatSong(PlayState.SONG.song.toLowerCase(), curSelected),
						PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = curSelected;
					FlxG.resetState();
					trace('changing difficulty to' + curSelected);
				case "BACK":
					if (PlayState.isStoryMode)
						{
							if (PlayState.storyPlaylist.length != 1) {
								menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to storymode menu', 'Exit to main menu'];
								regenMenu();
							}	
						}
						else
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to freeplay menu', 'Exit to main menu'];
					regenMenu();
                case "DFJK":
					controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
					FlxG.save.data.controls = false;
					Main.Custom = false;
					if (PlayState.isStoryMode)
						{
							if (PlayState.storyPlaylist.length != 1) {
								menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to storymode menu', 'Exit to main menu'];
								regenMenu();
							}	
						}
						else
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'Exit to freeplay menu', 'Exit to main menu'];
					regenMenu();
				#else
				case "Chart Editor":
					FlxG.switchState(new ChartingState());	
				case "Restart Song":
					FlxG.resetState();
				case "Skip Song":
					PlayState.storyPlaylist.remove(PlayState.storyPlaylist[0]);

					var difficulty:String = "";

					if (PlayState.storyDifficulty == 0) {
						difficulty = '-easy';
					}

					if (PlayState.storyDifficulty == 2) {
						difficulty = '-hard';
					}

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					LoadingState.loadAndSwitchState(new PlayState());
				case "Exit to storymode menu":
					FlxG.switchState(new StoryMenuState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					case "Exit to freeplay menu":
						#if web
						trace("Freeplay HTML5");
						FlxG.switchState(new FreeplayStateHTML5());
						FlxG.timeScale = 1;
						#else
						FlxG.switchState(new FreeplayState());
						trace("Freeplay Menu");
						FlxG.timeScale = 1;
						#end
				case "Exit to main menu":
					FlxG.switchState(new MainMenuState());
					FlxG.timeScale = 1;
					case "Animation Debug dad":
						FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
					case "Animation Debug bf":
						FlxG.switchState(new AnimationDebug(PlayState.SONG.player1));	
				case "Change Difficulty":
					menuItems = difficultyChoices;
					regenMenu();
				case "EASY" | "NORMAL" | "HARD":
					PlayState.SONG = Song.loadFromJson(Highscore.formatSong(PlayState.SONG.song.toLowerCase(), curSelected),
						PlayState.SONG.song.toLowerCase());
					PlayState.storyDifficulty = curSelected;
					FlxG.resetState();
					trace('changing difficulty to' + curSelected);
				case "BACK":
					if (PlayState.isStoryMode)
						{
							if (PlayState.storyPlaylist.length != 1) {
								menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'Chart Editor', 'Exit to storymode menu', 'Exit to main menu'];
								regenMenu();
							}	
						}
						else
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'Chart Editor', 'Exit to freeplay menu', 'Exit to main menu'];
					regenMenu();
					#end
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
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
