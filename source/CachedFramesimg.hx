import lime.utils.Assets;
#if haxe4
import haxe.xml.Access;
#else
import haxe.xml.Fast as Access;
#end
import flash.geom.Rectangle;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames.TexturePackerObject;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.graphics.frames.FlxFramesCollection.FlxFrameCollectionType;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
#if desktop
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxAssets.FlxTexturePackerSource;
#end
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
class CachedFramesimg
{
    public static var cachedInstance:CachedFramesimg;

    function new() {}

    public static function loadEverything()
    {
        cachedInstance = new CachedFramesimg();
        cachedInstance.loadFrames();
    }

    // so it doesn't brick your computer lol!
    public var cachedGraphics:Map<String,FlxGraphic> = new Map<String,FlxGraphic>();

    public static var loaded = false;

    public function fromSparrow(id:String, xmlName:String)
    {
        var graphic = get(id);
        // No need to parse data again
		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		frames = new FlxAtlasFrames(graphic);
		var Description = Assets.getText(Paths.file('images/$xmlName.xml', 'shared'));

		var data:Access = new Access(Xml.parse(Description).firstElement());

		for (texture in data.nodes.SubTexture)
		{
			var name = texture.att.name;
			var trimmed = texture.has.frameX;
			var rotated = (texture.has.rotated && texture.att.rotated == "true");
			var flipX = (texture.has.flipX && texture.att.flipX == "true");
			var flipY = (texture.has.flipY && texture.att.flipY == "true");

			var rect = FlxRect.get(Std.parseFloat(texture.att.x), Std.parseFloat(texture.att.y), Std.parseFloat(texture.att.width),
				Std.parseFloat(texture.att.height));

			var size = if (trimmed)
			{
				new Rectangle(Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY), Std.parseInt(texture.att.frameWidth),
					Std.parseInt(texture.att.frameHeight));
			}
			else
			{
				new Rectangle(0, 0, rect.width, rect.height);
			}

			var angle = rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;

			var offset = FlxPoint.get(-size.left, -size.top);
			var sourceSize = FlxPoint.get(size.width, size.height);

			if (rotated && !trimmed)
				sourceSize.set(size.height, size.width);

			frames.addAtlasFrame(rect, sourceSize, offset, name, angle, flipX, flipY);
		}

