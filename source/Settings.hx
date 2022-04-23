package;

import openfl.Lib;
import flixel.FlxG;


class Settings extends MusicBeatState
{ 
  public static var enablebotplay:Bool = true; // set to false to disable botplay for your mod 
         public static function loadsettings()
          {
            //settings

            if (FlxG.save.data.firststart == null)
              {
                resettodefaultsettings();
                FlxG.save.data.firststart = true;
              }


            if (FlxG.save.data.songScores == null)
              {
                FlxG.save.data.songScores = 0;
              }
              else if (FlxG.save.data.songScores != null)
                {
                  Highscore.songScores = FlxG.save.data.songScores;
                }
            
            if (FlxG.save.data.ghosttapping == null)
              FlxG.save.data.ghosttapping = true;
        
            if (FlxG.save.data.downscroll == null)
              FlxG.save.data.downscroll = false;

            if (FlxG.save.data.middlescroll == null)
              FlxG.save.data.middlescroll = false;
        
            if (FlxG.save.data.optimizations == null)
              FlxG.save.data.optimizations = false;
        
            if (FlxG.save.data.debug == null)
              FlxG.save.data.debug = false;
            
            if (FlxG.save.data.antialiasing == null)
              FlxG.save.data.antialiasing = true;
        
            if (!enablebotplay)
              {
                FlxG.save.data.botplay = false;
              }

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
            
            if (FlxG.save.data.togglecap == null)
              FlxG.save.data.togglecap = false;

            if (FlxG.save.data.fpsCap > 1000 || FlxG.save.data.fpsCap < 10)
              FlxG.save.data.fpsCap = 138; // sorry kade dev but 360 HZ monitors exist now
        
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

            if (FlxG.save.data.showratings == null)
              FlxG.save.data.showratings = false;

            if (FlxG.save.data.reset == null)
              FlxG.save.data.reset = false;
            
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

            if (FlxG.save.data.healthcolor == null)
              FlxG.save.data.healthcolor = true;

            if (FlxG.save.data.newhealthheadbump == null)
              FlxG.save.data.newhealthheadbump = true;

            if (FlxG.save.data.missnotes == null)
              FlxG.save.data.missnotes = true;

            if (FlxG.save.data.KE154idle == null)
              FlxG.save.data.KE154idle = false;

            if (FlxG.save.data.idleonbeat == null)
              FlxG.save.data.idleonbeat = false;

            if (FlxG.save.data.instantRespawn == null)
              FlxG.save.data.instantRespawn = false;
          
            #if web
            if (FlxG.save.data.usedeprecatedloading == null)
              FlxG.save.data.usedeprecatedloading = true;
            #else
            if (FlxG.save.data.usedeprecatedloading == null)
              FlxG.save.data.usedeprecatedloading = false;
            #end

            if (FlxG.save.data.ghosttappinghitsoundsenabled == null)
              FlxG.save.data.ghosttappinghitsoundsenabled = false;

            if (FlxG.save.data.ghosttappinghitsoundsenabled)
              {
                GameOptions.ghosttappinghitsoundsenabled = true;
              }
              if (FlxG.save.data.notebaseddrain == null)
                FlxG.save.data.notebaseddrain = false;

              if (FlxG.save.data.middlecam == null)
                FlxG.save.data.middlecam = true;

              if (FlxG.save.data.camfollowspeedon == null)
                FlxG.save.data.camfollowspeedon = false;

              if (FlxG.save.data.swiftenginescoretext == null)
                FlxG.save.data.swiftenginescoretext = true;

              if (FlxG.save.data.kadeengine142scoretext == null)
                FlxG.save.data.kadeengine142scoretext = false;

              if (FlxG.save.data.kadeengine10scoretext == null)
                FlxG.save.data.kadeengine10scoretext = false;

              if (FlxG.save.data.unknownenginescoretext == null)
                FlxG.save.data.unknownenginescoretext = false;

              if (FlxG.save.data.sniperenginealphascoretext == null)
                FlxG.save.data.sniperenginealphascoretext = false;

              if (FlxG.save.data.pscyheenginescoretext == null)
                FlxG.save.data.pscyheenginescoretext = false;

              if (FlxG.save.data.basefnfscoretext == null)
                FlxG.save.data.basefnfscoretext = false;

              if (FlxG.save.data.kadeengine18scoretext == null)
                FlxG.save.data.kadeengine18scoretext = false;

              if (FlxG.save.data.fpsplusenginescoretext == null)
                FlxG.save.data.fpsplusenginescoretext = false;

              if (FlxG.save.data.ke142ratings == null)
                FlxG.save.data.ke142ratings = false;

              if (FlxG.save.data.ke154ratings == null)
                FlxG.save.data.ke154ratings = false;

              if (FlxG.save.data.disguiseaske142 == null)
                FlxG.save.data.disguiseaske142 = false;

              if (FlxG.save.data.disguiseaske154 == null)
                FlxG.save.data.disguiseaske154 = false;

              if (FlxG.save.data.combotext == null)
                FlxG.save.data.combotext = false;
              
              if (FlxG.save.data.songinfo == null)
                FlxG.save.data.songinfo = false;

              if ( FlxG.save.data.changedHitX == null)
                FlxG.save.data.changedHitX = GameplayCustomizeState.defaultX;

            if ( FlxG.save.data.changedHitY == null)
                FlxG.save.data.changedHitY = GameplayCustomizeState.defaultY;

              if (FlxG.save.data.changedHit == null)
                FlxG.save.data.changedHit = false;

              FlxG.save.data.hasplayed = false;
              trace('anim played? ' + FlxG.save.data.hasplayed);
              
              if (FlxG.save.data.togglecap)
                {
                  (cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
                  FlxG.updateFramerate = FlxG.save.data.fpsCap;
				          FlxG.drawFramerate = FlxG.save.data.fpsCap;
                }

		          if (FlxG.save.data.volume != null)
              {
                FlxG.sound.volume = FlxG.save.data.volume;
              }
              if (FlxG.save.data.mute != null)
              {
                FlxG.sound.muted = FlxG.save.data.mute;
              }
                       
          }

          public static function resettodefaultsettings()
            {
                FlxG.save.data.ghosttapping = true;
          
                FlxG.save.data.downscroll = false;
  
                FlxG.save.data.middlescroll = false;
          
                FlxG.save.data.optimizations = false;
          
                FlxG.save.data.antialiasing = true;
        
                FlxG.save.data.botplay = false;
          
                FlxG.save.data.offset = 0;
          
                FlxG.save.data.curselected = "0";
          
                FlxG.save.data.strumlights = true;
          
                FlxG.save.data.playerstrumlights = true;
                trace('reset pstrums');

                FlxG.save.data.debug = false;
          
                FlxG.save.data.camzooming = true;
          
                FlxG.save.data.watermarks = true;
          
                FlxG.save.data.fps = false;
              
                FlxG.save.data.togglecap = false;
  
                FlxG.save.data.fpsCap = 138; // sorry kade dev but 360 HZ monitors exist now
          
                FlxG.save.data.imagecache = false;
          
                FlxG.save.data.songcache = false;
          
                FlxG.save.data.soundcache = false;
          
                FlxG.save.data.musiccache = false;
          
                FlxG.save.data.songPosition = false;
          
                FlxG.save.data.pausecount = false;
          
                FlxG.save.data.hittimings = false;
  
                FlxG.save.data.showratings = false;
  
                FlxG.save.data.reset = false;
              
                FlxG.save.data.hitsounds = false;
          
                FlxG.save.data.repeat = false;
          
                FlxG.save.data.transparency = true;
          
                FlxG.save.data.minscore = false;
  
                FlxG.save.data.freeplaysongs = true;
          
                FlxG.save.data.nps = false;
          
                FlxG.save.data.discordrpc = true;
  
                FlxG.save.data.memoryMonitor = false;
  
                FlxG.save.data.songspeed = false;
  
                FlxG.save.data.anti = false;
  
                FlxG.save.data.oldinput = false;
  
                FlxG.save.data.healthcolor = true;
  
                FlxG.save.data.newhealthheadbump = true;
  
                FlxG.save.data.missnotes = true;
  
                FlxG.save.data.instantRespawn = false;
            
                FlxG.save.data.usedeprecatedloading = false;
  
                FlxG.save.data.ghosttappinghitsoundsenabled = false;
  
              if (FlxG.save.data.ghosttappinghitsoundsenabled)
                {
                  GameOptions.ghosttappinghitsoundsenabled = true;
                }
                  FlxG.save.data.notebaseddrain = false;
  
                  FlxG.save.data.middlecam = true;
  
                  FlxG.save.data.camfollowspeedon = false;

                    FlxG.save.data.swiftenginescoretext = true;
    
                    FlxG.save.data.kadeengine142scoretext = false;
    
                    FlxG.save.data.kadeengine10scoretext = false;
    
                    FlxG.save.data.unknownenginescoretext = false;
    
                    FlxG.save.data.sniperenginealphascoretext = false;
    
                    FlxG.save.data.pscyheenginescoretext = false;

                    FlxG.save.data.basefnfscoretext = false;
      
                    FlxG.save.data.kadeengine18scoretext = false;

                    FlxG.save.data.fpsplusenginescoretext = false;

                    FlxG.save.data.changedHit = false;

                    FlxG.save.data.changedHitX = GameplayCustomizeState.defaultX;
                    
                    FlxG.save.data.changedHitY =  GameplayCustomizeState.defaultY;

                    FlxG.save.data.ke142ratings = false;
      
                    FlxG.save.data.ke154ratings = false;

                    FlxG.save.data.disguiseaske142 = false;
      
                    FlxG.save.data.disguiseaske154 = false;
  
                FlxG.save.data.hasplayed = false;
                trace('anim played? ' + FlxG.save.data.hasplayed);
                
                    (cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
                    FlxG.updateFramerate = FlxG.save.data.fpsCap;
                    FlxG.drawFramerate = FlxG.save.data.fpsCap; 
  
                if (FlxG.save.data.volume != null)
                {
                  FlxG.sound.volume = FlxG.save.data.volume;
                }
                if (FlxG.save.data.mute != null)
                {
                  FlxG.sound.muted = FlxG.save.data.mute;
                }
            }
}