import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.ui.FlxBar;
#if windows
import Discord.DiscordClient;
import sys.thread.Thread;
#end

import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.ui.Keyboard;
import flixel.FlxSprite;
import flixel.FlxG;

class GameplayCustomizeState extends MusicBeatState
{

    public static var defaultX:Float = 458.5;
    public static var defaultY:Float = 209;

    var background:FlxSprite;
    var curt:FlxSprite;
    var front:FlxSprite;

    public static var sick:FlxSprite;

    var text:FlxText;
    var blackBorder:FlxSprite;

    var bf:Boyfriend;
    var dad:Character;
    var gf:Character;

    var strumLine:FlxSprite;
    var defaultCamZoom:Float = 0.8;
    private var gfSpeed:Int = 1;
    var strumLineNotes:FlxTypedGroup<FlxSprite>;
    var playerStrums:FlxTypedGroup<FlxSprite>;
    private var camHUD:FlxCamera;
    private var camGame:FlxCamera;
    var ratingtheme:Int = 0;
    var ratingthemetext:String = 'Default';
    public static var firstload:Bool = true;
    var healthBarBG:FlxSprite;
	var healthBar:FlxBar;
	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;
	var p2color:FlxColor = 0xFF9456AE;
	var p1color:FlxColor = 0xFF31B0D1;
	var addedhealthbarshit:Bool = false;
	private var health:Float = 1;
    public static var reloadhealthbar:Bool = false;
    
    public override function create() {
        if (!FlxG.sound.music.playing)
            {	
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                Conductor.changeBPM(102);
            }
        firstload = true;
        if (FlxG.save.data.ke142ratings)
            {
                ratingtheme = 1;
                ratingthemetext = 'Kade Engine 1.4.2';
            }
        if (FlxG.save.data.ke154ratings)
            {
                ratingtheme = 2;
                ratingthemetext = 'Kade Engine 1.5.4';
            }
        #if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Customizing Gameplay", null);
		#end
        if (FlxG.save.data.changedHitX == null)
            FlxG.save.data.changedHitX = defaultX;
        if (FlxG.save.data.changedHitY == null)
            FlxG.save.data.changedHitY = defaultY;
        if (ratingtheme == 1)
        sick = new FlxSprite().loadGraphic(Paths.image('sick-keold','shared'));
        else if (ratingtheme == 2)
         sick = new FlxSprite().loadGraphic(Paths.image('sick-kenew','shared'));
        else
        sick = new FlxSprite().loadGraphic(Paths.image('sick','shared'));
        sick.scrollFactor.set();
        sick.x = defaultX;
        sick.y = defaultY; 
        if (FlxG.save.data.changedHit)
            {
                if (FlxG.save.data.changedHitX != null && FlxG.save.data.changedHitX)
                sick.x = FlxG.save.data.changedHitX;
                if (FlxG.save.data.changedHitY != null && FlxG.save.data.changedHitY)
                sick.y = FlxG.save.data.changedHitY;
            }
        background = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback','shared'));
        curt = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains','shared'));
        front = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront','shared'));

		persistentUpdate = true;

        super.create();

        camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        FlxG.cameras.add(camHUD);
        FlxG.cameras.reset(camGame);

        background.scrollFactor.set(0.9,0.9);
        curt.scrollFactor.set(1.3,1.3);
        front.scrollFactor.set(0.9,0.9);

        add(background);
        add(front);
        add(curt);

        FlxCamera.defaultCameras = [camGame];

		var camFollow = new FlxObject(0, 0, 1, 1);

        gf = new Character(400, 130, 'gf');
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, 'dad');

