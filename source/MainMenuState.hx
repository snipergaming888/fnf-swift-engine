package;

#if cpp
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import flash.events.KeyboardEvent;
import flixel.util.FlxTimer;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var text:FlxTypedGroup<FlxText>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	#end
	var voices:FlxSound;
	var magenta:FlxSprite;
	var logoBl:FlxSprite;
	var logo:FlxSprite;
	var camFollow:FlxObject;
	var bg:FlxSprite;
	var versionShit:FlxText;
	var playanims:Bool = false;
	var defaultCamZoom:Float = 1.05;
	var camZoom:FlxTween;
	public static var sniperengineversion:String = " Swift Engine 1.4.7";
	public static var sniperengineversionA:String = " SE 1.4.7";
	public static var gameVer:String = "v0.2.7.1";
	public static var nightly:String = "";
	public static var testbuild:String = "PUBLIC TEST BUILD";
	
	override function create()
	{	
		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		if (TitleState.old)
			{
				if (!FlxG.sound.music.playing)
				{
					FlxG.sound.playMusic(Paths.music('title'), 0);
					Conductor.changeBPM(92);
				}
				else
					{
					   ///nothing?
					}
			}
			else
				{
					if (!FlxG.sound.music.playing)
						{	
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							Conductor.changeBPM(102);
						}
				}

		persistentUpdate = persistentDraw = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		if (TitleState.old)
	{
		trace ('old');
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
	}
	else
		{
			var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0.18;
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;
			add(bg);
		}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		
			for (i in 0...optionShit.length)
				{
					var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
					menuItem.frames = tex;
					menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
					menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
					menuItem.animation.play('idle');
					menuItem.ID = i;
					menuItem.screenCenter(X);
					menuItems.add(menuItem);
					menuItem.scrollFactor.set();
					menuItem.antialiasing = true;
					menuItem.y -= 1000;
					FlxTween.tween(menuItem, {y: menuItem.y + 1000, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
				}
			
		
			new FlxTimer().start(0.001, function(tmr:FlxTimer)
				{
					FlxG.camera.follow(magenta, null, 0.06);
					new FlxTimer().start(1.0, function(tmr:FlxTimer)
						{
							optionShit[curSelected] == 'freeplay';
							camFollow.setPosition(magenta.getGraphicMidpoint().x, magenta.getGraphicMidpoint().y);
							FlxG.camera.follow(camFollow, null, 0.06);
						});
				});
				FlxG.camera.follow(camFollow, null, 0.06);	

		var versionShit:FlxText = new FlxText(350, FlxG.height - 18, 0, gameVer + " FNF |" + sniperengineversion + " | Press C to view changelog", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);	

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);

		super.create();
	}

	var selectedSomethin:Bool = false;
	var code = '';
	var keyTimer:Float =0;

	function onKeyDown(event:KeyboardEvent):Void{
		code = code + String.fromCharCode(event.charCode);
		keyTimer=2;
		if(code=="whatdadogdoin"){
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			FlxG.sound.music.stop();
			FlxG.switchState(new VideoState('assets/videos/dog/very-serious-question.webm', new CrashState()));
		}
	}

	override function update(elapsed:Float)
	{


		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		if(keyTimer>0){
			keyTimer-=elapsed;
		}
		if(keyTimer<=0){
			keyTimer=0;
			code="";
		}	
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				if (TitleState.old)
					{
						FlxG.switchState(new TitleStateOld());
					}
				FlxG.switchState(new TitleState());
			}

			if (FlxG.keys.justPressed.C)
				{
					FlxG.switchState(new ChangelogSubState());
					FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
					accepted = true;
				}

			if (controls.ACCEPT)
			{	
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					accepted = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
				    ///FlxTween.tween(versionShit, {y: versionShit.y + 1000, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 1.0});
				    ///trace('playing anim');

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							playanims = true;
							FlxTween.tween(spr, {y: spr.y + 1700}, 1, {ease: FlxEase.circOut, startDelay: 0.2});
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut, onComplete: function(twn:FlxTween)
									{
									}});						
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");

									case 'freeplay':
										FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
										#if web
										FlxG.switchState(new FreeplayStateHTML5());
										trace("Freeplay HTML5 Menu Selected");
										#else
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Menu Selected");
										#end	
									
									case 'options':
										FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
										FlxG.switchState(new MenuState());
										trace("Options Menu Selected");
	

										FlxG.switchState(new MenuState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
			{
				spr.screenCenter(X);
			});

	}

	override public function onFocusLost():Void
		{
			#if PRELOAD_ALL
			if (FreeplayState.voicesplaying)
            FreeplayState.voices.pause();
			#end
			
			super.onFocusLost();
		}

		override public function onFocus():Void
			{
				#if PRELOAD_ALL
				if (FreeplayState.voicesplaying)
					{
						FreeplayState.voices.play();	
					}
				#end	

			   super.onFocus();
			}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}


	override function beatHit()
		{
			super.beatHit();


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
					if (Conductor.bpm == 180 && curBeat >= 168 && curBeat < 200)
						{
							if (curBeat % 1 == 0)
								{
									FlxG.camera.zoom += 0.030;
								}
						}
						    if (curBeat % 1 == 0)
						    	{
									if (TitleState.old)
										{
											trace('no');
										}
										else if (FlxG.save.data.camzooming)
											{
												FlxG.camera.zoom += 0.015;
												camZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 0.1);
												trace('zoom');
											}
											else
											{
												trace('no');
											}
							    }
				}
			}

	var accepted:Bool = true;
}
