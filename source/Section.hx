package;

typedef SwagSection =
{
	var startTime:Float;
	var endTime:Float;
	var sectionNotes:Array<Dynamic>;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var mustHitSection:Bool;
	var gfsection:Bool;
	var bpm:Int;
	var changeBPM:Bool;
	var altAnim:Bool;
	var altAnim2:Bool;
	var camzoomonp1:Bool;
	var camzoomamountp1:Float;
	var camerashaketrigger:Float;
	var camerazoomtrigger:Float;
	var camerazoomtrigger2:Float;
	var camzoomtime:Float;
	var camerashake:Bool;
	var camerashakeduration:Float;
	var camerashakeamount:Float;
	var	disablecamzooming:Bool;
	var	camzooming:Bool;
	var curbeatzooming:Bool;
	var curstepzooming:Bool;
	var curbeatanim:Bool;
	var curstepanim:Bool;
	var camerazoompercentinput:Float;
	var flixelcamerazoom:Float;
	var flixelHUDzoom:Float;
	var gfspeed:Bool;
	var sectiongfspeed:Int;
	var playanim:Bool;
	var steppernumanim:Float;
	var animtoplay:String;
	var charactertoplayon:String;
	var isforced:Bool;
	var islooped:Bool;
	var crossFade:Bool;
	var shakegamecamera:Bool;
    var shakeHUD:Bool;
}

class Section
{
	public var startTime:Float = 0;
	public var endTime:Float = 0;
	public var sectionNotes:Array<Dynamic> = [];

	public var lengthInSteps:Int = 16;
	public var typeOfSection:Int = 0;
	public var mustHitSection:Bool = true;
	public var gfsection:Bool = false;
	public var camzoomonp1:Bool = true;
	public var camerashake:Bool;
	public var disablecamzooming:Bool;
	public var camzooming:Bool;
	public var curbeatzooming:Bool;
	public var curstepzooming:Bool;
	public var curbeatanim:Bool;
	public var curstepanim:Bool;
	public var gfspeed:Bool;
	public var playanim:Bool;
	public var animtoplay:String;
	public var charactertoplayon:String;
	public var isforced:Bool;
	public var islooped:Bool;
	public var shakegamecamera:Bool;
	public var shakeHUD:Bool;

	/**
	 *	Copies the first section into the second section!
	 */
	public static var COPYCAT:Int = 0;

	public function new(lengthInSteps:Int = 16)
	{
		this.lengthInSteps = lengthInSteps;
	}
}
