package;

import flixel.FlxGame;
import flixel.FlxG;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{  
	var memoryMonitor:MemoryMonitor;
	

	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 138; // How many frames per second the game should run at. default: 138.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	var fpsCounter:FPS;
	public static var woops:Bool = false;
	public static var Custom:Bool = false;

	// You can pretty much ignore everything from here on - your code should go in your states.


	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));	

		var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";

		#if web
		var str1:String = "HTML CRAP";
		var vHandler = new VideoHandler();
		vHandler.init1();
		vHandler.video.name = str1;
		addChild(vHandler.video);
		vHandler.init2();
		GlobalVideo.setVid(vHandler);
		vHandler.source(ourSource);
		#elseif cpp
		var str1:String = "WEBM SHIT"; 
		var webmHandle = new WebmHandler();
		webmHandle.source(ourSource);
		webmHandle.makePlayer();
		webmHandle.webm.name = str1;
		addChild(webmHandle.webm);
		GlobalVideo.setWebm(webmHandle);
		#end
		

		#if !mobile
		 	 fpsCounter = new FPS(2, 2, 0xFFFFFF);
			 addChild(fpsCounter);
			 toggleFPS(FlxG.save.data.fps);
		 #end

		
		 
			
			memoryMonitor = new MemoryMonitor(2, 2, 0xffffff);
			addChild(memoryMonitor);
			togglememoryMonitor(FlxG.save.data.memoryMonitor);
			
		///addChild(new FPS(10, 3, 0xFFFFFF));

		#if web
		js.Browser.console.warn("MemoryMonitor Might not work on some browsers like firefox. You have been warned!");
		#end

	}

	public function getFPS():Float
		{
			return fpsCounter.currentFPS;
		}

	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}

	public function togglememoryMonitor(memoryMonitorEnabled:Bool):Void {
		memoryMonitor.visible = memoryMonitorEnabled;
	}

	public function setFPSCap(cap:Float)
		{
			openfl.Lib.current.stage.frameRate = cap;
		}
}
