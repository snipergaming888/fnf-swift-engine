package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class LoadingStateRemovedSongs extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;
	
	var target:FlxState;
	var stopMusic = false;
	var callbacks:MultiCallbackRemovedSongs;
	
	var logo:FlxSprite;
	var gfDance:FlxSprite;
	var loading:FlxSprite;
	var danceLeft = false;
	var peroid:FlxSprite;
	var peroid2:FlxSprite;
	var peroid3:FlxSprite;
	var loadingA:Alphabet;
	var ctrl:Alphabet;
	public static var weekDataweb:Array<Dynamic> = [
		['Tutorial'],
		['Fresh'],
		['South'],
		['Philly'],
		["High"],
		['Eggnog'],
		['Roses']
	];
	public static var weekDataweb2:Array<Dynamic> = [
		['Tutorial'],
		['Dadbattle'],
		["Monster"],
		["Blammed"],
		["Milf"],
		['Winter-Horrorland'],
		['Thorns']
	];
	//public static var stringThing:Array<String> = weekDataweb[StoryMenuState.curWeek];
	public static var stringThing:String = weekDataweb[StoryMenuState.curWeek];

	function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}
	
	override function create()
	{
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		add(bg);
		logo = new FlxSprite(-150, -100);
		logo.frames = Paths.getSparrowAtlas('logoBumpin');
		logo.antialiasing = true;
		logo.animation.addByPrefix('bump', 'logo bumpin', 24);
		logo.animation.play('bump');
		logo.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		danceLeft = !danceLeft;
		add(gfDance);
		add(logo);

		//var loading:FlxSprite = new FlxSprite(-5, 622).loadGraphic(Paths.image('loading'));
		//loading.antialiasing = true;
		//add(loading);

		var loadingA:Alphabet = new Alphabet(0, 650, "loading", true, false);
		add(loadingA);

		var peroid = new FlxSprite(350, 700);
		peroid.frames = Paths.getSparrowAtlas('alphabet');
		peroid.animation.addByPrefix('sex', 'period', 24);
		peroid.animation.play('sex');
        if (FlxG.save.data.antialiasing)
		peroid.antialiasing = true;
	    add(peroid);

		var peroid2 = new FlxSprite(375, 700);
		peroid2.frames = Paths.getSparrowAtlas('alphabet');
		peroid2.animation.addByPrefix('sex', 'period', 24);
		peroid2.animation.play('sex');
        if (FlxG.save.data.antialiasing)
		peroid2.antialiasing = true;
	    add(peroid2);

		var peroid3 = new FlxSprite(400, 700);
		peroid3.frames = Paths.getSparrowAtlas('alphabet');
		peroid3.animation.addByPrefix('sex', 'period', 24);
		peroid3.animation.play('sex');
        if (FlxG.save.data.antialiasing)
		peroid3.antialiasing = true;
	    add(peroid3);

	   var ctrl:Alphabet = new Alphabet(-5, 530, "(esc to cancel)");
	   if (FlxG.save.data.antialiasing)
		ctrl.setGraphicSize(Std.int(ctrl.width * -1.0));
	   ctrl.setGraphicSize(Std.int(ctrl.width * -1.0));
		ctrl.antialiasing = true;
	   add(ctrl);
		
		initSongsManifest().onComplete
		(
			function (lib)
			{
				callbacks = new MultiCallbackRemovedSongs(onLoad);
				var introComplete = callbacks.add("introComplete");
				checkLibrary("shared");
				if (PlayState.storyWeek > 0)
					checkLibrary("week" + PlayState.storyWeek);
				else
					checkLibrary("tutorial");
				
				var fadeTime = 0.5;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
			}
		);
	}
	
	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function (_) { callback(); });
		}
	}

	function checkLibrary(library:String)
	{
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;
			
			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	
	override function beatHit()
	{
		super.beatHit();
		
		logo.animation.play('bump');

		trace(curBeat);
		danceLeft = !danceLeft;

				if (danceLeft)
					gfDance.animation.play('danceRight');
				else
					gfDance.animation.play('danceLeft');
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		#if debug
		if (FlxG.keys.justPressed.SPACE)
			trace('fired: ' + callbacks.getFired() + " unfired:" + callbacks.getUnfired());
		#end
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.ESCAPE)
			if (StoryMenuState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				#if web
			FlxG.switchState(new FreeplayStateHTML5());
			#else
			FlxG.switchState(new FreeplayState());
			#end	
	}
	
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		FlxG.switchState(target);
	}
	

	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		FlxG.switchState(getNextState(target, stopMusic));
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		Paths.setCurrentLevel("week" + PlayState.storyWeek);
		#if NO_PRELOAD_ALL
		var loaded = isLibraryLoaded("shared");
		
		if (!loaded)
			return new LoadingStateRemovedSongs(target, stopMusic);
		#end
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	
	#if NO_PRELOAD_ALL
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	#end
	
	override function destroy()
	{
		super.destroy();
		
		callbacks = null;
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallbackRemovedSongs
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function ()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}