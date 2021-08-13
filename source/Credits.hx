package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class Credits extends MusicBeatState
{
	var creator:Array<Creatordata> = [new Creatordata("Press Enter", "www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstleyVEVO")];

	var curSelected:Int = 0;


	private var grpCreator:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	override function create()
	{   
        FlxG.sound.playMusic(Paths.music('Credits'));
        
        var initCreatorlist = CoolUtil.coolTextFile(Paths.txt('creators'));
        
        for (i in 0...initCreatorlist.length)
        {
            var data:Array<String> = initCreatorlist[i].split(':');
            creator.push(new Creatordata(data[0], data[1]));
        }

		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('Credits'));
			}
		 */

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Checking credits omegalol", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end


		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('Vs_Suit_Group'));
		add(bg);

		grpCreator = new FlxTypedGroup<Alphabet>();
		add(grpCreator);

		for (i in 0...creator.length)
		{
			var creatorText:Alphabet = new Alphabet(0, (70 * i) + 30, creator[i].name, true, false);
			creatorText.isMenuItem = true;
			creatorText.targetY = i;
			grpCreator.add(creatorText);

		}

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
            #if linux
				Sys.command('/usr/bin/xdg-open', ["https://" + creator[curSelected].media, "&"]);
			#else
				FlxG.openURL('https://' + creator[curSelected].media);
			#end
			
		}
	}


	function changeSelection(change:Int = 0)
	{

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = creator.length - 1;
		if (curSelected >= creator.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpCreator.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}

class Creatordata
{
    public var name:String = "";
    public var media:String = "";

    public function new(name:String, media:String)
    {
        this.name = name;
        this.media = media;
    }
}