        return frames;
    }

    public function get(id:String)
    {
        return cachedGraphics.get(id);
    }

    public function load(id:String, path:String)
    {
        var graph = FlxGraphic.fromAssetKey(Paths.image(path,'shared'));
        graph.persist = true;
        graph.destroyOnNoUse = false;
        cachedGraphics.set(id,graph);
        trace('Loaded ' + id);
    }

    public var toBeLoaded:Map<String,String> = new Map<String,String>();


    public static var progress:Float = 0;

    public function loadFrames()
    {
        #if desktop
        sys.thread.Thread.create(() -> {
            toBeLoaded.set('bad','bad');
            toBeLoaded.set('BOYFRIEND','BOYFRIEND');
            toBeLoaded.set('combo','combo');
            toBeLoaded.set('DADDY_DEAREST','DADDY_DEAREST');
            toBeLoaded.set('go','go');
            toBeLoaded.set('good','good');
            toBeLoaded.set('healthBar','healthBar');
            toBeLoaded.set('GF_assets','GF_assets');
            toBeLoaded.set('NOTE_assets','NOTE_assets');
            toBeLoaded.set('NOTE_assets_downscroll','NOTE_assets_downscroll');
            toBeLoaded.set('Pico_FNF_assetss','Pico_FNF_assetss');
            toBeLoaded.set('ready','ready');
            toBeLoaded.set('set','set');
            toBeLoaded.set('shit','shit');
            toBeLoaded.set('sick','sick');
            toBeLoaded.set('stageback','stageback');
            toBeLoaded.set('stagecurtains','stagecurtains');
            toBeLoaded.set('stagefront','stagefront');
            toBeLoaded.set('animatedEvilSchool','weeb/animatedEvilSchool');
            toBeLoaded.set('bfPixel','weeb/bfPixel');
            toBeLoaded.set('bfPixelsDEAD','weeb/bfPixelsDEAD');
            toBeLoaded.set('bfPortrait','weeb/bfPortrait');
            toBeLoaded.set('bgFreaks','weeb/bgFreaks');
            toBeLoaded.set('evilSchoolBG','weeb/evilSchoolBG');
            toBeLoaded.set('evilSchoolFG','weeb/evilSchoolFG');
            toBeLoaded.set('gfPixel','weeb/gfPixel');
            toBeLoaded.set('petals','weeb/petals');
            toBeLoaded.set('senpai','weeb/senpai');
            toBeLoaded.set('senpaiCrazy','weeb/senpaiCrazy');
            toBeLoaded.set('senpaiPortrait','weeb/senpaiPortrait');
            toBeLoaded.set('spirit','weeb/spirit');
            toBeLoaded.set('spiritFaceForward','weeb/spiritFaceForward');
            toBeLoaded.set('weebSchool','weeb/weebSchool');
            toBeLoaded.set('weebSky','weeb/weebSky');
            toBeLoaded.set('weebTrees','weeb/weebTrees');
            toBeLoaded.set('weebTreesBack','weeb/weebTreesBack');
            toBeLoaded.set('arrowEnds','weeb/pixelUI/arrowEnds');
            toBeLoaded.set('arrowEndsdownscroll','weeb/pixelUI/arrowEndsdownscroll');
            toBeLoaded.set('arrows-pixels','weeb/pixelUI/arrows-pixels');
            toBeLoaded.set('bad-pixel','weeb/pixelUI/bad-pixel');
            toBeLoaded.set('combo-pixel','weeb/pixelUI/combo-pixel');
            toBeLoaded.set('date-pixel','weeb/pixelUI/date-pixel');
            toBeLoaded.set('dialogueBox-evil','weeb/pixelUI/dialogueBox-evil');
            toBeLoaded.set('dialogueBox-pixel','weeb/pixelUI/dialogueBox-pixel');
            toBeLoaded.set('dialogueBox-senpaiMad','weeb/pixelUI/dialogueBox-senpaiMad');
            toBeLoaded.set('good-pixel','weeb/pixelUI/good-pixel');
            toBeLoaded.set('hand_textbox','weeb/pixelUI/hand_textbox');
            toBeLoaded.set('num0-pixel','weeb/pixelUI/num0-pixel');
            toBeLoaded.set('num1-pixel','weeb/pixelUI/num1-pixel');
            toBeLoaded.set('num2-pixel','weeb/pixelUI/num2-pixel');
            toBeLoaded.set('num3-pixel','weeb/pixelUI/num3-pixel');
            toBeLoaded.set('num4-pixel','weeb/pixelUI/num4-pixel');
            toBeLoaded.set('num5-pixel','weeb/pixelUI/num5-pixel');
            toBeLoaded.set('num6-pixel','weeb/pixelUI/num6-pixel');
            toBeLoaded.set('num7-pixel','weeb/pixelUI/num7-pixel');
            toBeLoaded.set('num8-pixel','weeb/pixelUI/num8-pixel');
            toBeLoaded.set('num9-pixel','weeb/pixelUI/num9-pixel');
            toBeLoaded.set('ready-pixel','weeb/pixelUI/ready-pixel');
            toBeLoaded.set('set-pixel','weeb/pixelUI/set-pixel');
            toBeLoaded.set('shit-pixel','weeb/pixelUI/shit-pixel');
            toBeLoaded.set('sick-pixel','weeb/pixelUI/sick-pixel');


          
            // all the big sprites
            var numba = 0;
            for(i in toBeLoaded.keys())
            {
                load(i,toBeLoaded.get(i));
                numba++;
                progress = HelperFunctions.truncateFloat(numba / Lambda.count(toBeLoaded) * 100,2);
            }
            trace('loaded everythin');
            loaded = true;
        });
        #end
    }
}