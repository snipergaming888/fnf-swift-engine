package;

#if cpp
import Discord.DiscordClient;
#end
import Controls.KeyboardScheme;
import flixel.FlxSubState;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import openfl.Lib;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxObject;
import lime.utils.Assets;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.FlxState;

class ScoretextselectState extends MusicBeatState
{
	var cunductortext:FlxText;
	var magenta:FlxSprite;
	var BPM:Int = Conductor.bpm;
	var healthBarBG:FlxSprite;
	var healthBar:FlxBar;
	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	var p2color:FlxColor = 0xFF9456AE;
	var p1color:FlxColor = 0xFF31B0D1;
	var addedhealthbarshit:Bool = false;
	private var health:Float = 1;
	var scoreTxt:FlxText;
	var scoretextlayout:Int = 0;
	var scoretextlayouttext:String = '';
	var songScore:Int = 0;	
	var baseText2:String = "N/A";
	var songRating:String = "?";
	var fullcombotext:String = "N/A";
	var baseText:String = "N/A";
	private var misses:Int = 0;
	var scoretext:FlxText;
	var nps:Int = 0;
	private var sicks:Int = 0;
	private var goods:Int = 0;
	private var bads:Int = 0;
	private var shits:Int = 0;
	private var accuracy:Float = 0.00;
	var fc:Bool = true;

