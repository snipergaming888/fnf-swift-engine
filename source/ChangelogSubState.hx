package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.app.Application;

class ChangelogSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var changelog:String ="";
	var changelogtext:FlxText;
	var camFollow:FlxObject;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camZooming:Bool = false;
	var defaultCamZoom:Float = 1;

	

	override function create()
	{
		camHUD = new FlxCamera();
		camGame = new FlxCamera();
		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);
		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
		changelog = CoolUtil.coolTextFileString(Paths.txtREADME('changelog'));
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
			
		changelogtext = new FlxText(0,0);
		changelogtext.text = changelog;
		changelogtext.setFormat("VCR OSD Mono", 12, FlxColor.WHITE, CENTER);
		changelogtext.screenCenter();
		changelogtext.antialiasing = true;
		add(changelogtext);


		var sniperenginemark = new FlxText(4,700, "Hold down W and S to zoom in and out and UP, DOWN, LEFT, RIGHT to move.", 12);
		sniperenginemark.setFormat(Paths.font("vcr.ttf"), 12, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		sniperenginemark.scrollFactor.set();
		if (FlxG.save.data.antialiasing)
			{
				sniperenginemark.antialiasing = false;
			}
			else
				{
					sniperenginemark.antialiasing = true;
				}
		add(sniperenginemark);
		sniperenginemark.cameras = [camHUD];
			
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.justPressed.UP)
			{
				camFollow.y -= 150;
				camGame.follow(camFollow, null, 0.06);
			}

		if (FlxG.keys.justPressed.DOWN)
			{
				camFollow.y += 150;
				camGame.follow(camFollow, null, 0.06);
			}

			if (FlxG.keys.justPressed.LEFT)
				{
					camFollow.x -= 150;
					camGame.follow(camFollow, null, 0.06);
				}
	
			if (FlxG.keys.justPressed.RIGHT)
				{
					camFollow.x += 150;
					camGame.follow(camFollow, null, 0.06);
				}

			if (FlxG.keys.pressed.W)
				{
					FlxTween.tween(camGame, {zoom: 2 }, 0.5, { ease: FlxEase.quadIn, startDelay: 0});
					///FlxG.camera.zoom += 10;
				}

				if (FlxG.keys.justPressed.S)
					{
						if (FlxG.camera.zoom < 0)
							{
								trace('do not zoom or shit will break');
							}
							else
								FlxTween.tween(camGame, {zoom: 0 }, 0.0, { ease: FlxEase.quadIn, startDelay: 0});
						   ///FlxG.camera.zoom -= 10;
					}


	 if (FlxG.sound.music != null)
		 Conductor.songPosition = FlxG.sound.music.time;
	     camZooming = true;

		 if (camZooming)
			{
				FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
				camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
			}

		super.update(elapsed);
	}


	override function beatHit()
		{
			super.beatHit();
				{
					bopOnBeat();
					///iconBop();
					trace(curBeat);
				}
		}

		function bopOnBeat()
			{
				{
						    if (curBeat % 2 == 0)
						    	{
									if (TitleState.old)
										{
											trace('no');
										}
										else
											{

													if (camZooming && FlxG.camera.zoom < 1.35)
														{
															FlxG.camera.zoom += 0.005;
															camHUD.zoom += 0.02;
															trace('zooming %2 == 0');
														}
											}
										 }


				}
			}
}
