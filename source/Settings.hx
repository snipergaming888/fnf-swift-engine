package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import lime.utils.Assets;

class Settings extends MusicBeatState
{  
         public static function loadsettings()
          {
            FlxG.save.data.debug = false;
            trace('turning off debug');
            
            if (FlxG.save.data.ghosttapping == null)
              FlxG.save.data.ghosttapping = true;
        
            if (FlxG.save.data.downscroll == null)
              FlxG.save.data.downscroll = false;
        
            if (FlxG.save.data.optimizations == null)
              FlxG.save.data.optimizations = false;
        
            if (FlxG.save.data.debug == null)
              FlxG.save.data.debug = false;
            
            if (FlxG.save.data.antialiasing == null)
              FlxG.save.data.antialiasing = true;
        
            if (FlxG.save.data.botplay == null)
              FlxG.save.data.botplay = false;
        
            if (FlxG.save.data.offset == null)
              FlxG.save.data.offset = 0;
        
            if (FlxG.save.data.curselected == null)
              FlxG.save.data.curselected = "0";
        
            if (FlxG.save.data.strumlights == null)
              FlxG.save.data.strumlights = true;
        
              FlxG.save.data.playerstrumlights = true;
              trace('reset pstrums');
        
            if (FlxG.save.data.camzooming == null)
              FlxG.save.data.camzooming = true;
        
            if (FlxG.save.data.watermarks == null)
              FlxG.save.data.watermarks = false;
        
            if (FlxG.save.data.fps == null)
              FlxG.save.data.fps = false;
        
            if (FlxG.save.data.imagecache == null)
              FlxG.save.data.imagecache = false;
        
            if (FlxG.save.data.songcache == null)
              FlxG.save.data.songcache = false;
        
            if (FlxG.save.data.soundcache == null)
              FlxG.save.data.soundcache = false;
        
            if (FlxG.save.data.musiccache == null)
              FlxG.save.data.musiccache = false;
        
            if (FlxG.save.data.songPosition == null)
              FlxG.save.data.songPosition = false;
        
            if (FlxG.save.data.pausecount == null)
              FlxG.save.data.pausecount = false;
        
            if (FlxG.save.data.hittimings == null)
              FlxG.save.data.hittimings = false;
            
            if (FlxG.save.data.hitsounds == null)
              FlxG.save.data.hitsounds = false;
        
            if (FlxG.save.data.repeat == null)
              FlxG.save.data.repeat = false;
        
            if (FlxG.save.data.transparency == null)
              FlxG.save.data.transparency = true;
        
            if (FlxG.save.data.minscore == null)
              FlxG.save.data.minscore = false;

            if (FlxG.save.data.freeplaysongs == null)
              FlxG.save.data.freeplaysongs = true;
        
            if (FlxG.save.data.nps == null)
              FlxG.save.data.nps = false;
        
            if (FlxG.save.data.discordrpc == null)
              FlxG.save.data.discordrpc = true;

            if (FlxG.save.data.memoryMonitor == null)
              FlxG.save.data.memoryMonitor = false;

            if (FlxG.save.data.songspeed == null)
              FlxG.save.data.songspeed = false;

            if (FlxG.save.data.antimash == null)
              FlxG.save.data.anti = false;

            if (FlxG.save.data.oldinput == null)
              FlxG.save.data.oldinput = false;

            if (FlxG.save.data.idleafterhold == null)
              FlxG.save.data.idleafterhold = false;
          }
}