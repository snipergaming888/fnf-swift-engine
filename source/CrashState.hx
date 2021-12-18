package;
#if desktop
import flash.system.System;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import lime.utils.Assets;

class CrashState extends MusicBeatState
{
    var ctrl:Alphabet;
    var bg:FlxSprite;
     override function create()
         {
          #if desktop
          System.exit(0);
          #end
         }	
}