	override function create()
	{
		if (FreeplayState.voicesplaying)
			{
				FreeplayState.voicesplaying = false;
				FreeplayState.voices.stop();
			}
		addedhealthbarshit = false;
        if (FlxG.save.data.optimizations)
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat-opt'));
		else
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = true;
		magenta.color = 0xFFADD8E6;
		add(magenta);

		var descBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width), 40, 0xFF000000);
		descBG.alpha = 0.6;
		if (FlxG.save.data.downscroll)
		descBG.y = 680;	
		descBG.screenCenter(X);
		add(descBG);

		cunductortext = new FlxText(0, 0, FlxG.width, "BPM: " + BPM + " | left and right arrow to change, hold down SHIFT to go faster. Press SPACE to reset.");
		cunductortext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (FlxG.save.data.downscroll)
		cunductortext.y = 680;	
		add(cunductortext);
		scoretext = new FlxText(0, 20, FlxG.width, "ScoreText layout: " + scoretextlayouttext + ' | up and down to change, press R to reset.');
		scoretext.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (FlxG.save.data.downscroll)
			scoretext.y = 700;	
		add(scoretext);
		Conductor.changeBPM(Conductor.bpm);

		if (FlxG.save.data.downscroll)
			{
				scoreTxt = new FlxText(0, 100, FlxG.width, "", 20);
				scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				scoreTxt.scrollFactor.set();
				//scoreTxt.autoSize = false;
				//scoreTxt.alignment = CENTER;
				
				if (FlxG.save.data.antialiasing)
					{
						scoreTxt.antialiasing = false;
					}
					else
						{
							scoreTxt.antialiasing = true;
						}
					add(scoreTxt);
			}
				else
				{                       ///old default is 250
					scoreTxt = new FlxText(0, 698, FlxG.width, "", 20);
					scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					scoreTxt.scrollFactor.set();
					if (FlxG.save.data.antialiasing)
						{
							scoreTxt.antialiasing = false;
						}
						else
							{
								scoreTxt.antialiasing = true;
							}
						add(scoreTxt);
				}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
								if (FlxG.save.data.downscroll)
									healthBarBG.y = 50;
								healthBarBG.screenCenter(X);
								healthBarBG.scrollFactor.set();
								add(healthBarBG);
								trace('x: ' + healthBarBG.x + 'y: ' + healthBarBG.y);
				
								healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
								'health', 0, 2);
							healthBar.scrollFactor.set();
							if (FlxG.save.data.healthcolor)
								healthBar.createFilledBar(p2color, p1color);
							else
								healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
							// healthBar
							add(healthBar);

							iconP1 = new HealthIcon('bf', true);
							iconP1.y = healthBar.y - (iconP1.height / 2);
							iconP1.scrollFactor.set();
							add(iconP1);
									
					
							iconP2 = new HealthIcon('dad', false);
							iconP2.y = healthBar.y - (iconP2.height / 2);
							iconP2.scrollFactor.set();
							add(iconP2);
							addedhealthbarshit = true;

		#if cpp
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Choosing Scoretext preference", null);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{

		Conductor.songPosition = FlxG.sound.music.time;

		cunductortext.text = "BPM: " + BPM + " | left and right arrow to change, hold down SHIFT to go faster. Press SPACE to Reset.";
		scoretext.text = "ScoreText layout: " + scoretextlayouttext + ' | up and down to change, press SPACE to reset.';

		if (scoretextlayout == 0)
		scoreTxt.text = "Score: " + songScore + " | Current Accuracy: " + baseText2 + " | Overall Accuracy: " + "N/A" + " | Misses: " + misses + " | " + fullcombotext + " (" + songRating + ")";
		if (scoretextlayout == 1)
		scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + songScore + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
		if (scoretextlayout == 2)
		scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% " + (fc ? "| FC" : misses == 0 ? "| A" : accuracy <= 75 ? "| BAD" : "");
		if (scoretextlayout == 3)
		scoreTxt.text = "Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% |" + " Score:" + songScore;
		if (scoretextlayout == 4)
		scoreTxt.text = " Score: " + songScore + " | " + "Misses: " + misses;
		if (scoretextlayout == 5)
		scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + misses + ' | Rating: ' + songRating;
		if (scoretextlayout == 6)
		scoreTxt.text = "Score:" + songScore;
		if (scoretextlayout == 7)
		scoreTxt.text = "Score:" + songScore + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + " %" + " | " + generateRanking(); // Letter Rank
		if (scoretextlayout == 8)
		scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "%";
		var multiply:Int = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
			{
				BPM += 1 * multiply;
				Conductor.changeBPM(BPM);
			}
		if (FlxG.keys.justPressed.LEFT)
			{
				BPM -= 1 * multiply;
				Conductor.changeBPM(BPM);
			}

			if (FlxG.keys.justPressed.R)
				{
					scoretextlayout = 0;
				}

			if (FlxG.keys.justPressed.UP && scoretextlayout >= 0 && scoretextlayout < 8)
				{
					scoretextlayout += 1;
				}

			if (FlxG.keys.justPressed.DOWN && scoretextlayout > 0 && scoretextlayout <= 8)
				{
					scoretextlayout -= 1;
				}

				if (scoretextlayout == 0)
					scoretextlayouttext = 'Swift Engine';
				if (scoretextlayout == 1)
					scoretextlayouttext = 'Kade Engine 1.4.2';
				if (scoretextlayout == 2)
					scoretextlayouttext = 'Kade Engine 1.0';
				if (scoretextlayout == 3)
					scoretextlayouttext = 'Unknown Engine v1.0421';
				if (scoretextlayout == 4)
					scoretextlayouttext = 'Sniper Engine Alpha';
				if (scoretextlayout == 5)
					scoretextlayouttext = 'Psyche Engine';
				if (scoretextlayout == 6)
					scoretextlayouttext = 'Base FNF (centered)';
				if (scoretextlayout == 7)
				scoretextlayouttext = 'Kade Engine 1.8';
				if (scoretextlayout == 8)
				scoretextlayouttext = 'Fps Plus Engine';

		if (FlxG.keys.justPressed.SPACE)
		{
			BPM = 102;
			Conductor.changeBPM(BPM);
		}

		if (FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new ApperanceOptions());
		
		if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.4);
				trace('saved pref, ur scoretext is set to ' + scoretextlayout);
				if (scoretextlayout == 0)
					{
                     FlxG.save.data.swiftenginescoretext = true;
					 FlxG.save.data.kadeengine142scoretext = false;
					 FlxG.save.data.kadeengine10scoretext = false;
					 FlxG.save.data.unknownenginescoretext = false;
					 FlxG.save.data.sniperenginealphascoretext = false;
					 FlxG.save.data.pscyheenginescoretext = false;
					 FlxG.save.data.basefnfscoretext = false;
					 FlxG.save.data.kadeengine18scoretext = false;
					 FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 1)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = true;
						FlxG.save.data.kadeengine10scoretext = false;
						FlxG.save.data.unknownenginescoretext = false;
						FlxG.save.data.sniperenginealphascoretext = false;
						FlxG.save.data.pscyheenginescoretext = false;
						FlxG.save.data.basefnfscoretext = false;
						FlxG.save.data.kadeengine18scoretext = false;
						FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 2)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = false;
						FlxG.save.data.kadeengine10scoretext = true;
						FlxG.save.data.unknownenginescoretext = false;
						FlxG.save.data.sniperenginealphascoretext = false;
						FlxG.save.data.pscyheenginescoretext = false;
						FlxG.save.data.basefnfscoretext = false;
						FlxG.save.data.kadeengine18scoretext = false;
						FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 3)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = false;
						FlxG.save.data.kadeengine10scoretext = false;
						FlxG.save.data.unknownenginescoretext = true;
						FlxG.save.data.sniperenginealphascoretext = false;
						FlxG.save.data.pscyheenginescoretext = false;
						FlxG.save.data.basefnfscoretext = false;
						FlxG.save.data.kadeengine18scoretext = false;
						FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 4)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = false;
						FlxG.save.data.kadeengine10scoretext = false;
						FlxG.save.data.unknownenginescoretext = false;
						FlxG.save.data.sniperenginealphascoretext = true;
						FlxG.save.data.pscyheenginescoretext = false;
						FlxG.save.data.basefnfscoretext = false;
						FlxG.save.data.kadeengine18scoretext = false;
						FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 5)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = false;
						FlxG.save.data.kadeengine10scoretext = false;
						FlxG.save.data.unknownenginescoretext = false;
						FlxG.save.data.sniperenginealphascoretext = false;
						FlxG.save.data.pscyheenginescoretext = true;
						FlxG.save.data.basefnfscoretext = false;
						FlxG.save.data.kadeengine18scoretext = false;
						FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 6)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = false;
						FlxG.save.data.kadeengine10scoretext = false;
						FlxG.save.data.unknownenginescoretext = false;
						FlxG.save.data.sniperenginealphascoretext = false;
						FlxG.save.data.pscyheenginescoretext = false;
						FlxG.save.data.basefnfscoretext = true;
						FlxG.save.data.kadeengine18scoretext = false;
						FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 7)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = false;
						FlxG.save.data.kadeengine10scoretext = false;
						FlxG.save.data.unknownenginescoretext = false;
						FlxG.save.data.sniperenginealphascoretext = false;
						FlxG.save.data.pscyheenginescoretext = false;
						FlxG.save.data.basefnfscoretext = false;
						FlxG.save.data.kadeengine18scoretext = true;
						FlxG.save.data.fpsplusenginescoretext = false;
					}
				if (scoretextlayout == 8)
					{
						FlxG.save.data.swiftenginescoretext = false;
						FlxG.save.data.kadeengine142scoretext = false;
						FlxG.save.data.kadeengine10scoretext = false;
						FlxG.save.data.unknownenginescoretext = false;
						FlxG.save.data.sniperenginealphascoretext = false;
						FlxG.save.data.pscyheenginescoretext = false;
						FlxG.save.data.basefnfscoretext = false;
						FlxG.save.data.kadeengine18scoretext = false;
						FlxG.save.data.fpsplusenginescoretext = true;
					}
			}
		if (addedhealthbarshit)
			{
				if (FlxG.save.data.newhealthheadbump)
					{
					iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.15)));
					iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.15)));
					}
					else
						{
						iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
						iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));
						}
		
				iconP1.updateHitbox();
				iconP2.updateHitbox();
		
				var iconOffset:Int = 26;
		
				iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
				iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
			}

		super.update(elapsed);
	}

	override function beatHit()
		{
			super.beatHit();

			if (addedhealthbarshit)
				{
					iconP1.setGraphicSize(Std.int(iconP1.width + 30));
					iconP2.setGraphicSize(Std.int(iconP2.width + 30));
					iconP1.updateHitbox();
					iconP2.updateHitbox();
				}	
		}

		function truncateFloat( number : Float, precision : Int): Float {
			var num = number;
			num = num * Math.pow(10, precision);
			num = Math.round( num ) / Math.pow(10, precision);
			return num;
			}

			function generateRanking():String
				{
					var ranking:String = "N/A";

					if (FlxG.save.data.botplay)
						ranking = "BotPlay";
					if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
						ranking = "(MFC)";
					else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
						ranking = "(GFC)";
					else if (misses == 0) // Regular FC
						ranking = "(FC)";
					else if (misses < 10) // Single Digit Combo Breaks
						ranking = "(SDCB)";
					else
						ranking = "(Clear)";
			
					// WIFE TIME :)))) (based on Wife3)
			
					var wifeConditions:Array<Bool> = [
						accuracy >= 99.9935, // AAAAA
						accuracy >= 99.980, // AAAA:
						accuracy >= 99.970, // AAAA.
						accuracy >= 99.955, // AAAA
						accuracy >= 99.90, // AAA:
						accuracy >= 99.80, // AAA.
						accuracy >= 99.70, // AAA
						accuracy >= 99, // AA:
						accuracy >= 96.50, // AA.
						accuracy >= 93, // AA
						accuracy >= 90, // A:
						accuracy >= 85, // A.
						accuracy >= 80, // A
						accuracy >= 70, // B
						accuracy >= 60, // C
						accuracy < 60 // D
					];
			
					for(i in 0...wifeConditions.length)
					{
						var b = wifeConditions[i];
						if (b)
						{
							switch(i)
							{
								case 0:
									ranking += " AAAAA";
								case 1:
									ranking += " AAAA:";
								case 2:
									ranking += " AAAA.";
								case 3:
									ranking += " AAAA";
								case 4:
									ranking += " AAA:";
								case 5:
									ranking += " AAA.";
								case 6:
									ranking += " AAA";
								case 7:
									ranking += " AA:";
								case 8:
									ranking += " AA.";
								case 9:
									ranking += " AA";
								case 10:
									ranking += " A:";
								case 11:
									ranking += " A.";
								case 12:
									ranking += " A";
								case 13:
									ranking += " B";
								case 14:
									ranking += " C";
								case 15:
									ranking += " D";
							}
							break;
						}
					}
			
					if (accuracy == 0)
						ranking = "N/A";
					else if (FlxG.save.data.botplay)
						ranking = "BotPlay";
			
					return ranking;
				}

			
}