        bf = new Boyfriend(770, 450, 'bf');

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x + 400, dad.getGraphicMidpoint().y);

		camFollow.setPosition(camPos.x, camPos.y);
        add(gf);
        add(bf);
        add(dad);
		add(camFollow);
        add(sick);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = 0.9;
		FlxG.camera.focusOn(camFollow.getPosition());

		strumLine = new FlxSprite(0, 0).makeGraphic(FlxG.width, 14);
		strumLine.scrollFactor.set();
        strumLine.alpha = 0.4;

        add(strumLine);
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

        sick.cameras = [camHUD];
        strumLine.cameras = [camHUD];
        playerStrums.cameras = [camHUD];
        
		generateStaticArrows(0);
		generateStaticArrows(1);

        text = new FlxText(-20, 740, "Drag around gameplay elements, R to reset, Escape to go back. Current rating theme: " + ratingthemetext + ' (Left, Right)', 12);
		text.scrollFactor.set();
		text.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        
        blackBorder = new FlxSprite(text.x, text.y + 126).makeGraphic((Std.int(text.width + 500)),Std.int(text.height),FlxColor.BLACK);
		blackBorder.alpha = 0.5;

		add(blackBorder);

		add(text);

        healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
								if (FlxG.save.data.downscroll)
									healthBarBG.y = 50;
								healthBarBG.screenCenter(X);
								healthBarBG.scrollFactor.set();
								add(healthBarBG);
                               // healthBarBG.cameras = [camHUD];
								trace('x: ' + healthBarBG.x + 'y: ' + healthBarBG.y);
				
								healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
								'health', 0, 2);
							healthBar.scrollFactor.set();
							if (FlxG.save.data.healthcolor)
								healthBar.createFilledBar(p2color, p1color);
							else
								healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
							// healthBar
							add(healthBar);
                           // healthBar.cameras = [camHUD];

							iconP1 = new HealthIcon('bf', true);
							iconP1.y = healthBar.y - (iconP1.height / 2);
							iconP1.scrollFactor.set();
							//add(iconP1);
                            iconP1.cameras = [camHUD];
									
					
							iconP2 = new HealthIcon('dad', false);
							iconP2.y = healthBar.y - (iconP2.height / 2);
							iconP2.scrollFactor.set();
							add(iconP2);
                            //iconP2.cameras = [camHUD];
							addedhealthbarshit = true;

        if (!FlxG.save.data.changedHit)
        {
            FlxG.save.data.changedHitX = defaultX;
            FlxG.save.data.changedHitY = defaultY;
        }

        FlxG.mouse.visible = true;

        if (FlxG.save.data.changedHit)
            {
                sick.x = FlxG.save.data.changedHitX;
                sick.y = FlxG.save.data.changedHitY;
                trace(sick.x);
                trace(sick.y);
            }
            else
                {
                    sick.x = defaultX;
                    sick.y = defaultY;
                    trace(sick.x);
                    trace(sick.y);
                }
                reloadhealthbar = true;
    }

    override function update(elapsed:Float) {
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);

        if (addedhealthbarshit)
			{
				if (FlxG.save.data.newhealthheadbump)
					{
					iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, 150, 0.15)));
					iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, 150, 0.15)));
					}
					else
						{
						iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
						iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));
						}
		
				iconP1.updateHitbox();
				iconP2.updateHitbox();
		
				var iconOffset:Int = 26;
		
				iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
				iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
			}

        text.text = "Drag around gameplay elements, R to reset, Escape to go back. Current rating theme: " + ratingthemetext + ' (Left, Right)';

        FlxG.camera.zoom = FlxMath.lerp(0.9, FlxG.camera.zoom, 0.95);
        camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);

        if (FlxG.mouse.overlaps(sick) && FlxG.mouse.pressed)
        {
            sick.x = FlxG.mouse.x - sick.width / 2;
            sick.y = FlxG.mouse.y - sick.height;
        }

        for (i in playerStrums)
            i.y = strumLine.y;
        for (i in strumLineNotes)
            i.y = strumLine.y;

        if (FlxG.mouse.overlaps(sick) && FlxG.mouse.justReleased)
        {
            FlxG.save.data.changedHitX = sick.x;
            FlxG.save.data.changedHitY = sick.y;
            FlxG.save.data.changedHit = true;
            FlxG.save.data.enablesickpositions = true;
            trace(sick.x);
            trace(sick.y);
        }

        if (firstload)
            {
                reloadrating();
                if (FlxG.save.data.changedHit)
                    {
                        sick.x = FlxG.save.data.changedHitX;
                        sick.y = FlxG.save.data.changedHitY;
                        trace(sick.x);
                        trace(sick.y);
                    }
                    else
                        {
                            sick.x = defaultX;
                            sick.y = defaultY;
                            trace(sick.x);
                            trace(sick.y);
                        }
              firstload = false;
            }

        if (FlxG.keys.justPressed.R)
        {
            sick.x = defaultX;
            sick.y = defaultY;
            FlxG.save.data.changedHitX = sick.x;
            FlxG.save.data.changedHitY = sick.y;
            FlxG.save.data.changedHit = false;
            FlxG.save.data.ke142ratings = false;
            FlxG.save.data.ke154ratings = false;
            trace(sick.x);
            trace(sick.y);
            reloadrating();
        }

        #if debug
		if (FlxG.keys.justPressed.C)
			{
				FlxG.camera.zoom += 0.1;
				defaultCamZoom += 0.1;
				camHUD.zoom += 0.1;
			}

			if (FlxG.keys.justPressed.V)
				{
					FlxG.camera.zoom -= 0.1;
					defaultCamZoom -= 0.1;
					camHUD.zoom -= 0.1;
				}
				#end

                if (reloadhealthbar)
                    {
                        remove(healthBarBG);
                        remove(healthBar);
                        remove(iconP1);
                        remove(iconP2);
            
                        healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
                        if (FlxG.save.data.downscroll)
                            healthBarBG.y = 50;
                        healthBarBG.screenCenter(X);
                        healthBarBG.scrollFactor.set();
                        add(healthBarBG);
                       // healthBarBG.cameras = [camHUD];	
            
                        healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
                        'health', 0, 2);
                        trace('x: ' + healthBarBG.x + 'y: ' + healthBarBG.y);
                    healthBar.scrollFactor.set();
                    if (FlxG.save.data.healthcolor)
                        healthBar.createFilledBar(p2color, p1color);
                    else
                        healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
                    // healthBar
                    add(healthBar);
                    //healthBar.cameras = [camHUD];
            
                    iconP1 = new HealthIcon('bf', true);
                    iconP1.y = healthBar.y - (iconP1.height / 2);
                    add(iconP1);
                    //iconP1.cameras = [camHUD];	
                            
            
                    iconP2 = new HealthIcon('dad', false);
                    iconP2.y = healthBar.y - (iconP2.height / 2);
                    add(iconP2);
                   //iconP2.cameras = [camHUD];
                    reloadhealthbar = false;
                    trace('reloaded');	
                    }

        if (controls.BACK)
        {
            FlxG.mouse.visible = false;
            FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new ApperanceOptions());
            FlxG.save.data.changedHitX = sick.x;
            FlxG.save.data.changedHitY = sick.y;
            if (ratingtheme == 0)
                {
                    FlxG.save.data.ke142ratings = false;
                    FlxG.save.data.ke154ratings = false;
                    trace('ur rating theme is ' + ratingthemetext);
                }
            if (ratingtheme == 1)
                {
                    FlxG.save.data.ke142ratings = true;
                    FlxG.save.data.ke154ratings = false;
                    trace('ur rating theme is ' + ratingthemetext);
                }
            if (ratingtheme == 2)
                {
                    FlxG.save.data.ke142ratings = false;
                    FlxG.save.data.ke154ratings = true;
                    trace('ur rating theme is ' + ratingthemetext);  
                }
        }

        if (FlxG.keys.justPressed.RIGHT && ratingtheme >= 0 && ratingtheme < 2)
            {
                ratingtheme += 1;
                reloadrating();
                if (ratingtheme == 0)
                    ratingthemetext = 'Default';
                if (ratingtheme == 1)
                    ratingthemetext = 'Kade Engine 1.4.2';
                if (ratingtheme == 2)
                    ratingthemetext = 'Kade Engine 1.5.4';
            }

        if (FlxG.keys.justPressed.LEFT && ratingtheme > 0 && ratingtheme <= 2)
            {
                ratingtheme -= 1;
                reloadrating();
                if (ratingtheme == 0)
                    ratingthemetext = 'Default';
                if (ratingtheme == 1)
                    ratingthemetext = 'Kade Engine 1.4.2';
                if (ratingtheme == 2)
                    ratingthemetext = 'Kade Engine 1.5.4';
            }

    }

    function reloadrating():Void
        {
         remove(sick);
            if (ratingtheme == 1)
            sick = new FlxSprite().loadGraphic(Paths.image('sick-keold','shared'));
            else if (ratingtheme == 2)
            sick = new FlxSprite().loadGraphic(Paths.image('sick-kenew','shared'));
            else
            sick = new FlxSprite().loadGraphic(Paths.image('sick','shared'));
            sick.scrollFactor.set();
            if (FlxG.save.data.changedHit)
                {
                    sick.x = FlxG.save.data.changedHitX;
                    sick.y = FlxG.save.data.changedHitY;
                }
                else
                 {
                    sick.x = defaultX;
                    sick.y = defaultY;  
                 }
            add(sick);
        }

    override function beatHit() 
    {
        super.beatHit();

        bf.playAnim('idle');
        dad.dance();

        if (curBeat % gfSpeed == 0)
            {
                gf.dance();
            }

        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.010;

        if (addedhealthbarshit)
            {
                iconP1.setGraphicSize(Std.int(iconP1.width + 30));
                iconP2.setGraphicSize(Std.int(iconP2.width + 30));
                iconP1.updateHitbox();
                iconP2.updateHitbox();
            }	

        trace('beat');

    }


    // ripped from play state cuz im lazy
    
	private function generateStaticArrows(player:Int):Void
        {
            for (i in 0...4)
            {
                // FlxG.log.add(i);
                var babyArrow:FlxSprite = new FlxSprite(30, strumLine.y - 100);
                babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
                babyArrow.animation.addByPrefix('green', 'arrowUP');
                babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
                babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
                babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
                babyArrow.antialiasing = true;
                babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
                switch (Math.abs(i))
                {
                    case 0:
                        babyArrow.x += Note.swagWidth * 0;
                        babyArrow.animation.addByPrefix('static', 'arrowLEFT');
                        babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
                    case 1:
                        babyArrow.x += Note.swagWidth * 1;
                        babyArrow.animation.addByPrefix('static', 'arrowDOWN');
                        babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
                    case 2:
                        babyArrow.x += Note.swagWidth * 2;
                        babyArrow.animation.addByPrefix('static', 'arrowUP');
                        babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
                    case 3:
                        babyArrow.x += Note.swagWidth * 3;
                        babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
                        babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
                        babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
                }
                babyArrow.updateHitbox();
                babyArrow.scrollFactor.set();
    
                babyArrow.ID = i;
    
                if (player == 1)
                    playerStrums.add(babyArrow);
    
                babyArrow.animation.play('static');
                babyArrow.x += 50;
                babyArrow.x += ((FlxG.width / 2) * player);
    
                strumLineNotes.add(babyArrow);
            }
        }
}