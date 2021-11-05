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
class CachedFrames
{
    public static var cachedInstance:CachedFrames;

    function new() {}

    public static function loadEverything()
    {
        cachedInstance = new CachedFrames();
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
		var Description = Assets.getText(Paths.file('images/$xmlName.xml'));

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
        var graph = FlxGraphic.fromAssetKey(Paths.image(path));
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
            toBeLoaded.set('alphabet','alphabet');
            toBeLoaded.set('BOYFRIEND','BOYFRIEND');
            toBeLoaded.set('campaign_menu_UI_assets','campaign_menu_UI_assets');
            toBeLoaded.set('campaign_menu_UI_characters','campaign_menu_UI_characters');
            toBeLoaded.set('FNF_main_menu_assets','FNF_main_menu_assets');
            toBeLoaded.set('gfDanceTitle','gfDanceTitle');
            toBeLoaded.set('go-pixel','go-pixel');
            toBeLoaded.set('iconGrid','iconGrid');
            toBeLoaded.set('logoBumpin','logoBumpin');
            toBeLoaded.set('menuBG','menuBG');
            toBeLoaded.set('menuBGBlue','menuBGBlue');
            toBeLoaded.set('menuBGMagenta','menuBGMagenta');
            toBeLoaded.set('menuDesat','menuDesat');
            toBeLoaded.set('newgrounds_logo','newgrounds_logo');
            toBeLoaded.set('NOTE_assets','NOTE_assets');
            toBeLoaded.set('num0','num0');
            toBeLoaded.set('num1','num1');
            toBeLoaded.set('num2','num2');
            toBeLoaded.set('num3','num3');
            toBeLoaded.set('num4','num4');
            toBeLoaded.set('num5','num5');
            toBeLoaded.set('num6','num6');
            toBeLoaded.set('num7','num7');
            toBeLoaded.set('num8','num9');
            toBeLoaded.set('num10','num10');
            toBeLoaded.set('ready-pixel','ready-pixel');
            toBeLoaded.set('set-pixel','set-pixel');
            toBeLoaded.set('titleEnter','titleEnter');
            
            
          
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