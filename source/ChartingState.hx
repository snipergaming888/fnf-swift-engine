package;

#if cpp
import Discord.DiscordClient;
#end
import flixel.addons.ui.FlxUIText;
import Conductor.BPMChangeEvent;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import openfl.net.FileReference;
import openfl.net.FileFilter;
import flixel.util.FlxTimer;

using StringTools;

class ChartingState extends MusicBeatState
{
	var _file:FileReference;
	var fr:FileReference;

	var UI_box:FlxUITabMenu;

	/**
	 * Array of notes showing when each section STARTS in STEPS
	 * Usually rounded up??
	 */
	var curSection:Int = 0;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var strumLine:FlxSprite;
	var curSong:String = 'Dadbattle';
	var amountSteps:Int = 0;
	var writingNotesText:FlxText;
	var bullshitUI:FlxGroup;
	var diff:Int = PlayState.storyDifficulty;
	public static var storyDifficultyString:String = "";
	public var mustPress:Bool = false;
	public var canBeHit:Bool = false;

	var highlight:FlxSprite;
	var hasplayed:Bool = false;

	var GRID_SIZE:Int = 40;

	var dummyArrow:FlxSprite;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;

	var gridBG:FlxSprite;
	var gridBlackLine:FlxSprite;

	var _song:SwagSong;

	var typingShit:FlxInputText;
	var typingShit2:FlxInputText;
	var typingShit3:FlxInputText;
	var typingShit4:FlxInputText;
	var typingShit5:FlxInputText;
	/*
	 * WILL BE THE CURRENT / LAST PLACED NOTE
	**/
	var curSelectedNote:Array<Dynamic>;

	var tempBpm:Int = 0;

	var vocals:FlxSound;

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;
	var check_mute_inst:FlxUICheckBox;
	var check_mute_voices:FlxUICheckBox;
	var instVol:FlxUINumericStepper;
	var check_camerashake:FlxUICheckBox;
	var check_gfspeed:FlxUICheckBox;
	var check_playanim:FlxUICheckBox;
	var camerashaketrigger:FlxUINumericStepper;
	var camerazoomtrigger:FlxUINumericStepper;
	var camerazoomtrigger2:FlxUINumericStepper;
	var voicesVol:FlxUINumericStepper;
	var instVoltext:FlxText;
	var camZoomtext:FlxText;
	var camZoomtext2:FlxText;
	var camshaketext:FlxText;
	var camzoomtext:FlxText;
	var camzoomtext2:FlxText;
	var camshaketext2:FlxText;
	var camshaketext3:FlxText;
	var voicesVoltext:FlxText;
	var camzoomtextpercent:FlxText;
	var copylabel:FlxText;
	var bpmtext:FlxText;
	var scrollspeedtext:FlxText;
	var sectionsback:FlxText;
	var flixelcameratext:FlxText;
	var flixelHUDtext:FlxText;
	var gfspeedtext:FlxText;
	var playanimon:FlxText;
	var playanimtext:FlxText;
	var playanimtext2:FlxText;
	var menuBG:FlxSprite;
	var steppercopyfloat:Float = 0;

	override function create()
	{
		//add option to disable camzooming for the section, also add option to have custom zooming (which curbeats to start and end, curbeat %, camzoom and camHUD zoom amount)
		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		switch (diff)
		{
			case 0:
				storyDifficultyString = "easy";
			case 1:
				storyDifficultyString = "normal";
			case 2:
				storyDifficultyString = "hard";
		}
		#if cpp
		DiscordClient.changePresence("Editing " + PlayState.SONG.song + " in the Chart Editor", null, null, true);
		#end

		menuBG.color = 0xFF0026ff;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.scrollFactor.set(0, 0);
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		curSection = lastSection;

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
		add(gridBG);

		leftIcon = new HealthIcon(PlayState.SONG.player1);
		rightIcon = new HealthIcon(PlayState.SONG.player2);
		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.setGraphicSize(0, 45);
		rightIcon.setGraphicSize(0, 45);

		add(leftIcon);
		add(rightIcon);

		leftIcon.setPosition(0, -100);
		rightIcon.setPosition(gridBG.width / 2, -100);

		var gridBlackLine:FlxSprite = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

		if (PlayState.SONG != null)
			_song = PlayState.SONG;
		else
		{
			_song = {
				song: 'Test',
				notes: [],
				bpm: 150,
				needsVoices: true,
				player1: 'bf',
				player2: 'dad',
				stage: 'stage',
				composer: 'Kawai Sprite',
				camzoomamountp1: 0,
				camerashakeamount: 0,
				camerashakeduration: 0,
				camerashaketrigger: 0,
				camerazoomtrigger: 0,
				camerazoomtrigger2: 0,
				flixelcamerazoom: 0,
				flixelHUDzoom: 0,
				sectiongfspeed: 0,
				camerazoompercentinput: 0,
				curbeatzooming: false,
				curstepzooming: false,
				steppernumanim: 0,
				camzoomtime: 0,
				noteskin: 'default',
				
				speed: 1,
				validScore: false
			};
		}

		FlxG.mouse.visible = true;
		FlxG.save.bind('swiftengine', 'snipergaming888');

		tempBpm = _song.bpm;

		addSection();

		// sections = _song.notes;

		updateGrid();

		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		bpmTxt = new FlxText(1000, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();
		add(bpmTxt);

		strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(FlxG.width / 2), 4);
		add(strumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		var tabs = [
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Effects", label: 'Effects'},
			{name: "Note", label: 'Note'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 680); // 300, 400
		UI_box.x = FlxG.width / 2;
		UI_box.y = 20;
		add(UI_box);

		addSongUI();
		addSectionUI();
		addNoteUI();
		addEffectsUI();

		add(curRenderedNotes);
		add(curRenderedSustains);
		updateHeads();

		super.create();
	}

	function addSongUI():Void
	{
		var UI_songTitle = new FlxUIInputText(10, 10, 70, _song.song, 8);
		typingShit = UI_songTitle;

		var UI_songDifficulty = new FlxUIInputText(10, 25, 70, storyDifficultyString, 8);
		typingShit2 = UI_songDifficulty;

		var UI_songComposer = new FlxUIInputText(10, 40, 70, _song.composer, 8);
		typingShit3 = UI_songComposer;

		var check_voices = new FlxUICheckBox(10, 55, null, null, "Has voice track", 100);
		check_voices.checked = _song.needsVoices;
		// _song.needsVoices = check_voices.checked;
		check_voices.callback = function()
		{
			_song.needsVoices = check_voices.checked;
			trace('CHECKED!');
		};

		check_mute_inst = new FlxUICheckBox(10, 120, null, null, "Mute Instrumental (in editor)", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_inst.checked)
				vol = 0;

			FlxG.sound.music.volume = vol;
		};

		check_mute_voices = new FlxUICheckBox(10, 135, null, null, "Mute Voices (in editor)", 100);
		check_mute_voices.checked = false;
		check_mute_voices.callback = function()
		{
			var vol:Float = 1;

			if (check_mute_voices.checked)
				vol = 0;

			vocals.volume = vol;
		};

		instVol = new FlxUINumericStepper(10, 180, 0.1, 1, 0.1, 1, 1);
		instVol.value = 1;
		instVol.name = 'inst_volume';

		instVoltext = new FlxText(75, 180, "Instrumental Volume", 12);
		instVoltext.scrollFactor.set();
		instVoltext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

		voicesVol = new FlxUINumericStepper(10, 195, 0.1, 1, 0.1, 1, 1);
		voicesVol.value = 1;
		voicesVol.name = 'voices_volume';

		voicesVoltext = new FlxText(75, 195, "Voices Volume", 12);
		voicesVoltext.scrollFactor.set();
		voicesVoltext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

		bpmtext = new FlxText(75, 80, "BPM", 12);
		bpmtext.scrollFactor.set();
		bpmtext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

		scrollspeedtext = new FlxText(75, 95, "Scroll Speed", 12);
		scrollspeedtext.scrollFactor.set();
		scrollspeedtext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

		var saveButton:FlxButton = new FlxButton(110, 7, "Save", function()
		{
			saveLevel();
		});

		var reloadSong:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload Audio", function()
		{
			loadSong(_song.song);
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, saveButton.y + 30, "Reload JSON", function()
		{
			loadJson(_song.song.toLowerCase());
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'Load Autosave', loadAutosave);

		var loadjsonButton:FlxButton = new FlxButton(loadAutosaveBtn.x, loadAutosaveBtn.y + 30, "Load JSON", _onClick);

		var clearSongButton:FlxButton = new FlxButton(loadAutosaveBtn.x, loadAutosaveBtn.y + 60, "Clear Song", clearSong);

		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(10, 95, 0.1, 1, 0.1, 10, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(10, 80, 1, 1, 1, 1000, 0);
		stepperBPM.value = Conductor.bpm;                                            ///339
		stepperBPM.name = 'song_bpm';

		var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));
		var stages:Array<String> = CoolUtil.coolTextFile(Paths.txt('stageList'));
		var noteskins:Array<String> = CoolUtil.coolTextFile(Paths.txt('noteskinList'));

		var player1DropDown = new FlxUIDropDownMenu(10, 235, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player1 = characters[Std.parseInt(character)];
		});
		player1DropDown.selectedLabel = _song.player1;

		var player1Label = new FlxText(10,215,64,'Player 1');

		var player2DropDown = new FlxUIDropDownMenu(155, 235, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			_song.player2 = characters[Std.parseInt(character)];
		});

