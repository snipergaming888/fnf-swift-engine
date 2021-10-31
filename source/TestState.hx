package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import lime.utils.Assets;

class TestState extends MusicBeatState
{
    var ctrl:Alphabet;
    var bg:FlxSprite;
     override function create()
         {
            var bg:FlxSprite = new FlxSprite(0,0).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
            add(bg);
            var ctrl:Alphabet = new Alphabet(0, (70) + 30, "so lower case letters are a thing");
            #if windows
            ctrl.color = FlxColor.BLACK;
            #end
           add(ctrl);
         }	
}