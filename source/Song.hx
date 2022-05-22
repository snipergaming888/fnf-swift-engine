package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import flixel.FlxG;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Int;
	var needsVoices:Bool;
	var speed:Float;
	var player1:String;
	var player2:String;
	var validScore:Bool;
	var stage:String;
	var composer:String;
	var camzoomamountp1:Float;
	var camerashakeamount:Float;
	var camerashakeduration:Float;
	var camerashaketrigger:Float;
	var camerazoomtrigger:Float;
	var camerazoomtrigger2:Float;
	var camzoomtime:Float;
	var curbeatzooming:Bool;
	var curstepzooming:Bool;
	var camerazoompercentinput:Float;
	var flixelcamerazoom:Float;
	var flixelHUDzoom:Float;
	var sectiongfspeed:Int;
	var steppernumanim:Float;
	var noteskin:String;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;
	public var camzoomamountp1:Float;
	public var camerashaketrigger:Float;
	public var camerashakeduration:Float;
	public var camzoomtime:Float;
    public var camerashakeamount:Float;
	public var camerazoomtrigger:Float;
	public var camerazoomtrigger2:Float;
	public var camerazoompercentinput:Float;
	public var flixelcamerazoom:Float;
	public var steppernumanim:Float;
	public var flixelHUDzoom:Float;
	public var sectiongfspeed:Int;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var stage:String = '';
	public var composer:String = '';
	public static var noteskin:String = 'default';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();

		while (!rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
			// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
		}

		// FIX THE CASTING ON WINDOWS/NATIVE
		// Windows???
		// trace(songData);
		#if debug
		trace('LOADED FROM JSON: ' + rawJson);
		#end
		/* 
			for (i in 0...songData.notes.length)
			{
				trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
				// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
			}

				daNotes = songData.notes;
				daSong = songData.song;
				daBpm = songData.bpm; */

		return parseJSONshit(rawJson);
	}

	public static function loadFromFileSystem(jsonInput:String):SwagSong
		{
			var rawJson = jsonInput.toLowerCase().trim();
	
			while (!rawJson.endsWith("}"))
			{
				rawJson = rawJson.substr(0, rawJson.length - 1);
				// LOL GOING THROUGH THE BULLSHIT TO CLEAN IDK WHATS STRANGE
			}
	
			// FIX THE CASTING ON WINDOWS/NATIVE
			// Windows???
			// trace(songData);
			 #if debug
			 trace('LOADED FROM JSON: ' + rawJson);
			 #end
			/* 
				for (i in 0...songData.notes.length)
				{
					trace('LOADED FROM JSON: ' + songData.notes[i].sectionNotes);
					// songData.notes[i].sectionNotes = songData.notes[i].sectionNotes
				}
	
					daNotes = songData.notes;
					daSong = songData.song;
					daBpm = songData.bpm; */
	
			return parseJSONshit(rawJson);
		}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
