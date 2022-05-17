package;

#if cpp
import Discord.DiscordClient;
#end
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
import openfl.Lib;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	#if debug
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'Animation Debug dad', 'Animation Debug bf', 'options', 'Exit to freeplay menu', 'Exit to main menu'];
	#else
	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to freeplay menu', 'Exit to main menu'];
	#end
	var curSelected:Int = 0;
	public static var daPixelZoom:Float = 6;
	private var camHUD:FlxCamera;
	var startTimer:FlxTimer;
	var isnotcountingdown:Bool = true;
	var set:FlxSprite;
	var ready:FlxSprite;
	var go:FlxSprite;
	public static var pauseMusic:FlxSound;
	var isingameplay:Bool = false;
	var isinappearance:Bool = false;
	var isinkeybinds:Bool = false;
	var isinperformance:Bool = false;
	var isinmisc:Bool = false;
	var isSettingControlup:Bool = false;
	var isSettingControldown:Bool = false;
	var isSettingControlleft:Bool = false;
	var isSettingControlright:Bool = false;
	var abletochange:Bool = true;
	public static var blueballed:Int = 0;
	private var keyalphabet:FlxTypedGroup<Alphabet>;
	var aming:Alphabet;
	var versionShit:FlxText;
	private var grpControls:FlxTypedGroup<Alphabet>;
	var HITVOL:Float = FlxG.save.data.hitsoundvolume;
	var scrollspeed:Float = FlxG.save.data.speedamount;
	public static var ghosttappinghitsoundsenabled:Bool = false;
	public var prevNote:Note;
	public var daSelected:String;
	public static var practice:FlxText;
	public static var practicemode:Bool = false;

	var difficultyChoices:Array<String> = ['EASY', 'NORMAL', 'HARD', 'BACK'];
	var speed:Array<String> = ['SPEED', 'BACK'];
	var controlsStrings:Array<String> = [];
	var needstoreload:Bool = false;
	var ISDESKTOP:Bool = false; // sextop
	private var boyfriend:Boyfriend;
	var popuptext:FlxText;
	var yes:FlxText;
	var no:FlxText;
	var comfirmbg:FlxSprite;

	public function new(x:Float, y:Float)
	{
		#if desktop
		ISDESKTOP = true;
		#end
		needstoreload = false;

		super();
        ///thanks small things engine (there engine is cool): https://github.com/AyeTSG/Funkin_SmallThings/blob/master/source/PauseSubState.hx
		#if debug
		if (StoryMenuState.isStoryMode) {
			if (PlayState.storyPlaylist.length != 1) {
				menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'toggle practice mode', 'Chart Editor', 'Change Speed', 'Animation Debug dad', 'Animation Debug bf', 'options', 'Exit to storymode menu', 'Exit to main menu'];
			}
			else
				{
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Chart Editor', 'Change Speed', 'Animation Debug dad', 'Animation Debug bf', 'options', 'Exit to freeplay menu', 'Exit to main menu'];
				}
		}
		#else
		if (StoryMenuState.isStoryMode && PlayState.storyPlaylist.length != 1)
			{
				menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to storymode menu', 'Exit to main menu'];
			}
			else if (StoryMenuState.isStoryMode)
				{
					menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to storymode menu', 'Exit to main menu'];
				}
				else
					{
						menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to freeplay menu', 'Exit to main menu'];
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
		keyalphabet = new FlxTypedGroup<Alphabet>();

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		
		versionShit = new FlxText(5, FlxG.height - 25, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.visible = false;
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeSelection();

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += StringTools.replace(PlayState.SONG.song, "-", " ").toLowerCase();
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

		var blueballed:FlxText = new FlxText(20, 15 + 64, 0, "Blue balled: " + PlayState.blueballed, 32);
		blueballed.scrollFactor.set();
		blueballed.setFormat(Paths.font('vcr.ttf'), 32);
		blueballed.updateHitbox();
		add(blueballed);

        if (practicemode)
		practice = new FlxText(0, 15 + 96, 0, "PRACTICE MODE", 32);
		else
		practice = new FlxText(20, 15 + 96, 0, "", 32);
		practice.scrollFactor.set();
		practice.setFormat(Paths.font('vcr.ttf'), 32);
		practice.updateHitbox();
		add(practice);


		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		blueballed.alpha = 0;
		practice.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballed.x = FlxG.width - (blueballed.width + 20);
		practice.x = FlxG.width - (practice.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballed, {alpha: 1, y: blueballed.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});
		FlxTween.tween(practice, {alpha: 1, y: practice.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.9});
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		var aming:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('press-any-key'), true, false);
		aming.isMenuItem = false;
		aming.targetY = curSelected - 0;
		aming.screenCenter(X);
		keyalphabet.add(aming);
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
				grpMenuShit.add(item);
			}
	
			curSelected = 0;
			changeSelection();
		}

	function regengameplay():Void
		{
			remove(grpMenuShit);
					menuItems = CoolUtil.coolStringFile("\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\n" + (FlxG.save.data.middlescroll ? "middlescroll on" : "middlescroll off") + "\n" + (FlxG.save.data.ghosttapping ? "Ghost Tapping" : "No Ghost Tapping") + "\n" + (FlxG.save.data.oldinput ? "OLD INPUT ON" : "OLD INPUT OFF") + "\n" + (FlxG.save.data.antimash ? "anti mash ON" : " anti mash OFF") + "\n" + (FlxG.save.data.reset ? "RESET BUTTON ON" : "RESET BUTTON OFF") + "\n" + (FlxG.save.data.pausecount ? "pause counter on" : "pause counter off") + "\n" + (FlxG.save.data.repeat ? 'loop current song on' : 'loop current song off') + "\n" + (FlxG.save.data.hitsounds ? 'hitsounds on' : 'hitsounds off')  + "\n" + (FlxG.save.data.songspeed ? 'SET SCROLL SPEED ON' : 'SET SCROLL SPEED OFF') + "\n" + (FlxG.save.data.botplay ? 'BOTPLAY ON' : 'BOTPLAY OFF') + "\n" + (FlxG.save.data.missnotes ? 'miss sounds on' : 'miss sounds off') + "\n" + (FlxG.save.data.instantRespawn ? 'instant respawn on' : 'instant respawn off') + "\n" + "EDIT OFFSET" + "\n" + "BACK");
					trace(menuItems);		

					grpMenuShit = new FlxTypedGroup<Alphabet>();
					add(grpMenuShit);
			
					for (i in 0...menuItems.length)
					{
							var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
							songText.isMenuItem = true;
							songText.targetY = i;
							grpMenuShit.add(songText);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
					changeSelection();
		}

		function regenappearance():Void
		{
			remove(grpMenuShit);
			menuItems =	CoolUtil.coolStringFile("\n" + (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD") + "\n" + (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF") + "\n" + (FlxG.save.data.hittimings ? "MS Timing info ON" : "MS Timing info OFF") + "\n" + (FlxG.save.data.showratings ? "ratings info ON" : "ratings info OFF") + "\n" + (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION off")+ "\n" + (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off")+ "\n" + (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF") + "\n" + (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF") + "\n" + (FlxG.save.data.nps ? "NPS ON" : "NPS OFF") + "\n" + (FlxG.save.data.healthcolor ? 'new healthbar on' : 'new healthbar off') + "\n" + (FlxG.save.data.newhealthheadbump ? 'new healthhead bump on' : 'new healthhead bump off') + "\n" + (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF") + "\n" + (FlxG.save.data.togglecap ? "FPS CAP ON" : "FPS CAP OFF") + "\n" + (FlxG.save.data.memoryMonitor ? "memoryMonitor ON" : "memoryMonitor OFF") + "\n" + (FlxG.save.data.middlecam ? "Camera focusing ON" : "camera focusing Off") + "\n" + (FlxG.save.data.camfollowspeedon ? "Camera speed modif on" : "Camera speed modif off") + "\n" + (FlxG.save.data.enablesickpositions ? 'custom rating position on' : 'custom rating position off') + "\n" + (FlxG.save.data.songinfo ? 'song info popup on' : 'song info popup off') + "\n" + (FlxG.save.data.combotext ? 'combo text on' : 'combo text off') + "\n" + "Customize Gameplay" + "\n" + "EDIT Scoretext preference" + "\n" + (FlxG.save.data.minscore ? 'old scoretext on' : 'old scoretext off') + "\n" + (FlxG.save.data.notesplashes ? 'notesplashes on' : 'notesplashes off') + "\n" + "BACK");
					trace(menuItems);		

					grpMenuShit = new FlxTypedGroup<Alphabet>();
					add(grpMenuShit);
			
					for (i in 0...menuItems.length)
					{
							var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
							songText.isMenuItem = true;
							songText.targetY = i;
							grpMenuShit.add(songText);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
					changeSelection();
		}

		function regenkeybinds():Void
			{
				remove(grpMenuShit);
				menuItems = CoolUtil.coolStringFile(FlxG.save.data.leftBind + "\n" + FlxG.save.data.downBind + "\n" + FlxG.save.data.upBind + "\n" + FlxG.save.data.rightBind + "\n" + "reset-all" + "\n" + "BACK");
						trace(menuItems);		
	
						grpMenuShit = new FlxTypedGroup<Alphabet>();
						add(grpMenuShit);
				
						for (i in 0...menuItems.length)
						{
								var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
								songText.isMenuItem = true;
								songText.targetY = i;
								grpMenuShit.add(songText);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
						changeSelection();
			}

			function regenperformance():Void
				{
					remove(grpMenuShit);
					if (ISDESKTOP)
						menuItems = CoolUtil.coolStringFile("\n" + (FlxG.save.data.antialiasing ? "Antialiasing on" : "Antialiasing off") + "\n" + (FlxG.save.data.optimizations ? "optimizations on" : "optimizations off") + "\n" + (FlxG.save.data.usedeprecatedloading ? "deprecated loading on" : "deprecated loading off") + "\n" + "BACK");
						else
							menuItems = CoolUtil.coolStringFile("\n" + (FlxG.save.data.antialiasing ? "Antialiasing on" : "Antialiasing off") + "\n" + (FlxG.save.data.optimizations ? "optimizations on" : "optimizations off") + "\n" + (FlxG.save.data.usedeprecatedloading ? "deprecated loading on" : "deprecated loading off") + "\n" + "BACK");
					trace(menuItems);
		
							grpMenuShit = new FlxTypedGroup<Alphabet>();
							add(grpMenuShit);
					
							for (i in 0...menuItems.length)
							{
									var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
									songText.isMenuItem = true;
									songText.targetY = i;
									grpMenuShit.add(songText);
								// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
							}
							changeSelection();
				}

				function regenmisc():Void
					{
						remove(grpMenuShit);
								menuItems = CoolUtil.coolStringFile("\n" + (FlxG.save.data.freeplaysongs ? 'freeplay song previews on' : 'freeplay song previews off') +"\n" + (FlxG.save.data.discordrpc ? 'discord presence on' : 'discord presence off') + "\n" + "BACK");
						trace(menuItems);
			
								grpMenuShit = new FlxTypedGroup<Alphabet>();
								add(grpMenuShit);
						
								for (i in 0...menuItems.length)
								{
										var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
										songText.isMenuItem = true;
										songText.targetY = i;
										grpMenuShit.add(songText);
									// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
								}
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

		if (practicemode)
			{
				practice.text = "PRACTICE MODE";
			}
			else
				practice.text = "";
		if (isingameplay)
			{
				versionShit.visible = true;	
			}
			else if (isinappearance)
				{
					versionShit.visible = true;
				}
				else if (isinkeybinds)
					{
						versionShit.visible = true;
					}
					else if (isinperformance)
						{
							versionShit.visible = true;
						}
						else if (isinmisc)
							{
								versionShit.visible = true;
							}
							else if (StoryMenuState.isStoryMode && PlayState.storyPlaylist.length != 1 && curSelected == 5)
								{
									versionShit.visible = true;
									versionShit.text = "change the speed at which that the game runs. speed: " + truncateFloat(FreeplayState.gamespeed, 2) + " (Left, Right)";

									if (controls.RIGHT_R)
										{
											FreeplayState.gamespeed += 0.1;
											trace(FreeplayState.gamespeed);
											versionShit.text = "change the speed at which that the game runs. speed: " + truncateFloat(FreeplayState.gamespeed, 2) + " (Left, Right)";
											PlayState.speedchange();
										}
							
										if (controls.LEFT_R)
											{
												FreeplayState.gamespeed -= 0.1;
												trace(FreeplayState.gamespeed);
												versionShit.text = "change the speed at which that the game runs. speed: " + truncateFloat(FreeplayState.gamespeed, 2) + " (Left, Right)";
												PlayState.speedchange();
											}
								}
								else if (curSelected == 4)
									{
										versionShit.visible = true;
										versionShit.text = "change the speed at which that the game runs. speed: " + truncateFloat(FreeplayState.gamespeed, 2) + " (Left, Right)";
	
										if (controls.RIGHT_R)
											{
												FreeplayState.gamespeed += 0.1;
												trace(FreeplayState.gamespeed);
												versionShit.text = "change the speed at which that the game runs. speed: " + truncateFloat(FreeplayState.gamespeed, 2) + " (Left, Right)";
												PlayState.speedchange();
											}
								
											if (controls.LEFT_R)
												{
													FreeplayState.gamespeed -= 0.1;
													trace(FreeplayState.gamespeed);
													versionShit.text = "change the speed at which that the game runs. speed: " + truncateFloat(FreeplayState.gamespeed, 2) + " (Left, Right)";
													PlayState.speedchange();
												}
									}
									else
										{
											versionShit.visible = false;
										}
		
						if (isSettingControlup)
							{
								add(keyalphabet);		
								waitingInputup();
							}
							else if (isSettingControldown)
								{
									add(keyalphabet);		
									waitingInputdown();
								}
								 else if (isSettingControlleft)
									{
										add(keyalphabet);
										waitingInputleft();
									}
									else if (isSettingControlright)
										{
											add(keyalphabet);
											waitingInputright();
										}							
						
        /// gameplay text
		if (curSelected == 0 && isingameplay)
			versionShit.text = "If the notes will scroll down or not.";
		if (curSelected == 1 && isingameplay)
			versionShit.text = "If the notes should appear in the middle of the screen.";
		if (curSelected == 2 && isingameplay)
			versionShit.text = "Wether or not you should have a health penalty for pressing keys not on a note.";
		if (curSelected == 3 && isingameplay)
			versionShit.text = "Weather or not to use old input. (default FNF input)";
		if (curSelected == 4 && isingameplay)
			versionShit.text = "Wether or not to allow spamming of keys with ghost tapping.";
		if (curSelected == 5 && isingameplay)
			versionShit.text = "Wether or not the reset button (R) should be on.";
		if (curSelected == 6 && isingameplay)
			versionShit.text = "Should there be a 'ready', 'set', 'go!' counter after unpauseing.";
		if (curSelected == 7 && isingameplay)
			versionShit.text = "Wether or not to play the current song again after it ends.";
		if (curSelected == 8 && isingameplay)
			versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
		if (curSelected == 9 && isingameplay)
			versionShit.text = "Wether or not to enable an editable scroll speed. scroll speed: " + truncateFloat(scrollspeed, 2) + " (Left, Right)";
		if (curSelected == 10 && isingameplay)
			versionShit.text = "If a CPU should play the game for you.";
		if (curSelected == 11 && isingameplay)
			versionShit.text = "Wether or not to play miss sounds.";
		if (curSelected == 12 && isingameplay)
			versionShit.text = "Wether or not to instantly respawn after death.";
		/// appearance text
		if (curSelected == 0 && isinappearance)
			versionShit.text = "Hide all text and the healthbar.";
		if (curSelected == 1 && isinappearance)
			versionShit.text = "Hide all UI, strumline, and notes.";
		if (curSelected == 2 && isinappearance)
			versionShit.text = "Show in miliseconds how long it took for you to hit a note.";
		if (curSelected == 3 && isinappearance)
			versionShit.text = "Show how many sicks, goods, bads and shits you get off to the side.";
		if (curSelected == 4 && isinappearance)
			versionShit.text = "Show what position in the song you are.";
		if (curSelected == 5 && isinappearance)
			versionShit.text = "Wether or not to have note trails transparent or not transparent.";
		if (curSelected == 6 && isinappearance)
			versionShit.text = "Wether or not to have the CPU strums light up.";
		if (curSelected == 7 && isinappearance)
			versionShit.text = "Wether or not to have the player strums light up.";
		if (curSelected == 8 && isinappearance)
			versionShit.text = "Wether or not to have the camera zoom in on beat.";
		if (curSelected == 9 && isinappearance)
			versionShit.text = "Wether or not to show engine watermarks. (will not remove botplay text)";
		if (curSelected == 10 && isinappearance)
			versionShit.text = "Wether or not to show notes per second.";
		if (curSelected == 11 && isinappearance)
			versionShit.text = "If the healthbar should be the color of the player (1 or 2).";
		if (curSelected == 12 && isinappearance)
			versionShit.text = "If the healthbar heads should act like the ones from week 7. (new healthhead bump)";
		if (curSelected == 13 && isinappearance)
			versionShit.text = "Toggle the FPS counter on and off.";
		if (curSelected == 14 && isinappearance)
			versionShit.text = "Set the FPS cap. FPS: " + FlxG.save.data.fpsCap + " (Left, Right, Space to reset, Shift to go faster)";
		if (curSelected == 15 && isinappearance)
			versionShit.text = "Toggle the memory monitor on and off.";
		if (curSelected == 16 && isinappearance)
			versionShit.text = "Toggle if the camera should point at player 1 and 2 when they are singing.";
		if (curSelected == 17 && isinappearance)
			versionShit.text = "Set the custom camera panning speed. (lower values = faster pan) cur speed: " + FlxG.save.data.camfollowspeed + " (Left, Right, Space to reset, Shift to go faster)";
		if (curSelected == 18 && isinappearance)
			versionShit.text = "Enable The ratings to be bigger and draggable to a place on the screen. (Kade Engine ratings)";

		if (curSelected == 19 && isinappearance)
			versionShit.text = "Display song composer info when a song starts.";

		if (curSelected == 20 && isinappearance)
			versionShit.text = "Show 'combo' text next to the combo number.";

		if (curSelected == 21 && isinappearance)
			versionShit.text = "Customize were your ratings should be and other gameplay elements.";

		if (curSelected == 22 && isinappearance)
			versionShit.text = "Edit Your prefered scoretext Layout.";

		if (curSelected == 23 && isinappearance)
			versionShit.text = "enable old scoretext.";

		if (curSelected == 24 && isinappearance)
			versionShit.text = "enable notesplashes.";
		if (isinkeybinds)
			versionShit.text = "Press enter on the key you want to rebind then press the key you want to rebind it to.";
        if (FlxG.save.data.antialiasing && curSelected == 0 && isinperformance)
				{
					versionShit.text = "ANTIALIASING ON";
					versionShit.antialiasing = true;
				}
				else if (!FlxG.save.data.antialiasing && curSelected == 0 && isinperformance)
				    {
						versionShit.text = "ANTIALIASING OFF";
						versionShit.antialiasing = false;	
					}
		if (curSelected == 1 && isinperformance)
			versionShit.text = "Wether or not to use compressed assets and disable some background animations.";
		if (curSelected == 2 && isinperformance)
			versionShit.text = "Use the deprecated way to load things in-game. load times are slower than using the new loading scheme.";
		if (curSelected == 0 && isinmisc)
			versionShit.text = "Play songs in freeplay when hovering over them.";
		if (curSelected == 1 && isinmisc)
			versionShit.text = "Disable or enable the games discord presence.";


			//keybinds shit
			if (isinkeybinds && curSelected == 0 && FlxG.keys.justPressed.ENTER)
				{
						isSettingControlleft = true;
						abletochange = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				}
				
				if (isinkeybinds && curSelected == 1 && FlxG.keys.justPressed.ENTER)
				{
						isSettingControldown = true;
						abletochange = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				}
				if (isinkeybinds && curSelected == 2 && FlxG.keys.justPressed.ENTER)
				{
						isSettingControlup = true;
						abletochange = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				}
				if (isinkeybinds && curSelected == 3 && FlxG.keys.justPressed.ENTER)
				{
						isSettingControlright = true;
						abletochange = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				}
				if (isinkeybinds && curSelected == 4 && FlxG.keys.justPressed.ENTER)
				{
						///controls.setKeyboardScheme(Solo);
						TitleState.resetBinds();
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
						regenkeybinds();
						//FlxG.switchState(new OptionsMenu());
				}			

		if (curSelected == 13 && isingameplay)
			{
				versionShit.text = "Offset: " + FlxG.save.data.offset + "ms | left and right arrow to change, hold down SHIFT to go faster. Press SPACE to Reset.";
				var multiply:Float = 1;
				if (FlxG.keys.pressed.SHIFT)
					multiply = 10;
		
				if (FlxG.keys.justPressed.RIGHT)
					{
						FlxG.save.data.offset += 1 * multiply;
						needstoreload = true;
					}
				if (FlxG.keys.justPressed.LEFT)
					{
						FlxG.save.data.offset -= 1 * multiply;
						needstoreload = true;
					}
		
				if (FlxG.keys.justPressed.SPACE)
				{
					FlxG.save.data.offset = 0;
					needstoreload = true;
				}
			}

			if (FlxG.keys.justPressed.G && curSelected == 8 && isingameplay)
				{
				versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
				if (!ghosttappinghitsoundsenabled)
					{
						ghosttappinghitsoundsenabled = true;
						FlxG.save.data.ghosttappinghitsoundsenabled = true;
						trace('ghost tapping hitsounds enabled: ' + ghosttappinghitsoundsenabled);
						trace('ghost tapping hitsounds save data enabled: ' + FlxG.save.data.ghosttappinghitsoundsenabled);
					}
					else if (ghosttappinghitsoundsenabled)
						{
							ghosttappinghitsoundsenabled = false;
							FlxG.save.data.ghosttappinghitsoundsenabled = false;
							trace('ghost tapping hitsounds enabled: ' + ghosttappinghitsoundsenabled);
							trace('ghost tapping hitsounds save data enabled: ' + FlxG.save.data.ghosttappinghitsoundsenabled);
						}
				}

				if (curSelected == 15 && isinappearance)
					{
						var multiply:Float = 1;
	
						if (FlxG.keys.pressed.SHIFT && FlxG.save.data.fpsCap < 1000 && FlxG.save.data.fpsCap > 30 && FlxG.save.data.togglecap)
							multiply = 10;
				
						if (FlxG.keys.justPressed.RIGHT && FlxG.save.data.fpsCap < 1000 && FlxG.save.data.togglecap)
							{
									{
										FlxG.save.data.fpsCap += 1 * multiply;
										(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
										FlxG.updateFramerate = FlxG.save.data.fpsCap;
										FlxG.drawFramerate = FlxG.save.data.fpsCap;
									}
							}
						if (FlxG.keys.justPressed.LEFT && FlxG.save.data.fpsCap > 20 && FlxG.save.data.togglecap)
							{
									{
										FlxG.save.data.fpsCap -= 1 * multiply;
										(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
										FlxG.updateFramerate = FlxG.save.data.fpsCap;
										FlxG.drawFramerate = FlxG.save.data.fpsCap;
									}
							}
				
						if (FlxG.keys.justPressed.SPACE && FlxG.save.data.togglecap)
						{
							FlxG.save.data.fpsCap = 138;
							(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
						}
					}

					
				if (curSelected == 17 && isinappearance)
					{
						var multiply:Float = 1;
	
						if (FlxG.keys.pressed.SHIFT && FlxG.save.data.camfollowspeed < 1000 && FlxG.save.data.camfollowspeed > 0 && FlxG.save.data.camfollowspeedon)
							multiply = 10;
				
						if (FlxG.keys.justPressed.RIGHT && FlxG.save.data.camfollowspeed < 1000 && FlxG.save.data.camfollowspeedon)
							{
									{
										FlxG.save.data.camfollowspeed += 1 * multiply;
									}
							}
						if (FlxG.keys.justPressed.LEFT && FlxG.save.data.camfollowspeed > 0 && FlxG.save.data.camfollowspeedon)
							{
									{
										FlxG.save.data.camfollowspeed -= 1 * multiply;
									}
							}
				
						if (FlxG.keys.justPressed.SPACE && FlxG.save.data.camfollowspeedon)
						{
							FlxG.save.data.camfollowspeed = 60;
						}
					}

				if (FlxG.keys.justPressed.ESCAPE)
					{
						close();
						if (isingameplay = false)
							{
								isingameplay = false;
							}
						if (isinappearance)
							{
								isinappearance = false;
							}
						if (isinkeybinds)
							{
								isinkeybinds = false;
								PlayerSettings.player1.controls.loadKeyBinds();
								trace('SAVED BINDS');
								FlxG.save.data.controls = true;
							}
                        if (isinperformance)
							{
								isinperformance = false;
							}
						if (isinmisc)
						{
								isinmisc = false;
						}
					}

					if (FlxG.keys.justPressed.BACKSPACE)
						{
							if (StoryMenuState.isStoryMode && PlayState.storyPlaylist.length != 1)
								{
									menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to storymode menu', 'Exit to main menu'];
								}
								else if (StoryMenuState.isStoryMode)
									{
										menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to storymode menu', 'Exit to main menu'];
									}
									else
										{
											menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to freeplay menu', 'Exit to main menu'];
										}
							regenMenu();			
							if (isingameplay = false)
								{
									isingameplay = false;
								}
							if (isinappearance)
								{
									isinappearance = false;
								}
							if (isinkeybinds)
								{
									isinkeybinds = false;
									PlayerSettings.player1.controls.loadKeyBinds();
									trace('SAVED BINDS');
									FlxG.save.data.controls = true;
								}
							if (isinperformance)
								{
									isinperformance = false;
								}
							if (isinmisc)
							{
									isinmisc = false;
							}
						}


			if (controls.RIGHT_R && curSelected == 8 && isingameplay)
				{
					HITVOL += 0.1;
					FlxG.save.data.hitsoundvolume = HITVOL;
					trace(HITVOL);
					versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
				}
	
				if (controls.LEFT_R && curSelected == 8 && isingameplay)
					{
						HITVOL -= 0.1;
						trace(HITVOL);
						FlxG.save.data.hitsoundvolume = HITVOL;
						versionShit.text = "Wether or not to play sounds when hitting a note. Volume: " + truncateFloat(HITVOL, 2) + " (Left, Right)" + " | Ghost Tapping Hitsounds Enabled: " + ghosttappinghitsoundsenabled + " (Toggle with G)";
					}

					if (controls.RIGHT_R && curSelected == 9 && isingameplay)
						{
							scrollspeed += 0.1;
							FlxG.save.data.speedamount = scrollspeed;
							trace(scrollspeed);
							versionShit.text = "Wether or not to enable an editable scroll speed. scroll speed: " + truncateFloat(scrollspeed, 2) + " (Left, Right)";
							PlayState.resetlength = true;
						}
			
						if (controls.LEFT_R && curSelected == 9 && isingameplay)
							{
								scrollspeed -= 0.1;
								trace(scrollspeed);
								FlxG.save.data.speedamount = scrollspeed;
								versionShit.text = "Wether or not to enable an editable scroll speed. scroll speed: " + truncateFloat(scrollspeed, 2) + " (Left, Right)";
								PlayState.resetlength = true;
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
				case "Resume":
					if (needstoreload)
						{
							if (!FlxG.save.data.usedeprecatedloading)
								{
									
									//PlayState.instance.restart();
								}
								else
									{
											FlxG.resetState();
									}
						}
		
					if (FlxG.save.data.cinematic)
						{
							PlayState.camHUD.visible = false;
						}
					      if (FlxG.save.data.pausecount && isnotcountingdown)
							{
								isnotcountingdown = false;
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
				case "Chart Editor":
					PlayState.triggeredalready = false;	
					FlxG.switchState(new ChartingState());
				case "Restart Song":
					if (!FlxG.save.data.usedeprecatedloading)
						{
							FlxTransitionableState.skipNextTransIn = false;
							FlxTransitionableState.skipNextTransOut = false;
							PlayState.instance.restart();
								
						}
						else
							{
									FlxG.resetState();
							}
				case "Skip Song":
					if (!FlxG.save.data.usedeprecatedloading)
						{
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
							    PlayState.instance.restart();
						}
						else
							{
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
							}
				case "Exit to storymode menu":
					PlayState.blueballed = 0;
					FlxG.timeScale = 1;
					FlxG.switchState(new StoryMenuState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
					Conductor.changeBPM(102);
					PlayState.triggeredalready = false;
					case "Exit to freeplay menu":
						#if web
						trace("Freeplay HTML5");
						PlayState.blueballed = 0;
						FlxG.switchState(new FreeplayStateHTML5());
						FlxG.timeScale = 1;
						PlayState.triggeredalready = false;
						#else
						PlayState.blueballed = 0;
						FlxG.switchState(new FreeplayState());
						trace("Freeplay Menu");
						FlxG.timeScale = 1;
						PlayState.triggeredalready = false;
						#end
						#if desktop 
				case "Change Speed":
				
					#else
					case "Change Speed":
					
					#end
				case "Exit to main menu":
					PlayState.blueballed = 0;
					FlxG.switchState(new MainMenuState());
					FlxG.timeScale = 1;
					PlayState.triggeredalready = false;
				case "Change Difficulty":
					menuItems = difficultyChoices;
					regenMenu();
				case "toggle practice mode":
					if (!practicemode)
						{
						  practicemode = true;
						  practice.x = 1010;
						  #if cpp
						  PlayState.practicemodeon = " - (PRACTICE MODE)";
						  #end
						}
						else
							{
								practicemode = false;
								#if cpp
								PlayState.practicemodeon = "";
								#end
							}		
				case "EASY" | "NORMAL" | "HARD":
					if (!FlxG.save.data.usedeprecatedloading)
						{
							PlayState.SONG = Song.loadFromJson(Highscore.formatSong(PlayState.SONG.song.toLowerCase(), curSelected),
							PlayState.SONG.song.toLowerCase());
						    PlayState.storyDifficulty = curSelected;
						    PlayState.instance.restart();
						    trace('changing difficulty to' + curSelected);
							PlayState.triggeredalready = false;
						}
						else
							{
									PlayState.SONG = Song.loadFromJson(Highscore.formatSong(PlayState.SONG.song.toLowerCase(), curSelected),
										PlayState.SONG.song.toLowerCase());
									PlayState.storyDifficulty = curSelected;
									FlxG.resetState();
									trace('changing difficulty to' + curSelected);
									PlayState.triggeredalready = false;
							}
							PlayState.triggeredalready = false;			
				case "BACK":
					if (StoryMenuState.isStoryMode && PlayState.storyPlaylist.length != 1)
						{
							menuItems = ['Resume', 'Restart Song', 'Skip Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to storymode menu', 'Exit to main menu'];
						}
						else if (StoryMenuState.isStoryMode)
							{
								menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to storymode menu', 'Exit to main menu'];
							}
							else
								{
									menuItems = ['Resume', 'Restart Song', 'Change Difficulty', 'toggle practice mode', 'Change Speed', 'Chart Editor', 'options', 'Exit to freeplay menu', 'Exit to main menu'];
								}
						if (isingameplay)
							{
								isingameplay = false;
							}
						if (isinappearance)
							{
								isinappearance = false;
							}
						if (isinkeybinds)
							{
								isinkeybinds = false;
								PlayerSettings.player1.controls.loadKeyBinds();
								trace('SAVED BINDS');
								FlxG.save.data.controls = true;
							}
						if (isinmisc)
							{
								isinmisc = false;
							}
						if (isinperformance)
							{
								isinperformance = false;
							}
					regenMenu();
				case "options":
					menuItems = ['GAMEPLAY', 'APPEARANCE', 'KEYBINDS', 'PERFORMANCE', 'MISC', 'BACK'];
					regenMenu();
				case "GAMEPLAY":
					remove(grpMenuShit);
					isingameplay = true;
					menuItems = CoolUtil.coolStringFile("\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + "\n" + (FlxG.save.data.middlescroll ? "middlescroll on" : "middlescroll off") + "\n" + (FlxG.save.data.ghosttapping ? "Ghost Tapping" : "No Ghost Tapping") + "\n" + (FlxG.save.data.oldinput ? "OLD INPUT ON" : "OLD INPUT OFF") + "\n" + (FlxG.save.data.antimash ? "anti mash ON" : " anti mash OFF") + "\n" + (FlxG.save.data.reset ? "RESET BUTTON ON" : "RESET BUTTON OFF") + "\n" + (FlxG.save.data.pausecount ? "pause counter on" : "pause counter off") + "\n" + (FlxG.save.data.repeat ? 'loop current song on' : 'loop current song off') + "\n" + (FlxG.save.data.hitsounds ? 'hitsounds on' : 'hitsounds off')  + "\n" + (FlxG.save.data.songspeed ? 'SET SCROLL SPEED ON' : 'SET SCROLL SPEED OFF') + "\n" + (FlxG.save.data.botplay ? 'BOTPLAY ON' : 'BOTPLAY OFF') + "\n" + (FlxG.save.data.missnotes ? 'miss sounds on' : 'miss sounds off') + "\n" + (FlxG.save.data.instantRespawn ? 'instant respawn on' : 'instant respawn off') + "\n" + "EDIT OFFSET" + "\n" + "BACK");
					trace(menuItems);		

					grpMenuShit = new FlxTypedGroup<Alphabet>();
					add(grpMenuShit);
			
					for (i in 0...menuItems.length)
					{
							var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
							songText.isMenuItem = true;
							songText.targetY = i;
							grpMenuShit.add(songText);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
			
					changeSelection();
				case "APPEARANCE":
					remove(grpMenuShit);
					isinappearance = true;
					menuItems =	CoolUtil.coolStringFile("\n" + (FlxG.save.data.hideHUD ? "HIDE HUD" : "DO NOT HIDE HUD") + "\n" + (FlxG.save.data.cinematic ? "cinematic MODE ON" : "cinematic MODE OFF") + "\n" + (FlxG.save.data.hittimings ? "MS Timing info ON" : "MS Timing info OFF") + "\n" + (FlxG.save.data.showratings ? "ratings info ON" : "ratings info OFF") + "\n" + (FlxG.save.data.songPosition ? "SONG POSITION ON" : "SONG POSITION off")+ "\n" + (FlxG.save.data.transparency ? "hold note transparency ON" : "hold note transparency off")+ "\n" + (FlxG.save.data.strumlights ? "CPU STRUM LIGHTS ON" : "CPU STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.playerstrumlights ? "PLAYER STRUM LIGHTS ON" : "PLAYER STRUM LIGHTS OFF")+ "\n" + (FlxG.save.data.camzooming ? "CAMERA ZOOMING ON" : "CAMERA ZOOMING OFF") + "\n" + (FlxG.save.data.watermarks ? "WATERMARKS ON" : "WATERMARKS OFF") + "\n" + (FlxG.save.data.nps ? "NPS ON" : "NPS OFF") + "\n" + (FlxG.save.data.healthcolor ? 'new healthbar on' : 'new healthbar off') + "\n" + (FlxG.save.data.newhealthheadbump ? 'new healthhead bump on' : 'new healthhead bump off') + "\n" + (FlxG.save.data.fps ? "FPS COUNTER ON" : "FPS COUNTER OFF") + "\n" + (FlxG.save.data.togglecap ? "FPS CAP ON" : "FPS CAP OFF") + "\n" + (FlxG.save.data.memoryMonitor ? "memoryMonitor ON" : "memoryMonitor OFF") + "\n" + (FlxG.save.data.middlecam ? "Camera focusing ON" : "camera focusing Off") + "\n" + (FlxG.save.data.camfollowspeedon ? "Camera speed modif on" : "Camera speed modif off") + "\n" + (FlxG.save.data.enablesickpositions ? 'custom rating position on' : 'custom rating position off') + "\n" + (FlxG.save.data.songinfo ? 'song info popup on' : 'song info popup off') + "\n" + (FlxG.save.data.combotext ? 'combo text on' : 'combo text off') + "\n" + "Customize Gameplay" + "\n" + "EDIT Scoretext preference" + "\n" + (FlxG.save.data.minscore ? 'old scoretext on' : 'old scoretext off') + "\n" + (FlxG.save.data.notesplashes ? 'notesplashes on' : 'notesplashes off') + "\n" + "BACK");
					trace(menuItems);		

					grpMenuShit = new FlxTypedGroup<Alphabet>();
					add(grpMenuShit);
			
					for (i in 0...menuItems.length)
					{
							var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
							songText.isMenuItem = true;
							songText.targetY = i;
							grpMenuShit.add(songText);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
					changeSelection();

					case "KEYBINDS":
						remove(grpMenuShit);
						isinkeybinds = true;
						curSelected = 0;
						menuItems = CoolUtil.coolStringFile(FlxG.save.data.leftBind + "\n" + FlxG.save.data.downBind + "\n" + FlxG.save.data.upBind + "\n" + FlxG.save.data.rightBind + "\n" + "reset-all" + "\n" + "BACK");
						trace(menuItems);		
	
						grpMenuShit = new FlxTypedGroup<Alphabet>();
						add(grpMenuShit);
				
						for (i in 0...menuItems.length)
						{
								var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
								songText.isMenuItem = true;
								songText.targetY = i;
								grpMenuShit.add(songText);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
						changeSelection();
						TitleState.keyCheck();
	                 	trace('CHECKING BINDS');
						trace('UR BINDS ARE:');
                        trace('${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}');

						case "PERFORMANCE":
						remove(grpMenuShit);
						isinperformance = true;
						curSelected = 0;
						if (ISDESKTOP)
							menuItems = CoolUtil.coolStringFile("\n" + (FlxG.save.data.antialiasing ? "Antialiasing on" : "Antialiasing off") + "\n" + (FlxG.save.data.optimizations ? "optimizations on" : "optimizations off") + "\n" + (FlxG.save.data.usedeprecatedloading ? "deprecated loading on" : "deprecated loading off" + "\n" + "BACK"));
							else
								menuItems = CoolUtil.coolStringFile("\n" + (FlxG.save.data.antialiasing ? "Antialiasing on" : "Antialiasing off") + "\n" + (FlxG.save.data.optimizations ? "optimizations on" : "optimizations off") + "\n" + (FlxG.save.data.usedeprecatedloading ? "deprecated loading on" : "deprecated loading off" + "\n" + "BACK"));
						trace(menuItems);
	
						grpMenuShit = new FlxTypedGroup<Alphabet>();
						add(grpMenuShit);
				
						for (i in 0...menuItems.length)
						{
								var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
								songText.isMenuItem = true;
								songText.targetY = i;
								grpMenuShit.add(songText);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
						changeSelection();

						case "MISC":
					remove(grpMenuShit);
					isinmisc = true;
					menuItems =	CoolUtil.coolStringFile("\n" + (FlxG.save.data.freeplaysongs ? 'freeplay song previews on' : 'freeplay song previews off') +"\n" + (FlxG.save.data.discordrpc ? 'discord presence on' : 'discord presence off') + "\n" + "BACK");
					trace(menuItems);		

					grpMenuShit = new FlxTypedGroup<Alphabet>();
					add(grpMenuShit);
			
					for (i in 0...menuItems.length)
					{
							var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
							songText.isMenuItem = true;
							songText.targetY = i;
							grpMenuShit.add(songText);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
					changeSelection();
					
				// gameplay shit
				case "Upscroll" | "Downscroll":
				    if (FlxG.save.data.downscroll)
						{
							FlxG.save.data.downscroll = false;
							PlayState.strumLine.y = 50;
							PlayState.restartedarrows = false;
							regengameplay();
						}
						else if (!FlxG.save.data.downscroll)
							{
								FlxG.save.data.downscroll = true;
								PlayState.strumLine.y = FlxG.height - 165;
								PlayState.restartedarrows = false;
								regengameplay();
							}
				case "BOTPLAY ON" | "BOTPLAY OFF":
				    if (FlxG.save.data.botplay)
						{
							FlxG.save.data.botplay = false;
							PlayState.botplaycheck();
							PlayState.addedbptext = true;
							regengameplay();
						}
						else if (!FlxG.save.data.botplay)
							{
								FlxG.save.data.botplay = true;
								PlayState.botplaycheck();
								PlayState.addedbptext = false;
								regengameplay();
							}		
				case "middlescroll on" | "middlescroll off":
				    if (FlxG.save.data.middlescroll)
						{
							FlxG.save.data.middlescroll = false;
							regengameplay();
						}
						else if (!FlxG.save.data.middlescroll)
							{
								FlxG.save.data.middlescroll = true;
								regengameplay();
							}
				case "Ghost Tapping" | "No Ghost Tapping":
				    if (FlxG.save.data.ghosttapping)
						{
							FlxG.save.data.ghosttapping = false;
							regengameplay();
						}
						else if (!FlxG.save.data.ghosttapping)
							{
								FlxG.save.data.ghosttapping = true;
								regengameplay();
							}
				case "OLD INPUT ON" | "OLD INPUT OFF":
				    if (FlxG.save.data.oldinput)
						{
							FlxG.save.data.oldinput = false;
							regengameplay();
						}
						else if (!FlxG.save.data.oldinput)
							{
								FlxG.save.data.oldinput = true;
								regengameplay();
							}
				case "anti mash ON" | "anti mash OFF":
				    if (FlxG.save.data.antimash)
						{
							FlxG.save.data.antimash = false;
							regengameplay();
						}
						else if (!FlxG.save.data.antimash)
							{
								FlxG.save.data.antimash = true;
								regengameplay();
							}			
				case "RESET BUTTON ON" | "RESET BUTTON OFF":
				    if (FlxG.save.data.reset)
						{
							FlxG.save.data.reset = false;
							regengameplay();
						}
						else if (!FlxG.save.data.reset)
							{
								FlxG.save.data.reset = true;
								regengameplay();
							}
				case "pause counter on" | "pause counter off":
				    if (FlxG.save.data.pausecount)
						{
							FlxG.save.data.pausecount = false;
							regengameplay();
						}
						else if (!FlxG.save.data.pausecount)
							{
								FlxG.save.data.pausecount = true;
								regengameplay();
							}
				case "loop current song on" | "loop current song off":
				    if (FlxG.save.data.repeat)
						{
							FlxG.save.data.repeat = false;
							regengameplay();
						}
						else if (!FlxG.save.data.repeat)
							{
								FlxG.save.data.repeat = true;
								regengameplay();
							}
				case "hitsounds on" | "hitsounds off":
				    if (FlxG.save.data.hitsounds)
						{
							FlxG.save.data.hitsounds = false;
							regengameplay();
						}
						else if (!FlxG.save.data.hitsounds)
							{
								FlxG.save.data.hitsounds = true;
								regengameplay();
							}
			    case "SET SCROLL SPEED ON" | "SET SCROLL SPEED OFF":
				    if (FlxG.save.data.songspeed)
						{
							FlxG.save.data.songspeed = false;
							PlayState.resetlength = true;
							regengameplay();
						}
						else if (!FlxG.save.data.songspeed)
							{
								FlxG.save.data.songspeed = true;
								PlayState.resetlength = true;
								regengameplay();
							}
				 case "miss sounds on" | "miss sounds off":
				    if (FlxG.save.data.missnotes)
						{
							FlxG.save.data.missnotes = false;
							regengameplay();
						}
						else if (!FlxG.save.data.missnotes)
							{
								FlxG.save.data.missnotes = true;
								regengameplay();
							}
				 case "instant respawn on" | "instant respawn off":
				    if (FlxG.save.data.instantRespawn)
						{
							FlxG.save.data.instantRespawn = false;
							regengameplay();
						}
						else if (!FlxG.save.data.instantRespawn)
							{
								FlxG.save.data.instantRespawn = true;
								regengameplay();
							}
				// appearance shit
				case "HIDE HUD" | "DO NOT HIDE HUD":
				    if (FlxG.save.data.hideHUD)
						{
							FlxG.save.data.hideHUD = false;
							PlayState.addedhealthbarshit = false;
							regenappearance();
						}
						else if (!FlxG.save.data.hideHUD)
							{
								FlxG.save.data.hideHUD = true;
								PlayState.addedhealthbarshit = true;
								regenappearance();
							}
				case "cinematic MODE ON" | "cinematic MODE OFF":
				    if (FlxG.save.data.cinematic)
						{
							FlxG.save.data.cinematic = false;
							regenappearance();
						}
						else if (!FlxG.save.data.cinematic)
							{
								FlxG.save.data.cinematic = true;
								regenappearance();
							}
				case "MS Timing info ON" | "MS Timing info OFF":
				    if (FlxG.save.data.hittimings)
						{
							FlxG.save.data.hittimings = false;
							regenappearance();
						}
						else if (!FlxG.save.data.hittimings)
							{
								FlxG.save.data.hittimings = true;
								regenappearance();
							}
				case "ratings info ON" | "ratings info OFF":
				    if (FlxG.save.data.showratings)
						{
							FlxG.save.data.showratings = false;
							PlayState.addedratingstext = true;
							regenappearance();
						}
						else if (!FlxG.save.data.showratings)
							{
								FlxG.save.data.showratings = true;
								PlayState.addedratingstext = false;
								regenappearance();
							}				
				case "SONG POSITION ON" | "SONG POSITION off":
				    if (FlxG.save.data.songPosition)
						{
							FlxG.save.data.songPosition = false;
							regenappearance();
						}
						else if (!FlxG.save.data.songPosition)
							{
								FlxG.save.data.songPosition = true;
								regenappearance();
							}
				case "hold note transparency ON" | "hold note transparency off":
				    if (FlxG.save.data.transparency)
						{
							FlxG.save.data.transparency = false;
							PlayState.resetalpha = true;
							regenappearance();
						}
						else if (!FlxG.save.data.transparency)
							{
								FlxG.save.data.transparency = true;
								PlayState.resetalpha = true;
								regenappearance();
							}
				case "CPU STRUM LIGHTS ON" | "CPU STRUM LIGHTS OFF":
				    if (FlxG.save.data.strumlights)
						{
							FlxG.save.data.strumlights = false;
							regenappearance();
						}
						else if (!FlxG.save.data.strumlights)
							{
								FlxG.save.data.strumlights = true;
								regenappearance();
							}
				case "PLAYER STRUM LIGHTS ON" | "PLAYER STRUM LIGHTS OFF":
				    if (FlxG.save.data.playerstrumlights)
						{
							FlxG.save.data.playerstrumlights = false;
							regenappearance();
						}
						else if (!FlxG.save.data.playerstrumlights)
							{
								FlxG.save.data.playerstrumlights = true;
								regenappearance();
							}
				case "CAMERA ZOOMING ON" | "CAMERA ZOOMING OFF":
				    if (FlxG.save.data.camzooming)
						{
							FlxG.save.data.camzooming = false;
							regenappearance();
						}
						else if (!FlxG.save.data.camzooming)
							{
								FlxG.save.data.camzooming = true;
								regenappearance();
							}
				case "WATERMARKS ON" | "WATERMARKS OFF":
				    if (FlxG.save.data.watermarks)
						{
							FlxG.save.data.watermarks = false;
							regenappearance();
						}
						else if (!FlxG.save.data.watermarks)
							{
								FlxG.save.data.watermarks = true;
								regenappearance();
							}
				case "NPS ON" | "NPS OFF":
				    if (FlxG.save.data.nps)
						{
							FlxG.save.data.nps = false;
							regenappearance();
						}
						else if (!FlxG.save.data.nps)
							{
								FlxG.save.data.nps = true;
								regenappearance();
							}
				case "new healthbar on" | "new healthbar off":
				    if (FlxG.save.data.healthcolor)
						{
							FlxG.save.data.healthcolor = false;
							PlayState.reloadhealthbar = true;
							regenappearance();
						}
						else if (!FlxG.save.data.healthcolor)
							{
								FlxG.save.data.healthcolor = true;
								PlayState.reloadhealthbar = true;
								regenappearance();
							}
				case "new healthhead bump on" | "new healthhead bump off":
				    if (FlxG.save.data.newhealthheadbump)
						{
							FlxG.save.data.newhealthheadbump = false;
							regenappearance();
						}
						else if (!FlxG.save.data.newhealthheadbump)
							{
								FlxG.save.data.newhealthheadbump = true;
								regenappearance();
							}
				case "FPS COUNTER ON" | "FPS COUNTER OFF":
				    if (FlxG.save.data.fps)
						{
							FlxG.save.data.fps = false;
							regenappearance();
							(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
						}
						else if (!FlxG.save.data.fps)
							{
								FlxG.save.data.fps = true;
								regenappearance();
								(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
							}
				case "FPS CAP ON" | "FPS CAP OFF":
					if (FlxG.save.data.togglecap)
						{
							FlxG.save.data.togglecap = false;
							(cast (Lib.current.getChildAt(0), Main)).setFPSCap(138);
							FlxG.updateFramerate = 138;
							FlxG.drawFramerate = 138;
							regenappearance();
						}
					else if (!FlxG.save.data.togglecap)
						{
							FlxG.save.data.togglecap = true;
							(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
							FlxG.updateFramerate = FlxG.save.data.fpsCap;
							FlxG.drawFramerate = FlxG.save.data.fpsCap;
							regenappearance();
						}
				case "Camera focusing ON" | "camera focusing Off":
					if (FlxG.save.data.middlecam)
						{
							FlxG.save.data.middlecam = false;
							regenappearance();
						}
					else if (!FlxG.save.data.middlecam)
						{
							FlxG.save.data.middlecam = true;
							regenappearance();	
						}
			    case "Camera speed modif on" | "Camera speed modif off":
					if (FlxG.save.data.camfollowspeedon)
						{
							FlxG.save.data.camfollowspeedon = false;
							regenappearance();
						}
					else if (!FlxG.save.data.camfollowspeedon)
						{
							FlxG.save.data.camfollowspeedon = true;
							regenappearance();	
						}			
				case "memoryMonitor ON" | "memoryMonitor OFF":
				    if (FlxG.save.data.memoryMonitor)
						{
							FlxG.save.data.memoryMonitor = false;
							regenappearance();
							(cast (Lib.current.getChildAt(0), Main)).togglememoryMonitor(FlxG.save.data.memoryMonitor);
						}
						else if (!FlxG.save.data.memoryMonitor)
							{
								FlxG.save.data.memoryMonitor = true;
								regenappearance();
								(cast (Lib.current.getChildAt(0), Main)).togglememoryMonitor(FlxG.save.data.memoryMonitor);
							}
				case "custom rating position on" | "custom rating position off":
				    if (FlxG.save.data.enablesickpositions)
						{
							FlxG.save.data.enablesickpositions = false;
							regenappearance();
						}
						else if (!FlxG.save.data.enablesickpositions)
							{
								FlxG.save.data.enablesickpositions = true;
								regenappearance();
							}
				case "song info popup on" | "song info popup off":
				    if (FlxG.save.data.songinfo)
						{
							FlxG.save.data.songinfo = false;
							regenappearance();
						}
						else if (!FlxG.save.data.songinfo)
							{
								FlxG.save.data.songinfo = true;
								regenappearance();
							}
				case "combo text on" | "combo text off":
				    if (FlxG.save.data.combotext)
						{
							FlxG.save.data.combotext = false;
							regenappearance();
						}
						else if (!FlxG.save.data.combotext)
							{
								FlxG.save.data.combotext = true;
								regenappearance();
							}
				case "notesplashes on" | "notesplashes off":
				    if (FlxG.save.data.notesplashes)
						{
							FlxG.save.data.notesplashes = false;
							regenappearance();
						}
						else if (!FlxG.save.data.notesplashes)
							{
								FlxG.save.data.notesplashes = true;
								regenappearance();
							}			
				case "Customize Gameplay":
				LoadingStateRemovedSongs.loadAndSwitchState(new GameplayCustomizeState());
				case "EDIT Scoretext preference":
				FlxG.switchState(new ScoretextselectState());
				case "old scoretext on" | "old scoretext off":
				    if (FlxG.save.data.minscore)
						{
							FlxG.save.data.minscore = false;
							regenappearance();
						}
						else if (!FlxG.save.data.minscore)
							{
								FlxG.save.data.minscore = true;
								regenappearance();
							}					
				// PERFORMANCE SHIT	
				case "Antialiasing on" | "Antialiasing off":
				    if (FlxG.save.data.antialiasing)
						{
							FlxG.save.data.antialiasing = false;
							regenperformance();
						}
						else if (!FlxG.save.data.antialiasing)
							{
								FlxG.save.data.antialiasing = true;
								regenperformance();
							}
				case "optimizations on" | "optimizations off":
				    if (FlxG.save.data.optimizations)
						{
							FlxG.save.data.optimizations = false;
							regenperformance();
						}
						else if (!FlxG.save.data.optimizations)
							{
								FlxG.save.data.optimizations = true;
								regenperformance();
							}
			    case "deprecated loading on" | "deprecated loading off":
				    if (FlxG.save.data.usedeprecatedloading)
						{
							FlxG.save.data.usedeprecatedloading = false;
							regenperformance();
						}
						else if (!FlxG.save.data.usedeprecatedloading)
							{
								FlxG.save.data.usedeprecatedloading = true;
								regenperformance();
							}
                case "freeplay song previews on" | "freeplay song previews off":
				    if (FlxG.save.data.freeplaysongs)
						{
							FlxG.save.data.freeplaysongs = false;
							regenmisc();
						}
						else if (!FlxG.save.data.freeplaysongs)
							{
								FlxG.save.data.freeplaysongs = true;
								regenmisc();
							}
                case "discord presence on" | "discord presence off":
				    if (FlxG.save.data.discordrpc)
						{
							FlxG.save.data.discordrpc = false;
							regenmisc();
							#if cpp
							DiscordClient.shutdown();
						    #end
						}
						else if (!FlxG.save.data.discordrpc)
							{
								FlxG.save.data.discordrpc = true;
								regenmisc();
								#if cpp
								DiscordClient.initialize();
								#end
							}
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		if (abletochange)
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
		
					item.alpha = 0.6;
					// item.setGraphicSize(Std.int(item.width * 0.8));
		
					if (item.targetY == 0)
					{
						item.alpha = 1;
						// item.setGraphicSize(Std.int(item.width));
					}
				}
			}
	}

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}

		function waitingInputup():Void
			{
				///THIS KEYBINDSTATE TOOK ME LIKE 2 FUCKING DAYS TO MAKE
				///FUCKKKKKKK
				if (FlxG.keys.justPressed.ANY)
				{
					PlayerSettings.player1.controls.replaceBinding(Control.UP, Keys, FlxG.keys.getIsDown()[0].ID, null);
					FlxG.save.data.upBind = FlxG.keys.getIsDown()[0].ID.toString();
					trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
					trace(FlxG.save.data.upBind + " | SET KEY");
					isSettingControlup = false;
					new FlxTimer().start(0.01, function(tmr:FlxTimer)
						{
							abletochange = true;
							remove(keyalphabet);
							keyalphabet.remove(aming);
							remove(aming);
							regenkeybinds();
							#if desktop
							// Updating Discord Rich Presence
							//DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
							#end
						});
				}
				// PlayerSettings.player1.controls.replaceBinding(Control)
			}
	
			function waitingInputdown():Void
				{
					if (FlxG.keys.justPressed.ANY)
					{
						PlayerSettings.player1.controls.replaceBinding(Control.DOWN, Keys, FlxG.keys.getIsDown()[0].ID, null);
						FlxG.save.data.downBind = FlxG.keys.getIsDown()[0].ID.toString();
						trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
						trace(FlxG.save.data.downBind + " | SET KEY");
						isSettingControldown = false;
						new FlxTimer().start(0.01, function(tmr:FlxTimer)
							{
								abletochange = true;
								remove(keyalphabet);
								keyalphabet.remove(aming);
								remove(aming);
								regenkeybinds();
								#if desktop
								// Updating Discord Rich Presence
								//DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
								#end
							});
					}
					// PlayerSettings.player1.controls.replaceBinding(Control)
				}
	
	
				function waitingInputleft():Void
					{
						if (FlxG.keys.justPressed.ANY)
						{
							PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxG.keys.getIsDown()[0].ID, null);
							FlxG.save.data.leftBind = FlxG.keys.getIsDown()[0].ID.toString();
							trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
							trace(FlxG.save.data.leftBind + " | SET KEY");
							isSettingControlleft = false;
							new FlxTimer().start(0.01, function(tmr:FlxTimer)
								{
									abletochange = true;
									remove(keyalphabet);
									keyalphabet.remove(aming);
									remove(aming);
									regenkeybinds();
									#if desktop
									// Updating Discord Rich Presence
									//DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
									#end
								});
						}
						// PlayerSettings.player1.controls.replaceBinding(Control)
					}
	
	
					function waitingInputright():Void
						{
							if (FlxG.keys.justPressed.ANY)
							{
								PlayerSettings.player1.controls.replaceBinding(Control.RIGHT, Keys, FlxG.keys.getIsDown()[0].ID, null);
								FlxG.save.data.rightBind = FlxG.keys.getIsDown()[0].ID.toString();
								trace(FlxG.keys.getIsDown()[0].ID + " | PRESSED KEY");
								trace(FlxG.save.data.rightBind + " | SET KEY");
								isSettingControlright = false;
								new FlxTimer().start(0.01, function(tmr:FlxTimer)
									{
										abletochange = true;
										remove(keyalphabet);
										keyalphabet.remove(aming);
										remove(aming);
										regenkeybinds();
										#if desktop
										// Updating Discord Rich Presence
										//DiscordClient.changePresence("Rebinding Keys to " + '${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind}', null);
										#end
									});
							}
							// PlayerSettings.player1.controls.replaceBinding(Control)
						}
}
