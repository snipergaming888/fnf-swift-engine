package;

#if cpp
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;

class MenuState extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var camZoom:FlxTween;
	var CYAN:FlxColor = 0xFF00FFFF;
	public static var desc:FlxText;
	var voices:FlxSound;
	public static var descBG:FlxSprite;
	var sex:Array<String> = ['GAMEPLAY', 'APPEARANCE', 'KEYBINDS', 'PERFORMANCE', 'MISC'];
	override function create()
	{
		
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		if (FlxG.save.data.optimizations)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat-opt'));
		#if web
		sex = CoolUtil.coolStringFile('GAMEPLAY' + "\n" + "APPEARANCE" + "\n" + "KEYBINDS" + "\n" + "PERFORMANCE");
		#else
		sex = CoolUtil.coolStringFile('GAMEPLAY' + "\n" + "APPEARANCE" + "\n" + "KEYBINDS" + "\n" + "PERFORMANCE" + "\n" + "MISC");
		#end
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		/*for (i in 0...controlsStrings.length)
		{                                                  //70
				var controlLabel:Alphabet = new Alphabet(0, (1 * i) + 1, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}*/

	         
		
		for (i in 0...sex.length)
			{                                  //100
			var ctrl:Alphabet = new Alphabet(0, (80 * i) + 60, sex[i], true, false);
		    ctrl.ID = i;
			ctrl.y += 102;
			ctrl.screenCenter(X);
		    grpControls.add(ctrl);
			}//70
				// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			

		descBG = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		if(!FlxG.save.data.hasplayed)
		descBG.y += 100;
		descBG.screenCenter(X);
		add(descBG);
		if (!FlxG.save.data.hasplayed)
		FlxTween.tween(descBG, {y: descBG.y -100, alpha: 0.6}, 1, {ease: FlxEase.circOut, startDelay: 0.3});

		desc = new FlxText(5, FlxG.height - 18, 0, "", 12);
		desc.scrollFactor.set();
		desc.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if(!FlxG.save.data.hasplayed)
		desc.y += 100;
		add(desc);
		if (!FlxG.save.data.hasplayed)
			{
				FlxTween.tween(desc, {y: desc.y -100, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.3});
				FlxG.save.data.hasplayed = true;	
			}

		///so shit gets highlighted

		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Options Menu", null);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				{
					FlxG.save.data.hasplayed = false;
					FlxTransitionableState.skipNextTransIn = false;
					FlxTransitionableState.skipNextTransOut = false;
			        FlxG.switchState(new MainMenuState());
				}
			if (controls.BACK)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);	
				}

			if (curSelected == 0)
				desc.text = "In-game options menu.";

			if (curSelected == 1)
				desc.text = "In-game appearance menu.";

			if (curSelected == 2)
				desc.text = "Configure your keybinds.";

			if (curSelected == 3)
				desc.text = "In-game performance menu.";

			if (curSelected == 4)
				desc.text = "miscellaneous options menu.";

			if (controls.UP_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected -= 1;
				}
	
			if (controls.DOWN_P)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curSelected += 1;
				}
	
			if (curSelected < 0)
				curSelected = 0;
			#if web
			if (curSelected > 4)
				curSelected = 4;
			#else
			if (curSelected > 4)
				curSelected = 4;
			#end

			grpControls.forEach(function(sex:Alphabet)
				{
		
					if (sex.ID == curSelected)
						sex.alpha = 1;
					else
						sex.alpha = 0.7;
				});
			

			if (controls.ACCEPT)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				switch(curSelected)
				{
					case 0:
						FlxG.switchState(new GameOptions());
					case 1:
						FlxG.switchState(new ApperanceOptions());
					case 2:
						FlxG.switchState(new OptionsMenu());
					case 3:
						FlxG.switchState(new PerformanceOptions());
					case 4:
						FlxG.switchState(new MiscOptions());
				}
			}
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

	var isSettingControl:Bool = false;



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
