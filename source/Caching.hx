package;

import openfl.utils.Assets as OpenFlAssets;
#if cpp
import sys.FileSystem;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var disableText:FlxText;
	var kadeLogo:FlxSprite;

	public static var bitmapData:Map<String, FlxGraphic>;

	public static var afterBoot:Bool = false;
    public static var notyetcached:Bool = true;

	var shared = [];
    var week2 = [];
    var week3 = [];
    var week4 = [];
    var week5 = [];
    var week6 = [];
    var week6sub = [];
	var songs = [];
	var music = [];
	var sounds = [];

	override function create()
	{
        trace('hello');
        text = new FlxText(0, 0, "Caching... (" + done + " l " + toBeDone + ")");
		text.setFormat(Paths.font("FridayNightFunkin-Regular.ttf"), 42, FlxColor.WHITE);
		text.alpha = 1;
        text.screenCenter(X);
        text.screenCenter(Y);
		text.antialiasing = true;
        add(text);


		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		bitmapData = new Map<String, FlxGraphic>();

		// this is the chaching stolen from Doki Doki Takeover but instead of just caching characters it also chaches sprites
		#if cpp
		if (FlxG.save.data.imagecache)
		{
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
			{
				if (!i.endsWith(".png"))
					continue;
				shared.push(i);
			}
		}

        if (FlxG.save.data.imagecache)
            {
                for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/week2/images")))
                {
                    if (!i.endsWith(".png"))
                        continue;
                    week2.push(i);
                }
            }

        if (FlxG.save.data.imagecache)
            {
                for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/week3/images")))
                {
                    if (!i.endsWith(".png"))
                        continue;
                    week3.push(i);
                }
            }

        if (FlxG.save.data.imagecache)
            {
                for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/week4/images")))
                {
                    if (!i.endsWith(".png"))
                        continue;
                    week4.push(i);
                }
            }

        if (FlxG.save.data.imagecache)
            {
                for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/week5/images")))
                {
                    if (!i.endsWith(".png"))
                        continue;
                    week5.push(i);
                }
            }

        if (FlxG.save.data.imagecache)
            {
                for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/weeb")))
                {
                    if (!i.endsWith(".png"))
                        continue;
                    week6.push(i);
                }
            }

            if (FlxG.save.data.imagecache)
                {
                    for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/weeb/pixelUI")))
                    {
                        if (!i.endsWith(".png"))
                            continue;
                        week6sub.push(i);
                    }
                }

		// TODO: Get the audio list from OpenFlAssets.
		if (FlxG.save.data.songcache)
            {
                songs = Paths.listSongsToCache();
            }

		if (FlxG.save.data.musiccache)
			music = Paths.listAudioToCache(false);

		if (FlxG.save.data.soundcache)
			sounds = Paths.listAudioToCache(true);
		#end

		toBeDone = Lambda.count(shared) + Lambda.count(week2) + Lambda.count(week3) + Lambda.count(week4) + Lambda.count(week5) + Lambda.count(week6) + Lambda.count(week6sub) + Lambda.count(songs) + Lambda.count(music) + Lambda.count(sounds);
       if (notyetcached) 
        {
            new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                 cache();
                });
            notyetcached = false;
        }



		super.create();
	}

    override function update(elapsed)
        {
            text.text = "Caching... (" + done + " l " + toBeDone + ")";
            trace("Caching... (" + done + " l " + toBeDone + ")");
    
            super.update(elapsed);
        }

	var calledDone:Bool = false;

	var canSpam:Bool = true;

	function cache()
	{
		#if cpp
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in shared)
		{
			var replaced = i.replace(".png", "");
			var imagePath = Paths.image('' + replaced, 'shared');
			trace('Caching graphic $replaced ($imagePath)...');
			var data = OpenFlAssets.getBitmapData(imagePath);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			bitmapData.set(replaced, graph);
			done++;
		}

        for (i in week2)
            {
                var replaced = i.replace(".png", "");
                var imagePath = Paths.image('' + replaced, 'week2');
                trace('Caching graphic $replaced ($imagePath)...');
                var data = OpenFlAssets.getBitmapData(imagePath);
                var graph = FlxGraphic.fromBitmapData(data);
                graph.persist = true;
                bitmapData.set(replaced, graph);
                done++;
            }

         for (i in week3)
            {
                var replaced = i.replace(".png", "");
                var imagePath = Paths.image('' + replaced, 'week3');
                trace('Caching graphic $replaced ($imagePath)...');
                var data = OpenFlAssets.getBitmapData(imagePath);
                var graph = FlxGraphic.fromBitmapData(data);
                graph.persist = true;
                bitmapData.set(replaced, graph);
                done++;
            }

        for (i in week4)
            {
                var replaced = i.replace(".png", "");
                var imagePath = Paths.image('' + replaced, 'week4');
                trace('Caching graphic $replaced ($imagePath)...');
                var data = OpenFlAssets.getBitmapData(imagePath);
                var graph = FlxGraphic.fromBitmapData(data);
                graph.persist = true;
                bitmapData.set(replaced, graph);
                done++;
            }
            
        for (i in week5)
            {
                var replaced = i.replace(".png", "");
                var imagePath = Paths.image('' + replaced, 'week5');
                trace('Caching graphic $replaced ($imagePath)...');
                var data = OpenFlAssets.getBitmapData(imagePath);
                var graph = FlxGraphic.fromBitmapData(data);
                graph.persist = true;
                bitmapData.set(replaced, graph);
                done++;
            }
            
        for (i in week6)
            {
                var replaced = i.replace(".png", "");
                var imagePath = Paths.image('weeb/' + replaced, 'shared');
                trace('Caching graphic $replaced ($imagePath)...');
                var data = OpenFlAssets.getBitmapData(imagePath);
                var graph = FlxGraphic.fromBitmapData(data);
                graph.persist = true;
                bitmapData.set(replaced, graph);
                done++;
            }
            
        for (i in week6sub)
            {
                var replaced = i.replace(".png", "");
                var imagePath = Paths.image('weeb/pixelUI/' + replaced, 'shared');
                trace('Caching graphic $replaced ($imagePath)...');
                var data = OpenFlAssets.getBitmapData(imagePath);
                var graph = FlxGraphic.fromBitmapData(data);
                graph.persist = true;
                bitmapData.set(replaced, graph);
                done++;
            } 

		for (i in songs)
		{
			trace('Caching song "$i"...');
			var inst = Paths.inst(i);
			if (Paths.doesSoundAssetExist(inst))
			{
				FlxG.sound.cache(inst);
				trace('Cached inst for song "$i"');
			}
			else
				trace('Failed to cache inst for song "$i"');

			var voices = Paths.voices(i);
			if (Paths.doesSoundAssetExist(voices))
			{
				FlxG.sound.cache(voices);
				trace('Cached voices for song "$i"');
			}
			else
				trace('Failed to cache voices for song "$i"');

			done++;
		}

		for (i in music)
		{
			var replaced = i.replace(".ogg", "");
			trace('Caching music "$replaced"...');
			var music = Paths.music(replaced, 'shared');
			if (Paths.doesSoundAssetExist(music))
			{
				FlxG.sound.cache(music);
				trace('Cached music "$replaced"');
			}
			else
				trace('Failed to cache music "$replaced"');

			done++;
		}

		for (i in sounds)
		{
			var replaced = i.replace(".ogg", "");
			trace('Caching sound "$replaced"...');
			var sound = Paths.sound(replaced, 'shared');
			if (Paths.doesSoundAssetExist(sound))
			{
				FlxG.sound.cache(sound);
				trace('Cached sound "$replaced"');
			}
			else
				trace('Failed to cache sound "$replaced"');

			done++;
		}

		trace("Finished caching!");
		#end

		loaded = true;
		{
				FlxG.switchState(new TitleState());
		}
	}
}
