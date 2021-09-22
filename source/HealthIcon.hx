package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		animation.add('bf-mallet', [0, 1], 0, false, isPlayer);
		animation.add('picomallet', [4, 5], 0, false, isPlayer);
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-night', [0, 1], 0, false, isPlayer);
		animation.add('bf-glitcher', [0, 1], 0, false, isPlayer);
		animation.add('bfWIRE', [30, 31], 0, false, isPlayer);
		animation.add('black', [32, 33], 0, false, isPlayer);
		animation.add('mia', [35, 36, 37], 0, false, isPlayer);
		animation.add('nothing', [38], 0, false, isPlayer);
	 ///animation.add('miawinning', [37], 0, false, isPlayer);
		animation.add('gf-wire', [34, 34], 0, false, isPlayer);
		animation.add('bf-wolves', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('ascend', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('picowire', [28, 29], 0, false, isPlayer);
		animation.add('picoplayable', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('toby', [24, 25], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-night', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		animation.add('hexvirus', [26, 27], 0, false, isPlayer);
		animation.add('hexviruswire', [24, 25], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
