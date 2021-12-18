package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
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
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;

class MiscOptions extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var CYAN:FlxColor = 0xFF00FFFF;
	var camZoom:FlxTween;
	var popup:Bool = false;
	var aming:Alphabet;
	var ok:Alphabet;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	var descBG:FlxSprite;
	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));	
		controlsStrings = CoolUtil.coolStringFile("\n" + (FlxG.save.data.freeplaysongs ? 'freeplay song previews on' : 'freeplay song previews off') +"\n" + (FlxG.save.data.discordrpc ? 'discord presence on' : 'discord presence off') +"\n" + (FlxG.save.data.idleafterhold ? 'idle after hold note' : 'Dont idle after hold note'));
		
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
				controlLabel.screenCenter(X);
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		var descBG:FlxSprite = new FlxSprite(0,  FlxG.height - 18).makeGraphic(Std.int(FlxG.width), 110, 0xFF000000);
		descBG.alpha = 0.6;
		descBG.screenCenter(X);
		add(descBG);

		versionShit = new FlxText(5, FlxG.height - 18, 0, "", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeSelection();
		///so shit gets highlighted


		var aming:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('this-setting-will-apply-on-restart'), true, false);
		aming.isMenuItem = false;
		aming.targetY = curSelected - 0;
		aming.screenCenter(X);

		var ok:Alphabet = new Alphabet(0, (70 * curSelected) + 30, ('ok'), true, false);
		ok.isMenuItem = true;
		ok.targetY = curSelected - 0;
		ok.screenCenter(X);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Looking at the Miscellaneous Options Menu", null);
		#end


		super.create();
	}

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			if (controls.BACK)
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);

			if (curSelected == 0)
				versionShit.text = "play songs in freeplay when havering over them.";

			if (curSelected == 1)
				versionShit.text = "disable or enable the games discord presence.";

			if (curSelected == 2)
				versionShit.text = "should boyfriend instantly idle after releasing a keypress from a hold or not.";

			for (item in grpControls.members)
				{
					item.screenCenter(X);
				}

			if (controls.ACCEPT)
			{
				switch(curSelected)
				{
					case 0:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.freeplaysongs = !FlxG.save.data.freeplaysongs;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.freeplaysongs ? 'freeplay song previews on' : 'freeplay song previews off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 0;
						#if windows
						//trl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
					case 1:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.discordrpc = !FlxG.save.data.discordrpc;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.discordrpc ? 'discord presence on' : 'discord presence off'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						#if windows
						//ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
                    case 2:
						grpControls.remove(grpControls.members[curSelected]);
						FlxG.save.data.idleafterhold = !FlxG.save.data.idleafterhold;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.idleafterhold ? 'idle after hold note' : 'Dont idle after hold note'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						#if windows
						//ctrl.color = FlxColor.YELLOW;
						#end
						grpControls.add(ctrl);
						
				}
			}
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
			
				#if !switch
				// NGio.logEvent('Fresh');
				#end
				
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		
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
					item.screenCenter(X);
		
					item.alpha = 0.6;
					#if windows
					//item.color = FlxColor.WHITE;
					#end
					// item.setGraphicSize(Std.int(item.width * 0.8));
		
					if (item.targetY == 0)
					{
						item.alpha = 1;
						#if windows
						//item.color = FlxColor.YELLOW;
						#end
						// item.setGraphicSize(Std.int(item.width));
					}
				}
			
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



   class BotPlay extends MiscOptions
{	
	public function press():Bool
	{
		FlxG.save.data.botplay = !FlxG.save.data.botplay;
		trace('BotPlay : ' + FlxG.save.data.botplay);
		updateDisplay();
		return true;
	}
	
	private function updateDisplay():String
		return "BotPlay " + (FlxG.save.data.botplay ? "on" : "off");
}