		var player2Label = new FlxText(140,215,64,'Player 2');

		var stageDropDown = new FlxUIDropDownMenu(155, 280, FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(stage:String)
			{
				_song.stage = stages[Std.parseInt(stage)];
			});
		stageDropDown.selectedLabel = _song.stage;
		
		var stageLabel = new FlxText(140,260,64,'Stage');

		var noteskinDropDown = new FlxUIDropDownMenu(10, 280, FlxUIDropDownMenu.makeStrIdLabelArray(noteskins, true), function(noteskin:String)
			{
				_song.noteskin = noteskins[Std.parseInt(noteskin)];
				updateGrid();
			    updateSectionUI();
			});
		noteskinDropDown.selectedLabel = _song.noteskin;
		
		var noteskinLabel = new FlxText(10,260,64,'Noteskin');

		player2DropDown.selectedLabel = _song.player2;

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";
		tab_group_song.add(UI_songTitle);
		tab_group_song.add(UI_songDifficulty);
		tab_group_song.add(UI_songComposer);

		tab_group_song.add(check_voices);
		tab_group_song.add(check_mute_inst);
		tab_group_song.add(check_mute_voices);
		tab_group_song.add(instVol);
		tab_group_song.add(instVoltext);
		tab_group_song.add(voicesVol);
		tab_group_song.add(voicesVoltext);
		tab_group_song.add(bpmtext);
		tab_group_song.add(scrollspeedtext);
		tab_group_song.add(saveButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(clearSongButton);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(stageLabel);
		tab_group_song.add(player1DropDown);
		tab_group_song.add(player2DropDown);
		tab_group_song.add(stageDropDown);
		tab_group_song.add(player1Label);
		tab_group_song.add(player2Label);
		tab_group_song.add(loadjsonButton);
		tab_group_song.add(noteskinDropDown);
		tab_group_song.add(noteskinLabel);

		UI_box.addGroup(tab_group_song);
		UI_box.scrollFactor.set();

		FlxG.camera.follow(strumLine);
	}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_shakegamecamera:FlxUICheckBox;
	var check_shakeHUD:FlxUICheckBox;
	var check_playnoisemusthit:FlxUICheckBox;
	var check_playnoisemusthitdad:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var check_camzoomonp1:FlxUICheckBox;
	var check_disablecamzooming:FlxUICheckBox;
	var check_camzooming:FlxUICheckBox;
	var check_curbeatzooming:FlxUICheckBox;
	var check_curstepzooming:FlxUICheckBox;
	var curstepzooming:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var camzoomamountp1:FlxUINumericStepper;
	var camerashakeamount:FlxUINumericStepper;
	var camerashakeduration:FlxUINumericStepper;
	var camzoomtime:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;
	var check_curbeatanim:FlxUICheckBox;
	var check_isforced:FlxUICheckBox;
	var check_curstepanim:FlxUICheckBox;
	var check_altAnim2:FlxUICheckBox;
	var check_islooped:FlxUICheckBox;
	var check_crossfade:FlxUICheckBox;
	var camerazoompercentinput:FlxUINumericStepper;
	var flixelcamerazoom:FlxUINumericStepper;
	var flixelHUDzoom:FlxUINumericStepper;
	var currentgfspeed:FlxUINumericStepper;
	var steppernumanim:FlxUINumericStepper;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		sectionsback = new FlxText(180, 130, "Sections Back", 12);
		sectionsback.scrollFactor.set();
		sectionsback.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);


		stepperLength = new FlxUINumericStepper(10, 10, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSection].lengthInSteps;
		stepperLength.name = "section_length";

		stepperSectionBPM = new FlxUINumericStepper(10, 110, 1, Conductor.bpm, 0, 999, 0);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';

		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(110, 130, 1, 1, -999, 999, 0);

		var copyButton:FlxButton = new FlxButton(10, 130, "Copy last section", function()
		{
			copySection(Std.int(stepperCopy.value));
		});

		var clearSectionButton:FlxButton = new FlxButton(10, 150, "Clear Section", clearSection);

		var swapSection:FlxButton = new FlxButton(10, 170, "Swap section", function()
		{
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				var note = _song.notes[curSection].sectionNotes[i];
				note[1] = (note[1] + 4) % 8;
				_song.notes[curSection].sectionNotes[i] = note;
				updateGrid();
			}
		});

		check_playnoisemusthit = new FlxUICheckBox(10, 190, null, null, "Play Noise (P1)", 100);
		check_playnoisemusthit.name = '	check_playnoisemusthit';
		check_playnoisemusthit.checked = false;

		check_playnoisemusthitdad = new FlxUICheckBox(10, 210, null, null, "Play Noise (P2)", 100);
		check_playnoisemusthitdad.name = '	check_playnoisemusthitdad';
		check_playnoisemusthitdad.checked = false;

		check_mustHitSection = new FlxUICheckBox(10, 30, null, null, "Camera Focuses on Player 1", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = true;
		// _song.needsVoices = check_mustHit.checked;

		check_changeBPM = new FlxUICheckBox(10, 90, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';

		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(sectionsback);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(swapSection);
		tab_group_section.add(check_playnoisemusthit);
		tab_group_section.add(check_playnoisemusthitdad);

		UI_box.addGroup(tab_group_section);
	}

	function addEffectsUI():Void
		{
			var stepperCopydata:FlxUINumericStepper = new FlxUINumericStepper(225, 120, 1, 1, -999, 999, 0);

			var copyButton:FlxButton = new FlxButton(215, 100, "Copy Data", function()
			{
				copylastsectiondata(Std.int(stepperCopydata.value));
			});

			copylabel = new FlxText(225, 140, "Section", 12);
			copylabel.scrollFactor.set();
			copylabel.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, CENTER);

			var tab_group_effects = new FlxUI(null, UI_box);
			tab_group_effects.name = 'Effects';
	
			check_camzoomonp1 = new FlxUICheckBox(10, 0, null, null, 'Camera Zoom', 100);
			check_camzoomonp1.name = 'check_camzoomonp1';
			check_camzoomonp1.checked = false;
	
			camzoomamountp1 = new FlxUINumericStepper(10, 20, 0.1, 100, 0, 999, 1);
			camzoomamountp1.value = _song.notes[curSection].camzoomamountp1;
			camzoomamountp1.name = 'camzoomamountp1';
	
			camzoomtime = new FlxUINumericStepper(150, 20, 1, 8, 0, 999, 0);
			camzoomtime.value = _song.notes[curSection].camzoomtime;
			camzoomtime.name = 'camzoomtime';
	
			camZoomtext = new FlxText(67, 20, "Zoom amount", 12);
			camZoomtext.scrollFactor.set();
			camZoomtext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);
	
			camZoomtext2 = new FlxText(208, 20, "Zoom Time" +"\n(stepCrochets)", 12);
			camZoomtext2.scrollFactor.set();
			camZoomtext2.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			check_camerashake = new FlxUICheckBox(10, 40, null, null, 'Camera Shake', 100);
			check_camerashake.name = 'check_camerashake';
			check_camerashake.checked = false;

			check_shakegamecamera = new FlxUICheckBox(120, 40, null, null, 'Shake game cam', 100);
			check_shakegamecamera.name = 'check_shakegamecamera';
			check_shakegamecamera.checked = false;

			check_shakeHUD = new FlxUICheckBox(225, 70, null, null, 'Shake HUD', 100);
			check_shakeHUD.name = 'check_shakeHUD';
			check_shakeHUD.checked = false;

			camerashaketrigger = new FlxUINumericStepper(10, 60, 1, 8, 0, 999, 0);
			camerashaketrigger.value = _song.notes[curSection].camerashaketrigger;
			camerashaketrigger.name = 'camerashaketrigger';

			camshaketext = new FlxText(67, 60, "curstep to trigger" +"\n(Must be in this section)", 12);
			camshaketext.scrollFactor.set();
			camshaketext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			camerashakeamount = new FlxUINumericStepper(10, 80, 0.01, 100, 0, 999, 2);
			camerashakeamount.value = _song.notes[curSection].camerashakeamount;
			camerashakeamount.name = 'camerashakeamount';

			camshaketext2 = new FlxText(67, 80, "Shake Amount", 12);
			camshaketext2.scrollFactor.set();
			camshaketext2.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			camerashakeduration = new FlxUINumericStepper(10, 100, 0.1, 100, 0, 999, 1);
			camerashakeduration.value = _song.notes[curSection].camerashakeduration;
			camerashakeduration.name = 'camerashakeduration';

			camshaketext3 = new FlxText(67, 100, "Shake Duration", 12);
			camshaketext3.scrollFactor.set();
			camshaketext3.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);
			
			check_disablecamzooming = new FlxUICheckBox(10, 120, null, null, 'Disable Camzooming', 100);
			check_disablecamzooming.name = 'check_disablecamzooming';
			check_disablecamzooming.checked = false;

			check_camzooming = new FlxUICheckBox(10, 140, null, null, 'Additional Camzooming', 100);
			check_camzooming.name = 'check_camzooming';
			check_camzooming.checked = false;

			check_curstepzooming = new FlxUICheckBox(10, 160, null, null, 'Use curStep', 100);
			check_curstepzooming.name = 'check_curstepzooming';
			check_curstepzooming.checked = false;

			check_curbeatzooming = new FlxUICheckBox(10, 180, null, null, 'Use curBeat', 100);
			check_curbeatzooming.name = 'check_curbeatzooming';
			check_curbeatzooming.checked = false;

			camerazoomtrigger = new FlxUINumericStepper(10, 200, 1, 8, 0, 999, 0);
			camerazoomtrigger.value = _song.notes[curSection].camerazoomtrigger;
			camerazoomtrigger.name = 'camerazoomtrigger';

			camzoomtext = new FlxText(67, 200, "Beginning curstep/curbeat" +"\n(Must be in this section)", 12);
			camzoomtext.scrollFactor.set();
			camzoomtext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			camerazoomtrigger2 = new FlxUINumericStepper(10, 225, 1, 8, 0, 999, 0);
			camerazoomtrigger2.value = _song.notes[curSection].camerazoomtrigger2;
			camerazoomtrigger2.name = 'camerazoomtrigger2';

			camzoomtext2 = new FlxText(67, 225, "Ending curstep/curbeat" +"\n(Must be in this section)", 12);
			camzoomtext2.scrollFactor.set();
			camzoomtext2.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			camerazoompercentinput = new FlxUINumericStepper(10, 250, 1, 8, 0, 999, 0);
			camerazoompercentinput.value = _song.notes[curSection].camerazoompercentinput;
			camerazoompercentinput.name = 'camerazoompercentinput';

			camzoomtextpercent = new FlxText(67, 250, "CurBeat/curStep percentage", 12);
			camzoomtextpercent.scrollFactor.set();
			camzoomtextpercent.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			flixelcamerazoom = new FlxUINumericStepper(10, 270, 0.001, 8, 0, 999, 3);
			flixelcamerazoom.value = _song.notes[curSection].flixelcamerazoom;
			flixelcamerazoom.name = 'flixelcamerazoom';

			flixelcameratext = new FlxText(67, 270, "Camera zoom amount", 12);
			flixelcameratext.scrollFactor.set();
			flixelcameratext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			flixelHUDzoom = new FlxUINumericStepper(10, 290, 0.001, 8, 0, 999, 3);
			flixelHUDzoom.value = _song.notes[curSection].flixelHUDzoom;
			flixelHUDzoom.name = 'flixelHUDzoom';

			flixelHUDtext = new FlxText(67, 290, "CamHUD zoom amount", 12);
			flixelHUDtext.scrollFactor.set();
			flixelHUDtext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			check_gfspeed = new FlxUICheckBox(10, 310, null, null, 'Set GF Speed', 100);
			check_gfspeed.name = 'check_gfspeed';
			check_gfspeed.checked = false;

			currentgfspeed = new FlxUINumericStepper(10, 330, 1, 8, 1, 999, 1);
			currentgfspeed.value = _song.notes[curSection].sectiongfspeed;
			currentgfspeed.name = 'currentgfspeed';

			gfspeedtext = new FlxText(67, 330, "GF speed amount", 12);
			gfspeedtext.scrollFactor.set();
			gfspeedtext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			check_altAnim = new FlxUICheckBox(10, 370, null, null, "Alternate Animation (P2)", 100);
		    check_altAnim.name = 'check_altAnim';

			check_altAnim2 = new FlxUICheckBox(10, 350, null, null, "Alternate Animation (P1)", 100);
		    check_altAnim2.name = 'check_altAnim';

			check_playanim = new FlxUICheckBox(10, 390, null, null, 'Play animation', 100);
			check_playanim.name = 'check_playanim';
			check_playanim.checked = _song.notes[curSection].playanim;

			check_curstepanim = new FlxUICheckBox(10, 410, null, null, 'On curStep', 100);
			check_curstepanim.name = 'check_curstepanim';
			check_curstepanim.checked = _song.notes[curSection].curstepanim;

			check_curbeatanim = new FlxUICheckBox(10, 430, null, null, 'On curBeat', 100);
			check_curbeatanim.name = 'check_curbeatanim';
			check_curbeatanim.checked = _song.notes[curSection].curbeatanim;

			steppernumanim = new FlxUINumericStepper(10, 450, 1, 8, 1, 999, 1);
			steppernumanim.value = _song.notes[curSection].steppernumanim;
			steppernumanim.name = 'steppernumanim';
			
			playanimon = new FlxText(67, 450, "CurStep/curBeat to play animation", 12);
			playanimon.scrollFactor.set();
			playanimon.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			var UI_AnimtoPlay = new FlxUIInputText(10, 470, 70, "", 8);
			typingShit4 = UI_AnimtoPlay;

			playanimtext = new FlxText(80, 470, "Animation name", 12);
			playanimtext.scrollFactor.set();
			playanimtext.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			var UI_charactertoplayon = new FlxUIInputText(10, 490, 70, "", 8);
			typingShit5 = UI_charactertoplayon;

			playanimtext2 = new FlxText(80, 490, "Character name (dad, boyfriend, gf)", 12);
			playanimtext2.scrollFactor.set();
			playanimtext2.setFormat("Pixel Arial 11 Bold", 8, FlxColor.WHITE, LEFT);

			check_isforced = new FlxUICheckBox(10, 510, null, null, 'Forced', 100);
			check_isforced.name = 'check_isforced';
			check_isforced.checked = _song.notes[curSection].isforced;

			check_islooped = new FlxUICheckBox(10, 530, null, null, 'Looped', 100);
			check_islooped.name = 'check_isforced';
			check_islooped.checked = _song.notes[curSection].islooped;

			check_crossfade = new FlxUICheckBox(10, 560, null, null, 'CrossFade', 100);
			check_crossfade.name = 'check_crossfade';
			check_crossfade.checked = _song.notes[curSection].crossFade;
			
	
	
			tab_group_effects.add(check_camzoomonp1);
			tab_group_effects.add(camzoomamountp1);
			tab_group_effects.add(camerashakeamount);
			tab_group_effects.add(camzoomtime);
			tab_group_effects.add(camZoomtext);
			tab_group_effects.add(camZoomtext2);
			tab_group_effects.add(check_camerashake);
			tab_group_effects.add(camerashaketrigger);
			tab_group_effects.add(camshaketext);
			tab_group_effects.add(camshaketext2);
			tab_group_effects.add(camshaketext3);
			tab_group_effects.add(camerashakeduration);
			tab_group_effects.add(check_disablecamzooming);
			tab_group_effects.add(check_camzooming);
			tab_group_effects.add(camerazoomtrigger);
			tab_group_effects.add(camerazoomtrigger2);
			tab_group_effects.add(camzoomtext);
			tab_group_effects.add(camzoomtext2);
			tab_group_effects.add(check_curstepzooming);
			tab_group_effects.add(check_curbeatzooming);
			tab_group_effects.add(camerazoompercentinput);
			tab_group_effects.add(camzoomtextpercent);
			tab_group_effects.add(copyButton);
			tab_group_effects.add(stepperCopydata);
			tab_group_effects.add(copylabel);
			tab_group_effects.add(flixelcamerazoom);
			tab_group_effects.add(flixelHUDzoom);
			tab_group_effects.add(flixelcameratext);
			tab_group_effects.add(flixelHUDtext);
			tab_group_effects.add(check_gfspeed);
			tab_group_effects.add(currentgfspeed);
			tab_group_effects.add(gfspeedtext);
			tab_group_effects.add(check_altAnim);
			tab_group_effects.add(check_altAnim2);
			tab_group_effects.add(check_playanim);
			tab_group_effects.add(check_curbeatanim);
			tab_group_effects.add(check_curstepanim);
			tab_group_effects.add(steppernumanim);
			tab_group_effects.add(playanimon);
			tab_group_effects.add(UI_AnimtoPlay);
			tab_group_effects.add(playanimtext);
			tab_group_effects.add(UI_charactertoplayon);
			tab_group_effects.add(playanimtext2);
			tab_group_effects.add(check_isforced);
			tab_group_effects.add(check_islooped);
			tab_group_effects.add(check_crossfade);
			tab_group_effects.add(check_shakegamecamera);
			tab_group_effects.add(check_shakeHUD);
	
			UI_box.addGroup(tab_group_effects);
		}

	var stepperSusLength:FlxUINumericStepper;

	function addNoteUI():Void
	{
		var tab_group_note = new FlxUI(null, UI_box);
		tab_group_note.name = 'Note';

		writingNotesText = new FlxUIText(20,100, 0, "");
		writingNotesText.setFormat("Arial",20,FlxColor.WHITE,FlxTextAlign.LEFT,FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		stepperSusLength = new FlxUINumericStepper(10, 10, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 16);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		var applyLength:FlxButton = new FlxButton(100, 10, 'Apply');

		tab_group_note.add(writingNotesText);
		tab_group_note.add(stepperSusLength);
		tab_group_note.add(applyLength);

		UI_box.addGroup(tab_group_note);
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}

		FlxG.sound.playMusic(Paths.inst(daSong), 0.6);

		// WONT WORK FOR TUTORIAL OR TEST SONG!!! REDO LATER
		vocals = new FlxSound().loadEmbedded(Paths.voices(daSong));
		FlxG.sound.list.add(vocals);

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.onComplete = function()
		{
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}

	function generateUI():Void
	{
		while (bullshitUI.members.length > 0)
		{
			bullshitUI.remove(bullshitUI.members[0], true);
		}

		// general shit
		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
		/* 
			var loopCheck = new FlxUICheckBox(UI_box.x + 10, UI_box.y + 50, null, null, "Loops", 100, ['loop check']);
			loopCheck.checked = curNoteSelected.doesLoop;
			tooltips.add(loopCheck, {title: 'Section looping', body: "Whether or not it's a simon says style section", style: tooltipType});
			bullshitUI.add(loopCheck);

		 */
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label)
			{
				case 'Camera Focuses on Player 1':
					_song.notes[curSection].mustHitSection = check.checked;

					updateHeads();

				case 'Change BPM':
					_song.notes[curSection].changeBPM = check.checked;
					trace('changed bpm shit');
				case 'Camera Zoom':
					_song.notes[curSection].camzoomonp1 = check.checked;
				case "Alternate Animation (P2)":
					_song.notes[curSection].altAnim = check.checked;
				case "Alternate Animation (P1)":
					_song.notes[curSection].altAnim2 = check.checked;	
				case "Camera Shake":
					_song.notes[curSection].camerashake = check.checked;
				case "Disable Camzooming":
					_song.notes[curSection].disablecamzooming = check.checked;
				case "Additional Camzooming":
					_song.notes[curSection].camzooming = check.checked;
				case "Use curBeat":
				    _song.notes[curSection].curbeatzooming = check.checked;
				case "Use curStep":
					_song.notes[curSection].curstepzooming = check.checked;
				case "On curBeat":
				    _song.notes[curSection].curbeatanim = check.checked;
				case "On curStep":
					_song.notes[curSection].curstepanim = check.checked;
				case "Set GF Speed":
					_song.notes[curSection].gfspeed = check.checked;
				case "Play animation":
					_song.notes[curSection].playanim = check.checked;
				case "Forced":
					_song.notes[curSection].isforced = check.checked;
				case "Looped":
					_song.notes[curSection].islooped = check.checked;
				case "CrossFade":
					_song.notes[curSection].crossFade = check.checked;		
				case "Shake game camera":	
				    _song.notes[curSection].shakegamecamera = check.checked;
				case "Shake HUD":	
				    _song.notes[curSection].shakeHUD = check.checked;					
			}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			trace(wname);
			if (wname == 'section_length')
			{
				_song.notes[curSection].lengthInSteps = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_speed')
			{
				_song.speed = nums.value;
			}
			else if (wname == 'song_bpm')
			{
				tempBpm = Std.int(nums.value);
				Conductor.mapBPMChanges(_song);
				Conductor.changeBPM(Std.int(nums.value));
				updateGrid();
			}
			else if (wname == 'note_susLength')
			{
				curSelectedNote[2] = nums.value;
				updateGrid();
			}
			else if (wname == 'section_bpm')
			{
				_song.notes[curSection].bpm = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'camzoomamountp1')
				{
					_song.notes[curSection].camzoomamountp1 = nums.value;
					updateGrid();
				}
			else if (wname == 'camerashakeamount')
				{
					_song.notes[curSection].camerashakeamount = nums.value;
					updateGrid();
				}
			else if (wname == 'camerashakeduration')
				{
					_song.notes[curSection].camerashakeduration = nums.value;
					updateGrid();
				}
			else if (wname == 'camzoomtime')
				{
					_song.notes[curSection].camzoomtime = nums.value;
					updateGrid();
				}
			else if (wname == 'camerashaketrigger')
				{
					_song.notes[curSection].camerashaketrigger = nums.value;
					updateGrid();
				}
			else if (wname == 'camerazoomtrigger')
				{
					_song.notes[curSection].camerazoomtrigger = nums.value;
					updateGrid();
				}
			else if (wname == 'camerazoomtrigger2')
				{
					_song.notes[curSection].camerazoomtrigger2 = nums.value;
					updateGrid();
				}
			else if (wname == 'camerazoompercentinput')
				{
					_song.notes[curSection].camerazoompercentinput = nums.value;
					updateGrid();
				}
			else if (wname == 'flixelcamerazoom')
				{
					_song.notes[curSection].flixelcamerazoom = nums.value;
					updateGrid();
				}
			else if (wname == 'flixelHUDzoom')
				{
					_song.notes[curSection].flixelHUDzoom = nums.value;
					updateGrid();
				}
			else if (wname == 'currentgfspeed')
				{
					_song.notes[curSection].sectiongfspeed = Std.int(nums.value);
					updateGrid();
				}
			else if (wname == 'steppernumanim')
				{
					_song.notes[curSection].steppernumanim = nums.value;
					updateGrid();
				}
		}
		
		// FlxG.log.add(id + " WEED " + sender + " WEED " + data + " WEED " + params);
	}

	var updatedSection:Bool = false;

	/* this function got owned LOL
		function lengthBpmBullshit():Float
		{
			if (_song.notes[curSection].changeBPM)
				return _song.notes[curSection].lengthInSteps * (_song.notes[curSection].bpm / _song.bpm);
			else
				return _song.notes[curSection].lengthInSteps;
	}*/
	function sectionStartTime():Float
	{
		var daBPM:Int = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection)
		{
			if (_song.notes[i].changeBPM)
			{
				daBPM = _song.notes[i].bpm;
			}
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	var writingNotes:Bool = false;

	override function update(elapsed:Float)
	{
		//steppercopyfloat = stepperCopydata.value;
		curStep = recalculateSteps();

		Conductor.songPosition = FlxG.sound.music.time;
		_song.song = typingShit.text;
		storyDifficultyString = typingShit2.text;
		_song.composer = typingShit3.text;
		_song.notes[curSection].animtoplay = typingShit4.text; 
		_song.notes[curSection].charactertoplayon = typingShit5.text; 

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps));

		if (curBeat % 4 == 0 && curStep >= 16 * (curSection + 1))
		{
			trace(curStep);
			trace((_song.notes[curSection].lengthInSteps) * (curSection + 1));
			trace('DUMBSHIT');

			if (_song.notes[curSection + 1] == null)
			{
				addSection();
			}

			changeSection(curSection + 1, false);
		}

		if (FlxG.keys.justPressed.Z && UI_box.selected_tab == 1)
			{
				writingNotes = !writingNotes;
			}

			if (writingNotes)
				writingNotesText.text = "WRITING NOTES";
			else if (!writingNotes)
				writingNotesText.text = "";

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if ((upP || rightP || downP || leftP) && writingNotes)
			{
				for(i in 0...controlArray.length)
				{
					if (controlArray[i])
					{
						for (n in 0..._song.notes[curSection].sectionNotes.length)
							{
								var note = _song.notes[curSection].sectionNotes[n];
								if (note == null)
									continue;
								if (note[0] == Conductor.songPosition && note[1] % 4 == i)
								{
									trace('GAMING');
									_song.notes[curSection].sectionNotes.remove(note);
								}
							}
						trace('adding note');
						_song.notes[curSection].sectionNotes.push([Conductor.songPosition, i, 0]);
						updateGrid();
					}
				}
	
			}

	

		/*if (strumLine.overlaps(curRenderedNotes) && check_playnoisemusthit.checked)
			{
				curRenderedNotes.forEach(function(note:Note)
					{
						//if (strumLine.overlaps(note))
						if (strumLine.overlaps(note) && strumLine.y > note.y && !note.hasplayed)
						{
							if (check_mustHitSection.checked && FlxG.sound.music.playing)
							{
								FlxG.sound.play(Paths.sound('normal-hitnormal'));
								note.hasplayed = true;
							}
						}
					});
			}*/

			/*if (strumLine.overlaps(curRenderedNotes) && check_playnoisemusthitdad.checked)
				{
					curRenderedNotes.forEach(function(note:Note)
						{
							//if (strumLine.overlaps(note))
							if (strumLine.overlaps(note) && strumLine.y > note.y && !note.hasplayed)
							{
								if (!check_mustHitSection.checked && FlxG.sound.music.playing)
								{
									FlxG.sound.play(Paths.sound('normal-hitnormal'));
									note.hasplayed = true;
								}
							}
						});
				}*/

				if (strumLine.overlaps(curRenderedNotes) && check_playnoisemusthitdad.checked)
					{
						curRenderedNotes.forEach(function(note:Note)
							{
								//if (strumLine.overlaps(note))
								if (strumLine.overlaps(note) && strumLine.y > note.y && !note.hasplayed)
								{
									if (FlxG.sound.music.playing)
									{
										{
												{
													if (note.noteData < 4 && !_song.notes[curSection].mustHitSection)
														{
															trace('hit ' + Math.abs(note.noteData));
															FlxG.sound.play(Paths.sound('normal-hitnormal'));
															note.hasplayed = true;
														}
														else if (note.noteData >= 4 && _song.notes[curSection].mustHitSection)
															{
																trace('hit ' + Math.abs(note.noteData));
																FlxG.sound.play(Paths.sound('normal-hitnormal'));
																note.hasplayed = true;
															}
												}
										}
									}
								}
							});
					}

					if (strumLine.overlaps(curRenderedNotes) && check_playnoisemusthit.checked)
						{
							curRenderedNotes.forEach(function(note:Note)
								{
									//if (strumLine.overlaps(note))
									if (strumLine.overlaps(note) && strumLine.y > note.y && !note.hasplayed)
									{
										if (FlxG.sound.music.playing)
										{ 
												{
													if (note.noteData < 4 && _song.notes[curSection].mustHitSection)
													{
														trace('must hit ' + Math.abs(note.noteData));
														FlxG.sound.play(Paths.sound('normal-hitnormal'));
														note.hasplayed = true;
													}
													if (note.noteData >= 4 && !_song.notes[curSection].mustHitSection)
													{
														trace('must hit ' + Math.abs(note.noteData));
														FlxG.sound.play(Paths.sound('normal-hitnormal'));
														note.hasplayed = true;
													}
												}
										}
									}
								});
						}

				/*curRenderedNotes.forEach(function(note:Note) {
			if (strumLine.overlaps(note) && strumLine.y == note.y) // yandere dev type shit
			{
				if (_song.notes[curSection].mustHitSection)
					{
						trace('must hit ' + Math.abs(note.noteData));
						if (note.noteData < 4)
						{
							switch (Math.abs(note.noteData))
							{
								case 2:
									player1.playAnim('singUP', true);
								case 3:
									player1.playAnim('singRIGHT', true);
								case 1:
									player1.playAnim('singDOWN', true);
								case 0:
									player1.playAnim('singLEFT', true);
							}
						}
						if (note.noteData >= 4)
						{
							switch (note.noteData)
							{
								case 6:
									player2.playAnim('singUP', true);
								case 7:
									player2.playAnim('singRIGHT', true);
								case 5:
									player2.playAnim('singDOWN', true);
								case 4:
									player2.playAnim('singLEFT', true);
							}
						}
					}
					else
					{
						trace('hit ' + Math.abs(note.noteData));
						if (note.noteData < 4)
						{
							switch (Math.abs(note.noteData))
							{
								case 2:
									player2.playAnim('singUP', true);
								case 3:
									player2.playAnim('singRIGHT', true);
								case 1:
									player2.playAnim('singDOWN', true);
								case 0:
									player2.playAnim('singLEFT', true);
							}
						}
						if (note.noteData >= 4)
						{
							switch (note.noteData)
							{
								case 6:
									player1.playAnim('singUP', true);
								case 7:
									player1.playAnim('singRIGHT', true);
								case 5:
									player1.playAnim('singDOWN', true);
								case 4:
									player1.playAnim('singLEFT', true);
							}
						}
					}
			}
		});*/

		#if cpp
		DiscordClient.changePresence("Editing " + PlayState.SONG.song + " in the Chart Editor" + " | " + "Position: " + Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2)) + " / " + Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2)) + " | Section " + curSection , null, null, true);
		#end

		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(curRenderedNotes))
			{
				curRenderedNotes.forEach(function(note:Note)
				{
					if (FlxG.mouse.overlaps(note))
					{
						if (FlxG.keys.pressed.CONTROL)
						{
							selectNote(note);
						}
						else
						{
							trace('tryin to delete note...');
							deleteNote(note);
						}
					}
				});
			}
			else
			{
				if (FlxG.mouse.x > gridBG.x
					&& FlxG.mouse.x < gridBG.x + gridBG.width
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
				{
					trace('added note');
					addNote();
				}
			}
		}

		if (FlxG.mouse.x > gridBG.x
			&& FlxG.mouse.x < gridBG.x + gridBG.width
			&& FlxG.mouse.y > gridBG.y
			&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
		{
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
			if (FlxG.keys.pressed.SHIFT)
				dummyArrow.y = FlxG.mouse.y;
			else
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
		}

		if (FlxG.keys.justPressed.ENTER)
			{
				lastSection = curSection;
	
				PlayState.SONG = _song;
				FlxG.sound.music.stop();
				vocals.stop();
				PlayState.triggeredalready = false;	
				LoadingState.loadAndSwitchState(new PlayState());
			}

		if (!typingShit.hasFocus || !typingShit2.hasFocus || !typingShit3.hasFocus || !typingShit4.hasFocus || !typingShit5.hasFocus)
		{
			if (FlxG.keys.justPressed.SPACE)
			{
				if (FlxG.sound.music.playing)
				{
					FlxG.sound.music.pause();
					vocals.pause();
				}
				else
				{
					vocals.play();
					FlxG.sound.music.play();
				}
			}

			if (FlxG.keys.justPressed.ALT)
			{
				if (FlxG.keys.pressed.SHIFT)
					resetSection(true);
				else
					resetSection();
			}

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.4);
				vocals.time = FlxG.sound.music.time;
			}

			if (!FlxG.keys.pressed.SHIFT)
			{
				if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = 700 * FlxG.elapsed;

					if (FlxG.keys.pressed.W)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
			else
			{
				if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
				{
					FlxG.sound.music.pause();
					vocals.pause();

					var daTime:Float = Conductor.stepCrochet * 2;

					if (FlxG.keys.justPressed.UP)
					{
						FlxG.sound.music.time -= daTime;
					}
					else
						FlxG.sound.music.time += daTime;

					vocals.time = FlxG.sound.music.time;
				}
			}
		
				if (FlxG.keys.justPressed.E)
				{
					changeNoteSustain(Conductor.stepCrochet);
				}
				if (FlxG.keys.justPressed.Q)
				{
					changeNoteSustain(-Conductor.stepCrochet);
				}
		
				if (FlxG.keys.justPressed.TAB)
				{
					if (FlxG.keys.pressed.SHIFT)
					{
						UI_box.selected_tab -= 1;
						if (UI_box.selected_tab < 0)
							UI_box.selected_tab = 2;
					}
					else
					{
						UI_box.selected_tab += 1;
						if (UI_box.selected_tab >= 3)
							UI_box.selected_tab = 0;
					}
				}

				var shiftThing:Int = 1;
				if (FlxG.keys.pressed.SHIFT)
					shiftThing = 4;
				if (!writingNotes)
					{
						if (FlxG.keys.justPressed.RIGHT)
							changeSection(curSection + shiftThing);
						if (FlxG.keys.justPressed.LEFT)
							changeSection(curSection - shiftThing);
					}
		}

		_song.bpm = tempBpm;

		/* if (FlxG.keys.justPressed.UP)
				Conductor.changeBPM(Conductor.bpm + 1);
			if (FlxG.keys.justPressed.DOWN)
				Conductor.changeBPM(Conductor.bpm - 1); */

		bpmTxt.text = bpmTxt.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ " / "
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			+ "\nSection: "
			+ curSection
			+ "\nCur Step: "
			+ curStep
			+ "\nCur Beat: "
			+ curBeat;

			if (!check_mute_inst.checked)
				FlxG.sound.music.volume = instVol.value;

			if (!check_mute_voices.checked)
				vocals.volume = voicesVol.value;
				
		super.update(elapsed);
	}

	function changeNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null)
		{
			if (curSelectedNote[2] != null)
			{
				curSelectedNote[2] += value;
				curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
			}
		}

		updateNoteUI();
		updateGrid();
	}

	function recalculateSteps():Int
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void
	{
		updateGrid();

		FlxG.sound.music.pause();
		vocals.pause();

		// Basically old shit from changeSection???
		FlxG.sound.music.time = sectionStartTime();

		if (songBeginning)
		{
			FlxG.sound.music.time = 0;
			curSection = 0;
		}

		vocals.time = FlxG.sound.music.time;
		updateCurStep();

		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		trace('changing section' + sec);

		if (_song.notes[sec] != null)
		{
			curSection = sec;

			updateGrid();

			if (updateMusic)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				/*var daNum:Int = 0;
					var daLength:Float = 0;
					while (daNum <= sec)
					{
						daLength += lengthBpmBullshit();
						daNum++;
				}*/

				FlxG.sound.music.time = sectionStartTime();
				vocals.time = FlxG.sound.music.time;
				updateCurStep();
			}

			updateGrid();
			updateSectionUI();
		}
	}

	function copySection(?sectionNum:Int = 1)
	{
		var daSec = FlxMath.maxInt(curSection, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes)
		{
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);

			var copiedNote:Array<Dynamic> = [strum, note[1], note[2]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}

		updateGrid();
	}

	function copylastsectiondata(?sectionNum:Int = 1)
		{
			//sectionNum = stepperCopydata.value;
			var daSec = _song.notes[sectionNum];
			var sec = _song.notes[curSection];
			typingShit4.text = daSec.animtoplay;
			typingShit5.text = daSec.charactertoplayon;
			check_camerashake.checked = daSec.camerashake;
			check_shakegamecamera.checked = daSec.shakegamecamera;
			check_shakeHUD.checked = daSec.shakeHUD;
		    check_camzoomonp1.checked = daSec.camzoomonp1;
		    check_disablecamzooming.checked = daSec.disablecamzooming;
		    check_camzooming.checked = daSec.camzooming;
		    check_curstepzooming.checked = daSec.curstepzooming;
			steppernumanim.value = daSec.steppernumanim;
		    check_curbeatzooming.checked = daSec.curbeatzooming;
			check_curstepanim.checked = daSec.curstepanim;
			check_curbeatanim.checked = daSec.curbeatanim;
			camzoomtime.value = daSec.camzoomtime;
			camzoomamountp1.value = daSec.camzoomamountp1;
			camerashakeamount.value = daSec.camerashakeamount;
			camerashakeduration.value = daSec.camerashakeduration;
			camerashaketrigger.value = daSec.camerashaketrigger;
			camerazoomtrigger.value = daSec.camerazoomtrigger;
			camerazoomtrigger2.value = daSec.camerazoomtrigger2;
			flixelcamerazoom.value = daSec.flixelcamerazoom;
			flixelHUDzoom.value = daSec.flixelHUDzoom;
			currentgfspeed.value = daSec.sectiongfspeed;
			camerazoompercentinput.value = daSec.camerazoompercentinput;
			check_playanim.checked = daSec.playanim;
			check_isforced.checked = daSec.isforced;
			check_islooped.checked = daSec.islooped;
			check_crossfade.checked = daSec.crossFade;

			sec.animtoplay = daSec.animtoplay;
			sec.shakegamecamera = daSec.shakegamecamera;
			sec.shakeHUD = daSec.shakeHUD;
			sec.charactertoplayon = daSec.charactertoplayon;
			sec.camerashake = daSec.camerashake;
			sec.camzoomonp1 = daSec.camzoomonp1;
		    sec.disablecamzooming = daSec.disablecamzooming;
			sec.camzooming = daSec.camzooming;
			sec.curstepzooming = daSec.curstepzooming;
			sec.curstepanim = daSec.curstepanim;
			sec.steppernumanim = daSec.steppernumanim;
			sec.curbeatzooming = daSec.curbeatzooming;
			sec.curbeatanim = daSec.curbeatanim;
			sec.curbeatanim = daSec.curbeatanim;
			sec.camzoomtime = daSec.camzoomtime;
			sec.camzoomamountp1 = daSec.camzoomamountp1;
			sec.camerashakeamount = daSec.camerashakeamount;
			sec.camerashakeduration = daSec.camerashakeduration;
			sec.camerashaketrigger = daSec.camerashaketrigger;
			sec.camerazoomtrigger = daSec.camerazoomtrigger;
			sec.camerazoomtrigger2 = daSec.camerazoomtrigger2;
			sec.flixelcamerazoom = daSec.flixelcamerazoom;
			sec.flixelHUDzoom = daSec.flixelHUDzoom;
			sec.sectiongfspeed = daSec.sectiongfspeed;
			sec.camerazoompercentinput = daSec.camerazoompercentinput;
			sec.playanim = daSec.playanim;
			sec.isforced = daSec.isforced;
			sec.islooped = daSec.islooped;
			sec.crossFade = daSec.crossFade;

			updateGrid();
		}

	function updateSectionUI():Void
	{
		var sec = _song.notes[curSection];
		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_shakegamecamera.checked = sec.shakegamecamera;
		check_shakeHUD.checked = sec.shakeHUD;
		check_gfspeed.checked = sec.gfspeed;
		check_playanim.checked = sec.playanim;
		check_camerashake.checked = sec.camerashake;
		check_camzoomonp1.checked = sec.camzoomonp1;
		check_disablecamzooming.checked = sec.disablecamzooming;
		check_camzooming.checked = sec.camzooming;
		check_curstepzooming.checked = sec.curstepzooming;
		check_curbeatanim.checked = sec.curbeatanim;
		check_curstepanim.checked = sec.curstepanim;
		check_curbeatzooming.checked = sec.curbeatzooming;
		check_altAnim.checked = sec.altAnim;
		check_altAnim2.checked = sec.altAnim2;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;
		camzoomtime.value = sec.camzoomtime;
		camzoomamountp1.value = sec.camzoomamountp1;
		camerashakeamount.value = sec.camerashakeamount;
		camerashakeduration.value = sec.camerashakeduration;
		camerashaketrigger.value = sec.camerashaketrigger;
		camerazoomtrigger.value = sec.camerazoomtrigger;
		camerazoomtrigger2.value = sec.camerazoomtrigger2;
		flixelcamerazoom.value = sec.flixelcamerazoom;
		flixelHUDzoom.value = sec.flixelHUDzoom;
		currentgfspeed.value = sec.sectiongfspeed;
		camerazoompercentinput.value = sec.camerazoompercentinput;
		steppernumanim.value = sec.steppernumanim;
		check_crossfade.checked = sec.crossFade;
		#if cpp
		typingShit4.text = sec.animtoplay;
		typingShit5.text = sec.charactertoplayon;
		#else
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
			{
				typingShit4.text = sec.animtoplay;
				typingShit5.text = sec.charactertoplayon;
			});	
		#end
		// temp fix, i REALLY need to fix this longterm (THIS IS REALLY BAD CODE!!!!!!)
		check_isforced.checked = sec.isforced;
		check_islooped.checked = sec.islooped;
		updateHeads();
	}

	function updateHeads():Void
	{
		if (check_mustHitSection.checked)
		{
			leftIcon.animation.play(PlayState.SONG.player1);
			rightIcon.animation.play(PlayState.SONG.player2);
		}
		else
		{
			leftIcon.animation.play(PlayState.SONG.player2);
			rightIcon.animation.play(PlayState.SONG.player1);
		}
	}

	function updateNoteUI():Void
	{
		if (curSelectedNote != null)
			stepperSusLength.value = curSelectedNote[2];
	}

	function updateGrid():Void
	{
		remove(gridBG);
		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * _song.notes[curSection].lengthInSteps);
        add(gridBG);

		remove(gridBlackLine);
		gridBlackLine = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		while (curRenderedNotes.members.length > 0)
		{
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		}

		while (curRenderedSustains.members.length > 0)
		{
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		}

		var sectionInfo:Array<Dynamic> = _song.notes[curSection].sectionNotes;

		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0)
		{
			Conductor.changeBPM(_song.notes[curSection].bpm);
			trace('CHANGED BPM!');
		}
		else
		{
			// get last bpm
			var daBPM:Int = _song.bpm;
			for (i in 0...curSection)
				if (_song.notes[i].changeBPM)
					daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}

		/* // PORT BULLSHIT, INCASE THERE'S NO SUSTAIN DATA FOR A NOTE
			for (sec in 0..._song.notes.length)
			{
				for (notesse in 0..._song.notes[sec].sectionNotes.length)
				{
					if (_song.notes[sec].sectionNotes[notesse][2] == null)
					{
						trace('SUS NULL');
						_song.notes[sec].sectionNotes[notesse][2] = 0;
					}
				}
			}
		 */

		for (i in sectionInfo)
		{
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];

			var note:Note = new Note(daStrumTime, daNoteInfo % 4);
			note.sustainLength = daSus;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.updateHitbox();
			note.x = Math.floor(daNoteInfo * GRID_SIZE);
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));

			curRenderedNotes.add(note);

			if (daSus > 0)
			{
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2),
					note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * 16, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}
		}
	}

	private function addSection(lengthInSteps:Int = 16):Void
	{
		var sec:SwagSection = {
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: false,
			altAnim2: false,
			camzoomonp1: false,
			camzoomamountp1: 0,
			camerashakeamount: 0,
			camerashakeduration: 0,
			camerashaketrigger: 0,
			camerazoomtrigger: 0,
			camerazoomtrigger2: 0,
			flixelcamerazoom: 0,
			flixelHUDzoom: 0,
			sectiongfspeed: 0,
			camerazoompercentinput: 0,
			camerashake: false,
			disablecamzooming: false,
			camzooming: false,
			camzoomtime: 0,
			curbeatzooming: false,
			curstepzooming: false,
			steppernumanim: 0,
			curbeatanim: false,
			curstepanim: false,
			gfspeed: false,
			playanim:false,
			animtoplay: "hey",
			isforced: false,
			charactertoplayon: "boyfriend",
			islooped: false,
			crossFade: false,
			shakegamecamera: false,
			shakeHUD: false,
			startTime: 0,
	        endTime: 0
		};

		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void
	{
		var swagNum:Int = 0;

		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i.strumTime == note.strumTime && i.noteData % 4 == note.noteData)
			{
				curSelectedNote = _song.notes[curSection].sectionNotes[swagNum];
			}

			swagNum += 1;
		}

		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void
	{
		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i[0] == note.strumTime && i[1] % 4 == note.noteData)
			{
				trace('FOUND EVIL NUMBER');
				_song.notes[curSection].sectionNotes.remove(i);
			}
		}

		updateGrid();
	}

	function clearSection():Void
	{
		_song.notes[curSection].sectionNotes = [];

		updateGrid();
	}

	function clearSong():Void
	{
		for (daSection in 0..._song.notes.length)
		{
			_song.notes[daSection].sectionNotes = [];
		}

		updateGrid();
	}

	private function addNote():Void
	{
		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteData = Math.floor(FlxG.mouse.x / GRID_SIZE);
		var noteSus = 0;

		_song.notes[curSection].sectionNotes.push([noteStrum, noteData, noteSus]);

		curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		if (FlxG.keys.pressed.CONTROL)
		{
			_song.notes[curSection].sectionNotes.push([noteStrum, (noteData + 4) % 8, noteSus]);
		}

		trace(noteStrum);
		trace(curSection);

		updateGrid();
		updateNoteUI();

		autosaveSong();
	}

	function getStrumTime(yPos:Float):Float
	{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float
	{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}

	/*
		function calculateSectionLengths(?sec:SwagSection):Int
		{
			var daLength:Int = 0;

			for (i in _song.notes)
			{
				var swagLength = i.lengthInSteps;

				if (i.typeOfSection == Section.COPYCAT)
					swagLength * 2;

				daLength += swagLength;

				if (sec != null && sec == i)
				{
					trace('swag loop??');
					break;
				}
			}

			return daLength;
	}*/
	private var daSpacing:Float = 0.3;

	function loadLevel():Void
	{
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic>
	{
		var noteData:Array<Dynamic> = [];

		for (i in _song.notes)
		{
			noteData.push(i.sectionNotes);
		}

		return noteData;
	}

	function loadJson(song:String):Void
	{
		PlayState.triggeredalready = false;
		if (typingShit2.text == 'normal')
			{
				PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase(), PlayState.SONG.song);	
			}
			else	
		PlayState.SONG = Song.loadFromJson(PlayState.SONG.song.toLowerCase() + "-" + typingShit2.text, PlayState.SONG.song);
		switch (typingShit2.text)
		{
			case "easy":
				PlayState.storyDifficulty = 0;
			case "normal":
				PlayState.storyDifficulty = 1;
			case "hard":
				PlayState.storyDifficulty = 2;
		}
		LoadingState.loadAndSwitchState(new ChartingState());
	}

	function loadAutosave():Void
	{
		PlayState.triggeredalready = false;	
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		#if debug
		trace(FlxG.save.data.autosave);
		#end
		LoadingState.loadAndSwitchState(new ChartingState());
	}

	function autosaveSong():Void
	{
		FlxG.save.data.autosave = Json.stringify({
			"song": _song
		});
		FlxG.save.flush();
	}

	private function saveLevel()
	{
		var json = {
			"song": _song
		};

		var data:String = Json.stringify(json);

		if ((data != null) && (data.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + ".json");
		}
	}


		function _onClick():Void
			{
				loadoutsidejson();
			}

		function loadoutsidejson():Void
			{
				fr = new FileReference();
				fr.addEventListener(Event.SELECT, _onSelect, false, 0, true);
				fr.addEventListener(Event.CANCEL, _onCancel, false, 0, true);
				//var filters:Array<FileFilter> = new Array<FileFilter>();
				//filters.push(new FileFilter("JSON File", "*.json"));
				fr.browse([new FileFilter('JSON', '*.json')]);
			}

			function _onCancel(_):Void
				{
					trace('cancel!');
				}

			function _onLoad(E:Event):Void
				{
					var fr:FileReference = cast E.target;
					fr.removeEventListener(Event.COMPLETE, _onLoad);
					PlayState.triggeredalready = false;
					var data:String = fr.data.toString();
					trace('Name: ' + fr.name);
					#if debug
					trace('Data: ' + fr.data);
					#end
					trace('Type: ' + fr.type);
					trace('Size: ' + fr.size);
					trace('loading...');
					PlayState.SONG = Song.parseJSONshit(data);
					
					LoadingState.loadAndSwitchState(new ChartingState());
					trace('loaded!!!');
				}

	function _onSelect(E:Event):Void
	{
		var fr:FileReference = cast(E.target, FileReference);
		fr.addEventListener(Event.COMPLETE, _onLoad, false, 0, true);
		fr.load();
		trace('select');
	}


	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		trace("Successfully saved LEVEL DATA.");
	}

	

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the Json.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		trace("Problem saving Level data");
	}
}
