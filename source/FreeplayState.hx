package;

#if cpp
import Discord.DiscordClient;
#end
import flash.text.TextField;
import Song.SwagSong;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = []; ///all bpms up to thorns, add your song BPM in order of them in freeplay.
	var beatArray:Array<Int> = [100,100,120,180,150,165,95,150,175,165,110,125,180,100,150,159,144,120,190,150];

	var selector:FlxText;
	var curSelected:Int = FlxG.save.data.curselected;
	var curDifficulty:Int = FlxG.save.data.curdifficulty;
	var icon:HealthIcon;
	var scoreText:FlxText;
	var diffText:FlxText;
	var speedtext:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var songWait:FlxTimer = new FlxTimer();
	var defaultCamZoom:Float = 1.05;
	var infotext:FlxText;
	public static var gamespeed:Float = 1.0;
	public static var voices:FlxSound;
	public static var voicesplaying:Bool = false;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var camZooming:Bool = false;
	var playingist:Bool = false;

	var startTimer:FlxTimer;

	var camZoom:FlxTween;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		PlayState.triggeredalready = false;
		if (FlxG.save.data.curselected == null)
			FlxG.save.data.curselected = "0";

		if (FlxG.save.data.curdifficulty == null)
			FlxG.save.data.curdifficulty = "1";
		trace('default selected: ' + FlxG.save.data.curselected);
		trace('default difficulty: ' + FlxG.save.data.curdifficulty);


		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			songs.push(new SongMetadata(initSonglist[i], 1, 'gf'));
		}

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */


		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);
		addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);
		addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico']);

		addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);
		addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas']);
		
		addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit']);
		// LOAD MUSIC

		// LOAD CHARACTERS
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		if (FlxG.save.data.optimizations)
		bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue-opt'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
                                           //0.7
		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;
                                                                                                  ///////66
		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 110, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		speedtext = new FlxText(diffText.x, diffText.y + 36, "SPEED: " + gamespeed, 24);
		speedtext.font = diffText.font;
		add(speedtext);
		                                                    //18
		var scoreBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);
		#if PRELOAD_ALL
		infotext = new FlxText(5, FlxG.height - 18, 0, "Press V to toggle vocals for a song / hold down shift + left or right to change song speed.", 12);
		#else
		infotext = new FlxText(5, FlxG.height - 18, 0, "hold down shift + left or right to change song speed.", 12);
		#end
		infotext.scrollFactor.set();
		infotext.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(infotext);

		changeSelection();
		changeDiff();

		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Freeplay song list", null);
		#end

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function stepHit()
		{
			super.stepHit();
			if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			{
				#if PRELOAD_ALL
				if (voicesplaying)
				voices.time = Conductor.songPosition;
				#end
			}
		}

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		///if (curSelected != 4)


		super.update(elapsed);
        #if cpp
		if (FlxG.sound.music.playing)
			{
				if (gamespeed != 1)
					{
							if (gamespeed > 1)
								{
									@:privateAccess
									{
										if (FlxG.sound.music.playing)
										lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, gamespeed);
										if (voicesplaying)
											lime.media.openal.AL.sourcef(voices._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, gamespeed);
										//sniper gaming looking for a way to pitch vocals without cpp
									}
									///trace("pitched inst and vocals to " + FlxG.timeScale);
								 
								}			
					}

					if (gamespeed == 1)
						{
							@:privateAccess
							{
								if (FlxG.sound.music.playing)
								lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, 1);
								if (voicesplaying)
									lime.media.openal.AL.sourcef(voices._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, 1);
								//sniper gaming looking for a way to pitch vocals without cpp
							}
						}

					if (gamespeed < 1)
						{
							{
								@:privateAccess
								{
									if (FlxG.sound.music.playing)
									lime.media.openal.AL.sourcef(FlxG.sound.music._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, gamespeed);
									if (voicesplaying)
										lime.media.openal.AL.sourcef(voices._channel.__source.__backend.handle, lime.media.openal.AL.PITCH, gamespeed);
									//sniper gaming looking for a way to pitch vocals without cpp
								}
								///trace("pitched inst and vocals to " + gamespeed);
							}
						}
				
			}
		#end


		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		///var accepted = controls.ACCEPT;

		if (controls.RIGHT_R && FlxG.keys.pressed.SHIFT)
			{
				gamespeed += 0.1;
				trace(gamespeed);
			speedtext.text = "SPEED: " + gamespeed;
			#if cpp
			// Updating Discord Rich Presence
			DiscordClient.changePresence("Thinking about playing " + songs[curSelected].songName.toLowerCase() + " " + (curDifficulty == 2 ? "Hard" : curDifficulty == 1 ? "Normal" : "Easy") + " on a speed of " + gamespeed + " (In the freeplay menu)", null);
			#end
			}

			if (controls.LEFT_R && FlxG.keys.pressed.SHIFT)
				{
					gamespeed -= 0.1;
				trace(gamespeed);
			    speedtext.text = "SPEED: " + gamespeed;
				#if cpp
				// Updating Discord Rich Presence
				DiscordClient.changePresence("Thinking about playing " + songs[curSelected].songName.toLowerCase() + " " + (curDifficulty == 2 ? "Hard" : curDifficulty == 1 ? "Normal" : "Easy") + " on a speed of " + gamespeed + " (In the freeplay menu)", null);
				#end
			 	}

		if (upP)
		{
			changeSelection(-1);
			if (!FlxG.save.data.freeplaysongs && FlxG.sound.music.playing  && playingist)
					{
						FlxG.sound.music.stop();
					}
		}
		if (downP)
		{
			changeSelection(1);
			if (!FlxG.save.data.freeplaysongs && FlxG.sound.music.playing && playingist)
				{
					FlxG.sound.music.stop();
				}
		}

		if (controls.LEFT_P && !FlxG.keys.pressed.SHIFT)
			changeDiff(-1);
		if (controls.RIGHT_P && !FlxG.keys.pressed.SHIFT)
			changeDiff(1);
		#if cpp
		if(FlxG.keys.justPressed.V && FlxG.sound.music.playing && FlxG.save.data.freeplaysongs)
			{
				var voice = Paths.voices(songs[curSelected].songName);
				if (!voicesplaying && Paths.doesSoundAssetExist(voice))
					{
						trace('voices exist!');	
							{
									{
										voices = new FlxSound().loadEmbedded(Paths.voices(songs[curSelected].songName));
										voices.onComplete = stopPlaying;
										voicesplaying = true;
										trace('IS PLAYING ' + voicesplaying);
										voices.play();
										Conductor.changeBPM(beatArray[curSelected]);
										trace(Conductor.bpm);
									}
							}
					}
					else if (voices.playing)
						{
							voices.stop();
							voicesplaying = false;
							trace('stop i hate you');
						}
						else
						trace('NO VOICES');			
			}
			#end

		if (controls.BACK)
		{
			Conductor.changeBPM(beatArray[curSelected]);
			FlxG.switchState(new MainMenuState());
		}


		if (controls.ACCEPT)
		{
			accepted = false;
			if(voicesplaying)
				{
					voicesplaying = false;
					voices.stop();
				}
			
					{
						var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

						trace(poop);
			
						PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
						StoryMenuState.isStoryMode = false;
						PlayState.storyDifficulty = curDifficulty;
			
						PlayState.storyWeek = songs[curSelected].week;
						trace('CUR WEEK' + PlayState.storyWeek);
						LoadingState.loadAndSwitchState(new PlayState());
					}
						
		}

	}

	override public function onFocusLost():Void
		{
			#if PRELOAD_ALL
			if (voicesplaying)
            voices.pause();
			#end
			
			super.onFocusLost();
		}

		override public function onFocus():Void
			{
				#if PRELOAD_ALL
				if (voicesplaying)
					{
						voices.play();	
					}
				#end	

			   super.onFocus();
			}

	function stopPlaying():Void
		{
			voicesplaying = false;
		}		

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		FlxG.save.data.curdifficulty = curDifficulty;

		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Thinking about playing " + songs[curSelected].songName.toLowerCase() + " " + (curDifficulty == 2 ? "Hard" : curDifficulty == 1 ? "Normal" : "Easy") + " on a speed of " + gamespeed + " (In the freeplay menu)", null);
		#end

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "  EASY   >";
			case 1:
				diffText.text = '< NORMAL >';
			case 2:
				diffText.text = "< HARD ";
		}
	}

	override function beatHit()
		{
			super.beatHit();

		#if PRELOAD_ALL
		if (voicesplaying)
		voices.time = Conductor.songPosition;
		#end

		
			if (accepted)
				{
					bopOnBeat();
					///iconBop();
					trace(curBeat);
				}
		}

		function bopOnBeat()
			{
				if (accepted)
				{
					if (FlxG.save.data.camzooming)
						{
							if (curSelected == 12)
								{
									
		
											trace('milf');
											if (curBeat % 1 == 0)
												{
													if (curBeat >= 8 && curBeat < 373)
													{
														FlxG.camera.zoom += 0.030;
														camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
													}
		
													if (curBeat >= 168 && curBeat < 200)
														{
																{
																	FlxG.camera.zoom += 0.030;
																}
														}
												}
		
							
										
								}
								else if (curSelected == 18)
									{
												trace('Thorns');
												if (curBeat % 2 == 0)
													{
														FlxG.camera.zoom += 0.015;
														camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
													}		
									}
								else if (curSelected == 9)
									{
										
											
									trace('blammed');
									if (curBeat % 4 == 0)
										{
											FlxG.camera.zoom += 0.015;
											camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
										}
								
											
									}
									else if (curSelected == 0)
										{
													if (curBeat % 4 == 0)
														{
															FlxG.camera.zoom += 0.015;
															camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
														}
										
										}
									else if (curBeat % 4 == 0)
										{
											FlxG.camera.zoom += 0.015;
											camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
										}
						}
				}
			}

	var accepted:Bool = true;

	function changeSelection(change:Int = 0)
	{
		if (voicesplaying)
			{
				voicesplaying = false;
				voices.stop();	
			}

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;
		FlxG.save.data.curselected = curSelected;
		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
				{
					var inst = Paths.inst(songs[curSelected].songName);
						if (FlxG.save.data.freeplaysongs && Paths.doesSoundAssetExist(inst))
							{
								FlxG.sound.music.stop();
								songWait.cancel();
								songWait.start(1, function(tmr:FlxTimer) {
								FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
								playingist = true;
								Conductor.changeBPM(beatArray[curSelected]);
								trace(Conductor.bpm);
								});
							}
				}
		#end
		trace('current selection: ' + curSelected);
		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Thinking about playing " + songs[curSelected].songName.toLowerCase() + " " + (curDifficulty == 2 ? "Hard" : curDifficulty == 1 ? "Normal" : "Easy") + " on a speed of " + gamespeed + " (In the freeplay menu)", null);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}


		///curSelected = FlxG.save.data.curselected;

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			#if cpp
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

		
	/*function iconBop(?_scale:Float = 1.25, ?_time:Float = 0.2):Void {
		iconArray[curSelected].iconScale = iconArray[curSelected].defualtIconScale* _scale;
	
	
		FlxTween.tween(iconArray[curSelected], {iconScale: iconArray[curSelected].defualtIconScale}, _time, {ease: FlxEase.quintOut});
		
	*///}
}   

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
