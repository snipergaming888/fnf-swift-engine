package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class TitleStateOld extends FlxTransitionableState
{
	static var initialized:Bool = false;

	override public function create():Void
	{
		super.create();

		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(0, 0, FlxG.width, FlxG.height));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.5, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width, FlxG.height));

			initialized = true;

			FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
			FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
		}
		Conductor.changeBPM(92);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('stageback'));
		bg.antialiasing = true;
		bg.setGraphicSize(Std.int(bg.width * 0.6));
		bg.updateHitbox();
		add(bg);

		var logoBl:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logoBl.screenCenter();
		logoBl.color = FlxColor.BLACK;
		add(logoBl);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		add(logo);

		FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		FlxG.sound.playMusic(Paths.music('title'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER && !transitioning)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);

			transitioning = true;
			FlxG.sound.music.stop();

			new FlxTimer().start(3, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());
			});
			FlxG.sound.play(Paths.sound('titleShoot'), 0.7);
		}

		super.update(elapsed);
	}
}
