package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
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

	var magenta:FlxSprite;
	var logoBl:FlxSprite;
	var logo:FlxSprite;
	var camFollow:FlxObject;
	var bg:FlxSprite;
	var versionShit:FlxText;
	var playanims:Bool = false;
	public static var sniperengineversion:String = " Sniper Engine 2.8";
	public static var sniperengineversionA:String = " SE 2.8";
	public static var gameVer:String = "v0.2.7.1";
	public static var nightly:String = " | nightly 6";

	override function create()
	{

		/*if (FlxG.random.bool(2))
			{
				sniperengineversion = " Sniper Engine 2.7 | LIAM IS STUPID";
				trace('stupid liam');
			*///}
			///so I don't get canceled


			if (FlxG.random.bool(2))
				{
					nightly = "| nightly 6 | hi jacob";
					trace('jacob');
				}


			
		#if desktop
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


		logo = new FlxSprite(750, 220).loadGraphic(Paths.image('logo'));
		logo.antialiasing = true;
		logo.setGraphicSize(Std.int(logo.width + 100));
		logo.setGraphicSize(Std.int(logo.height + 100));	
		logo.updateHitbox();
		logo.scrollFactor.set();
		logo.cameras = [FlxG.camera];
		logo.x += 1000;
		add(logo);
		FlxTween.tween(logo, {x: logo.x - 1000, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
	    FlxTween.angle(logo, logo.angle, 4, 4, {ease: FlxEase.quartInOut});
		new FlxTimer().start(0.50, function(tmr:FlxTimer)
			{
				if(logo.angle == -4) 
					FlxTween.angle(logo, logo.angle, 4, 4, {ease: FlxEase.quartInOut});
				if (logo.angle == 4) 
					FlxTween.angle(logo, logo.angle, -4, 4, {ease: FlxEase.quartInOut});
			}, 0);
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

          	logoBl = new FlxSprite(680, 100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.setGraphicSize(Std.int(logoBl.width - 50));
		logoBl.setGraphicSize(Std.int(logoBl.height - 50));	
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.scrollFactor.set();
		logoBl.cameras = [FlxG.camera];
		logoBl.x += 1000;
		add(logoBl);
		FlxTween.tween(logoBl, {x: logoBl.x - 1000, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
		///FlxTween.tween(logoBl, {y: 325 }, 2, { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut, startDelay: 1, loopDelay: 0.0});
	    FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
		new FlxTimer().start(0.50, function(tmr:FlxTimer)
			{
				if(logoBl.angle == -4) 
					FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
				if (logoBl.angle == 4) 
					FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
			}, 0);
		}
			
		// magenta.scrollFactor.set();                                          //////quadInOut            ///1

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
			{
				var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));///160
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = i;
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

		var versionShit:FlxText = new FlxText(400, FlxG.height - 18, 0, gameVer + " FNF |" + sniperengineversion + nightly, 12);
		versionShit.scrollFactor.set();
		versionShit.x -= 1000;
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		FlxTween.tween(versionShit, {x: versionShit.x + 1000, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
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
		if(code=="secret"){
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			FlxG.switchState(new SilvaFreeplayState());
		}
	}

	override function update(elapsed:Float)
	{
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
					FlxG.sound.play(Paths.sound('confirmMenu'));
				    ///FlxTween.tween(versionShit, {y: versionShit.y + 1000, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 1.0});
				    ///trace('playing anim');

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							playanims = true;
							FlxTween.tween(spr, {y: spr.y + 500}, 1, {ease: FlxEase.circOut, startDelay: 0.2});
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
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Menu Selected");	
									
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
			
			
		}
}
