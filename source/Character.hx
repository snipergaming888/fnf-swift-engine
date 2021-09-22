package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var playerColor:String = "31B0D1";

	public var holdTimer:Float = 0;


	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		if (FlxG.save.data.antialiasing)
			{
				antialiasing = true;
			}
			else
				{
					antialiasing = false;
				}

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				if (FlxG.save.data.catgirl)
					{
						tex = Paths.getSparrowAtlas('GF_assets_catgirl', 'shared');

						frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('danceRight');


					}
					else
						{
							tex = Paths.getSparrowAtlas('GF_assets', 'shared');

							frames = tex;
					animation.addByPrefix('cheer', 'GF Cheer', 24, false);
					animation.addByPrefix('singLEFT', 'GF left note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
					animation.addByPrefix('singUP', 'GF Up Note', 24, false);
					animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
					animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
					animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
					animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
					animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
					animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
					animation.addByPrefix('scared', 'GF FEAR', 24);
	
					addOffset('cheer');
					addOffset('sad', -2, -2);
					addOffset('danceLeft', 0, -9);
					addOffset('danceRight', 0, -9);
	
					addOffset("singUP", 0, 4);
					addOffset("singRIGHT", 0, -20);
					addOffset("singLEFT", 0, -19);
					addOffset("singDOWN", 0, -20);
					addOffset('hairBlow', 45, -8);
					addOffset('hairFall', 0, -9);
	
					addOffset('scared', -2, -17);
	
					if (FlxG.save.data.antialiasing)
						{
							antialiasing = true;
						}
						else
							{
								antialiasing = false;
							}
	
					playAnim('danceRight');
						}


						case 'gf-wire':
				   // GIRLFRIEND WIRE CODE
							tex = Paths.getSparrowAtlas('GF_assets_night', 'shared');

							frames = tex;
					animation.addByPrefix('cheer', 'GF Cheer', 24, false);
					animation.addByPrefix('singLEFT', 'GF left note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
					animation.addByPrefix('singUP', 'GF Up Note', 24, false);
					animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
					animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
					animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
					animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
					animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
					animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
					animation.addByPrefix('scared', 'GF FEAR', 24);
	
					addOffset('cheer');
					addOffset('sad', -2, -2);
					addOffset('danceLeft', 0, -9);
					addOffset('danceRight', 0, -9);
	
					addOffset("singUP", 0, 4);
					addOffset("singRIGHT", 0, -20);
					addOffset("singLEFT", 0, -19);
					addOffset("singDOWN", 0, -20);
					addOffset('hairBlow', 45, -8);
					addOffset('hairFall', 0, -9);
	
					addOffset('scared', -2, -17);
	
					if (FlxG.save.data.antialiasing)
						{
							antialiasing = true;
						}
						else
							{
								antialiasing = false;
							}
	
					playAnim('danceRight');

					case 'gf-night':
						// GIRLFRIEND WIRE CODE
								 tex = Paths.getSparrowAtlas('GF_assets_night', 'shared');
	 
								 frames = tex;
						 animation.addByPrefix('cheer', 'GF Cheer', 24, false);
						 animation.addByPrefix('singLEFT', 'GF left note', 24, false);
						 animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
						 animation.addByPrefix('singUP', 'GF Up Note', 24, false);
						 animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
						 animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
						 animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
						 animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
						 animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
						 animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
						 animation.addByPrefix('scared', 'GF FEAR', 24);
		 
						 addOffset('cheer');
						 addOffset('sad', -2, -2);
						 addOffset('danceLeft', 0, -9);
						 addOffset('danceRight', 0, -9);
		 
						 addOffset("singUP", 0, 4);
						 addOffset("singRIGHT", 0, -20);
						 addOffset("singLEFT", 0, -19);
						 addOffset("singDOWN", 0, -20);
						 addOffset('hairBlow', 45, -8);
						 addOffset('hairFall', 0, -9);
		 
						 addOffset('scared', -2, -17);
		 
						 if (FlxG.save.data.antialiasing)
							 {
								 antialiasing = true;
							 }
							 else
								 {
									 antialiasing = false;
								 }
		 
						 playAnim('danceRight');
						


						case 'gf-glitcher':
				// GIRLFRIEND CODE
				if (FlxG.save.data.catgirl)
					{
						tex = Paths.getSparrowAtlas('GF_assets_catgirl', 'shared');

						frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('danceRight');


					}
					else
						{
							tex = Paths.getSparrowAtlas('GF_assets_glitcher', 'shared');

							frames = tex;
					animation.addByPrefix('cheer', 'GF Cheer', 24, false);
					animation.addByPrefix('singLEFT', 'GF left note', 24, false);
					animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
					animation.addByPrefix('singUP', 'GF Up Note', 24, false);
					animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
					animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
					animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
					animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
					animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
					animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
					animation.addByPrefix('scared', 'GF FEAR', 24);
	
					addOffset('cheer');
					addOffset('sad', -2, -2);
					addOffset('danceLeft', 0, -9);
					addOffset('danceRight', 0, -9);
	
					addOffset("singUP", 0, 4);
					addOffset("singRIGHT", 0, -20);
					addOffset("singLEFT", 0, -19);
					addOffset("singDOWN", 0, -20);
					addOffset('hairBlow', 45, -8);
					addOffset('hairFall', 0, -9);
	
					addOffset('scared', -2, -17);
	
					if (FlxG.save.data.antialiasing)
						{
							antialiasing = true;
						}
						else
							{
								antialiasing = false;
							}
	
					playAnim('danceRight');
						}



						case 'hexvirus':
							// HEXVIRUS ANIMATION LOADING CODE
							tex = Paths.getSparrowAtlas('Hex_Virus','shared');
							frames = tex;
							animation.addByPrefix('idle', 'Hex crazy idle', 24);
							animation.addByPrefix('singUP', 'Hex crazy up', 24);
							animation.addByPrefix('singRIGHT', 'Hex crazy right', 24);
							animation.addByPrefix('singDOWN', 'Hex crazy down', 24);
							animation.addByPrefix('singLEFT', 'Hex crazy left', 24);
			
							addOffset('idle');
							addOffset("singUP", 93, 109);
							addOffset("singRIGHT", 95, -20);
							addOffset("singLEFT", 158, 63);
							addOffset("singDOWN", 85, -62);

							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');


							case 'hexWIRE':
							// HEXVIRUS ANIMATION LOADING CODE
							tex = Paths.getSparrowAtlas('HEX_WIRE','shared');
							frames = tex;
							animation.addByPrefix('idle', 'Hex crazy idle', 24);
							animation.addByPrefix('singUP', 'Hex crazy up', 24);
							animation.addByPrefix('singRIGHT', 'Hex crazy right', 24);
							animation.addByPrefix('singDOWN', 'Hex crazy down', 24);
							animation.addByPrefix('singLEFT', 'Hex crazy left', 24);
			
							addOffset('idle');
							addOffset("singUP", 93, 109);
							addOffset("singRIGHT", 95, -20);
							addOffset("singLEFT", 158, 63);
							addOffset("singDOWN", 85, -62);

							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');


				case 'gf-normal':
				// GIRLFRIEND CODE
						tex = Paths.getSparrowAtlas('GF_normalassests', 'shared');

						frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('danceRight');



				case 'bfWIRE':
					if (FlxG.save.data.picooverbf)
						{
							tex = Paths.getSparrowAtlas('Pico_FNF_assetss_WIRE', 'shared');
							frames = tex;
							animation.addByPrefix('idle', "Pico Idle Dance", 24);
							animation.addByPrefix('singUP', 'pico Up note0', 24, false);
							animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
							animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					     	animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
							animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
							animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
							animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
							animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
			
							addOffset('idle');
							addOffset("singUP", 14, 27);
							addOffset("singRIGHT", -51, -6);
							addOffset("singLEFT", 84, -7);
							addOffset("singDOWN", 87, -72);
							addOffset("singUPmiss", 14, 27);
							addOffset("singRIGHTmiss", 84, -7);
							addOffset("singLEFTmiss", -51, -6);
							addOffset("singDOWNmiss", 94, -28);
	
							flipX = true;
			
							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');
						}
						else
							{
								var tex = Paths.getSparrowAtlas('BOYFRIENDWIRE','shared');
								frames = tex;
								animation.addByPrefix('idle', 'BF idle dance', 24, false);
								animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
								animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
								animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
								animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
								animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
								animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
								animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
								animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
								animation.addByPrefix('hey', 'BF HEY', 24, false);
				
								animation.addByPrefix('firstDeath', "BF dies", 24, false);
								animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
								animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				
								animation.addByPrefix('scared', 'BF idle shaking', 24);
				
								addOffset('idle', -5);
								addOffset("singUP", -29, 27);
								addOffset("singRIGHT", -38, -7);
								addOffset("singLEFT", 12, -6);
								addOffset("singDOWN", -10, -50);
								addOffset("singUPmiss", -29, 27);
								addOffset("singRIGHTmiss", -30, 21);
								addOffset("singLEFTmiss", 12, 24);
								addOffset("singDOWNmiss", -11, -19);
								addOffset("hey", 7, 4);
								addOffset('firstDeath', 37, 11);
								addOffset('deathLoop', 37, 5);
								addOffset('deathConfirm', 37, 69);
								addOffset('scared', -4);

								if (FlxG.save.data.antialiasing)
									{
										antialiasing = true;
									}
									else
										{
											antialiasing = false;
										}
				
								playAnim('idle');
				
								flipX = true;
							}

							case 'bf-night':
					
							tex = Paths.getSparrowAtlas('BOYFRIENDNIGHT', 'shared');
							frames = tex;
							animation.addByPrefix('idle', "Pico Idle Dance", 24);
							animation.addByPrefix('singUP', 'pico Up note0', 24, false);
							animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
							animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					     	animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
							animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
							animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
							animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
							animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
			
							addOffset('idle');
							addOffset("singUP", 14, 27);
							addOffset("singRIGHT", -51, -6);
							addOffset("singLEFT", 84, -7);
							addOffset("singDOWN", 87, -72);
							addOffset("singUPmiss", 14, 27);
							addOffset("singRIGHTmiss", 84, -7);
							addOffset("singLEFTmiss", -51, -6);
							addOffset("singDOWNmiss", 94, -28);
	
							flipX = true;
			
							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');
						


			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('gfChristmas', 'week5');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -2);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('danceRight');

			case 'gf-car':
				if (FlxG.save.data.catgirl)
					{
						tex = Paths.getSparrowAtlas('gfCar_catgirl', 'week4');
						frames = tex;
						animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
						animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
						animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
							false);
		
						addOffset('danceLeft', 0);
						addOffset('danceRight', 0);
		
						if (FlxG.save.data.antialiasing)
							{
								antialiasing = true;
							}
							else
								{
									antialiasing = false;
								}
		
						playAnim('danceRight');
					}
					else
						{
							tex = Paths.getSparrowAtlas('gfCar', 'week4');
							frames = tex;
							animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
							animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
							animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
								false);
			
							addOffset('danceLeft', 0);
							addOffset('danceRight', 0);
			
							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('danceRight');
						}

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('weeb/gfPixel', 'shared');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('DADDY_DEAREST', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');


				case 'mia':
				// MIA ANIMATION LOADING CODE
				// SHE IS SO HOT
				tex = Paths.getSparrowAtlas('stadium/Mia', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'mia idle', 24);
				animation.addByPrefix('singUP', 'Mia Up', 24);
				animation.addByPrefix('singRIGHT', 'mia right', 24);
				animation.addByPrefix('singDOWN', 'Mia Down', 24);
				animation.addByPrefix('singLEFT', 'Mia Left', 24);

				addOffset('idle');
				addOffset("singUP", 26, 73);
				addOffset("singRIGHT", 66, -68);
				addOffset("singLEFT", 185, -5);
				addOffset("singDOWN", 18, -21);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');



				case 'toby':
				// TOBY ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('toby', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'toby doggieidle', 24);
				animation.addByPrefix('singUP', 'toby doggieup', 24);
				animation.addByPrefix('singRIGHT', 'toby doggieright', 24);
				animation.addByPrefix('singDOWN', 'toby doggiedown', 24);
				animation.addByPrefix('singLEFT', 'toby doggieleft', 24);

				addOffset('idle', 0, 1);
				addOffset("singUP", -6, -3);
				addOffset("singRIGHT", 13, 11);
				addOffset("singLEFT", -10, 7);
				addOffset("singDOWN", 0, 0);

			
				antialiasing = false;
						

				playAnim('idle');

				case 'black':
				// i hate black people
				playerColor = "2B2B2B";
				tex = Paths.getSparrowAtlas('black', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'BLACK IDLE', 24, true);
				animation.addByPrefix('singUP', 'BLACK UP', 24, false);
				animation.addByPrefix('singRIGHT', 'BLACK RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'BLACK DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BLACK LEFT', 24, false);

				animation.addByPrefix('death', 'BLACK DEATH', 24, false);

				addOffset('idle');
				addOffset("singUP", 46, 104);
				addOffset("singRIGHT", -225, -10);
				addOffset("singLEFT", 116, 12);
				addOffset("singDOWN", -22, -20);
				addOffset("death", 252, 238);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');

				case 'bf-defeat-death':
					var tex = Paths.getSparrowAtlas('defeatDeath','shared');
					frames = tex;
	
					trace(tex.frames.length);
	
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
					addOffset('firstDeath', 392, 87);
					addOffset('deathLoop', 34, 76);
					addOffset('deathConfirm', 34, 76);
		
					flipX = true;
						
				case 'bf-defeat-secret':
					var tex = Paths.getSparrowAtlas('noMoreBalls','shared');
					frames = tex;
		
					trace(tex.frames.length);
	
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, false);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
					addOffset('idle', -5);
					addOffset('firstDeath', 989, 87);
					addOffset('deathLoop', 24, 2);
					addOffset('deathConfirm', 24, 66);
		
					flipX = true;


				case 'ascend':
				// BF ASCENDING ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('ascend', 'shared');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 50);
				addOffset("singRIGHT", 0, 27);
				addOffset("singLEFT", -10, 10);
				addOffset("singDOWN", 0, -30);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('spooky_kids_assets', 'week2');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -20, 26);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 130, -10);
				addOffset("singDOWN", -50, -130);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('Mom_Assets', 'week4');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('momCar', 'week4');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", 14, 71);
				addOffset("singRIGHT", 10, -60);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -160);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('Monster_Assets', 'week2');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -30, -40);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}
				playAnim('idle');
			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('monsterChristmas', 'week5');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				addOffset('idle');
				addOffset("singUP", -20, 50);
				addOffset("singRIGHT", -51);
				addOffset("singLEFT", -30);
				addOffset("singDOWN", -40, -94);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}
				playAnim('idle');
			case 'pico':
					tex = Paths.getSparrowAtlas('Pico_FNF_assetss', 'week3');
					frames = tex;
					animation.addByPrefix('idle', "Pico Idle Dance", 24);
					animation.addByPrefix('singUP', 'pico Up note0', 24, false);
					animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
					if (isPlayer)
					{
						animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
						animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
					}
					else
					{
						// Need to be flipped! REDO THIS LATER!
						animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
						animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
						animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
					}
	
					animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
					animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
	
					addOffset('idle');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);

					flipX = true;
	
					if (FlxG.save.data.antialiasing)
						{
							antialiasing = true;
						}
						else
							{
								antialiasing = false;
							}
	
					playAnim('idle');


					case 'picoplayable':
						tex = Paths.getSparrowAtlas('Pico_FNF_assetss', 'week3');
						frames = tex;
						animation.addByPrefix('idle', "Pico Idle Dance", 24);
						animation.addByPrefix('singUP', 'pico Up note0', 24, false);
						animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
						animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
						animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
						animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
						animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
						animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
		
						addOffset('idle', -35,3);
						addOffset("singUP", -31, 29);
						addOffset("singRIGHT", -107, 3);
						addOffset("singLEFT", 22, -11);
						addOffset("singDOWN", 42, -71);
						addOffset("singUPmiss", -31, 29);
						addOffset("singRIGHTmiss", -107, 3);
						addOffset("singLEFTmiss", 22, -11);
						addOffset("singDOWNmiss", 42, -71);

						flipX = true;
		
						if (FlxG.save.data.antialiasing)
							{
								antialiasing = true;
							}
							else
								{
									antialiasing = false;
								}
		
						playAnim('idle');

					case 'picomallet':
					tex = Paths.getSparrowAtlas('Pico_FNF_assetssmallet', 'week3');
					frames = tex;
					animation.addByPrefix('idle', "Pico Idle Dance", 24);
					animation.addByPrefix('singUP', 'pico Up note0', 24, false);
					animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
					if (isPlayer)
					{
						animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
						animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
					}
					else
					{
						// Need to be flipped! REDO THIS LATER!
						animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
						animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
						animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
					}
	
					animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
					animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
	
					addOffset('idle');
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -68, -7);
					addOffset("singLEFT", 65, 9);
					addOffset("singDOWN", 200, -70);
					addOffset("singUPmiss", -19, 67);
					addOffset("singRIGHTmiss", -60, 41);
					addOffset("singLEFTmiss", 62, 64);
					addOffset("singDOWNmiss", 210, -28);
	
					if (FlxG.save.data.antialiasing)
						{
							antialiasing = true;
						}
						else
							{
								antialiasing = false;
							}
	
					playAnim('idle');
	
					flipX = true;
				

			case 'bf':
				if (FlxG.save.data.picooverbf)
					{
						tex = Paths.getSparrowAtlas('Pico_FNF_assetss', 'shared');
							frames = tex;
							animation.addByPrefix('idle', "Pico Idle Dance", 24);
							animation.addByPrefix('singUP', 'pico Up note0', 24, false);
							animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
							animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					     	animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
							animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
							animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
							animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
							animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
			
			
							addOffset('idle');
							addOffset("singUP", 14, 27);
							addOffset("singRIGHT", -51, -6);
							addOffset("singLEFT", 84, -7);
							addOffset("singDOWN", 87, -72);
							addOffset("singUPmiss", 14, 27);
							addOffset("singRIGHTmiss", 84, -7);
							addOffset("singLEFTmiss", -51, -6);
							addOffset("singDOWNmiss", 94, -28);
	
							flipX = true;
			
							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');
					}
					else
						{
							var tex = Paths.getSparrowAtlas('BOYFRIEND', 'shared');

							frames = tex;
							animation.addByPrefix('idle', 'BF idle dance', 24, false);
							animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
							animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
							animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
							animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
							animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
							animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
							animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
							animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
							animation.addByPrefix('hey', 'BF HEY', 24, false);
			
							animation.addByPrefix('firstDeath', "BF dies", 24, false);
							animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
							animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
			
							animation.addByPrefix('scared', 'BF idle shaking', 24);
			
							addOffset('idle', -5);
							addOffset("singUP", -29, 27);
							addOffset("singRIGHT", -38, -7);
							addOffset("singLEFT", 12, -6);
							addOffset("singDOWN", -10, -50);
							addOffset("singUPmiss", -29, 27);
							addOffset("singRIGHTmiss", -30, 21);
							addOffset("singLEFTmiss", 12, 24);
							addOffset("singDOWNmiss", -11, -19);
							addOffset("hey", 7, 4);
							addOffset('firstDeath', 37, 11);
							addOffset('deathLoop', 37, 5);
							addOffset('deathConfirm', 37, 69);
							addOffset('scared', -4);
			
							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');
			
							flipX = true;
						}

						case 'bf-glitcher':
				if (FlxG.save.data.picooverbf)
					{
						tex = Paths.getSparrowAtlas('Pico_FNF_assetss', 'shared');
							frames = tex;
							animation.addByPrefix('idle', "Pico Idle Dance", 24);
							animation.addByPrefix('singUP', 'pico Up note0', 24, false);
							animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
							animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					     	animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
							animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
							animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
							animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
							animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
			
			
							addOffset('idle');
							addOffset("singUP", 14, 27);
							addOffset("singRIGHT", -51, -6);
							addOffset("singLEFT", 84, -7);
							addOffset("singDOWN", 87, -72);
							addOffset("singUPmiss", 14, 27);
							addOffset("singRIGHTmiss", 84, -7);
							addOffset("singLEFTmiss", -51, -6);
							addOffset("singDOWNmiss", 94, -28);
	
							flipX = true;
			
							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');
					}
					else
						{
							var tex = Paths.getSparrowAtlas('BOYFRIENDGLITCHER', 'shared');

							frames = tex;
							animation.addByPrefix('idle', 'BF idle dance', 24, false);
							animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
							animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
							animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
							animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
							animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
							animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
							animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
							animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
							animation.addByPrefix('hey', 'BF HEY', 24, false);
			
							animation.addByPrefix('firstDeath', "BF dies", 24, false);
							animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
							animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
			
							animation.addByPrefix('scared', 'BF idle shaking', 24);
			
							addOffset('idle', -5);
							addOffset("singUP", -29, 27);
							addOffset("singRIGHT", -38, -7);
							addOffset("singLEFT", 12, -6);
							addOffset("singDOWN", -10, -50);
							addOffset("singUPmiss", -29, 27);
							addOffset("singRIGHTmiss", -30, 21);
							addOffset("singLEFTmiss", 12, 24);
							addOffset("singDOWNmiss", -11, -19);
							addOffset("hey", 7, 4);
							addOffset('firstDeath', 37, 11);
							addOffset('deathLoop', 37, 5);
							addOffset('deathConfirm', 37, 69);
							addOffset('scared', -4);
			
							if (FlxG.save.data.antialiasing)
								{
									antialiasing = true;
								}
								else
									{
										antialiasing = false;
									}
			
							playAnim('idle');
			
							flipX = true;
						}


					case 'bf-mallet':
						var tex = Paths.getSparrowAtlas('BOYFRIENDMALLET', 'shared');
	
						frames = tex;
						animation.addByPrefix('idle', 'BF idle dance', 24, false);
						animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
						animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
						animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
						animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
						animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
						animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
						animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
						animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
						animation.addByPrefix('hey', 'BF HEY', 24, false);
		
						animation.addByPrefix('firstDeath', "BF dies", 24, false);
						animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
						animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
		
						animation.addByPrefix('scared', 'BF idle shaking', 24);
		
						addOffset('idle', -5);
						addOffset("singUP", -29, 27);
						addOffset("singRIGHT", -38, -7);
						addOffset("singLEFT", 12, -6);
						addOffset("singDOWN", -10, -50);
						addOffset("singUPmiss", -29, 27);
						addOffset("singRIGHTmiss", -30, 21);
						addOffset("singLEFTmiss", 12, 24);
						addOffset("singDOWNmiss", -11, -19);
						addOffset("hey", 7, 4);
						addOffset('firstDeath', 37, 11);
						addOffset('deathLoop', 37, 5);
						addOffset('deathConfirm', 37, 69);
						addOffset('scared', -4);
		
						if (FlxG.save.data.antialiasing)
							{
								antialiasing = true;
							}
							else
								{
									antialiasing = false;
								}
		
						playAnim('idle');
		
						flipX = true;



					case 'bf-wolves':
					var tex = Paths.getSparrowAtlas('BOYFRIENDWOLVES', 'shared');

					frames = tex;
					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
	
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
	
					animation.addByPrefix('scared', 'BF idle shaking', 24);
	
					addOffset('idle', -5);
					addOffset("singUP", -29, 27);
					addOffset("singRIGHT", -38, -7);
					addOffset("singLEFT", 12, -6);
					addOffset("singDOWN", -10, -50);
					addOffset("singUPmiss", -29, 27);
					addOffset("singRIGHTmiss", -30, 21);
					addOffset("singLEFTmiss", 12, 24);
					addOffset("singDOWNmiss", -11, -19);
					addOffset("hey", 7, 4);
					addOffset('firstDeath', 37, 11);
					addOffset('deathLoop', 37, 5);
					addOffset('deathConfirm', 37, 69);
					addOffset('scared', -4);
	
					if (FlxG.save.data.antialiasing)
						{
							antialiasing = true;
						}
						else
							{
								antialiasing = false;
							}
	
					playAnim('idle');
	
					flipX = true;
			

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('bfChristmas', 'week5');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('bfCar', 'week4');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				playAnim('idle');

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				flipX = true;
			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('weeb/bfPixel', 'shared');
				animation.addByPrefix('idle', 'BF IDLE', 24, false);
				animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");
				addOffset("singUPmiss");
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss");
				addOffset("singDOWNmiss");

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('weeb/bfPixelsDEAD', 'shared');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				addOffset('firstDeath');
				addOffset('deathLoop', -37);
				addOffset('deathConfirm', -37);
				playAnim('firstDeath');
				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('weeb/senpai', 'shared');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('weeb/senpai', 'shared');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				addOffset('idle');
				addOffset("singUP", 5, 37);
				addOffset("singRIGHT");
				addOffset("singLEFT", 40);
				addOffset("singDOWN", 14);
				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('weeb/spirit', 'shared');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				addOffset('idle', -220, -280);
				addOffset('singUP', -220, -240);
				addOffset("singRIGHT", -220, -280);
				addOffset("singLEFT", -200, -280);
				addOffset("singDOWN", 170, 110);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;
				

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('mom_dad_christmas_assets', 'week5');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				addOffset('idle');
				addOffset("singUP", -47, 24);
				addOffset("singRIGHT", -1, -23);
				addOffset("singLEFT", -30, 16);
				addOffset("singDOWN", -31, -29);
				addOffset("singUP-alt", -47, 24);
				addOffset("singRIGHT-alt", -1, -24);
				addOffset("singLEFT-alt", -30, 15);
				addOffset("singDOWN-alt", -30, -27);

				if (FlxG.save.data.antialiasing)
					{
						antialiasing = true;
					}
					else
						{
							antialiasing = false;
						}

				playAnim('idle');
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				trace('dance');
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		switch (curCharacter)
		{
			case 'gf-normal':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		switch (curCharacter)
		{
			case 'gf-glitcher':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	 public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}


					case 'gf-normal':
						if (!animation.curAnim.name.startsWith('hair'))
						{
							danced = !danced;
	
							if (danced)
								playAnim('danceRight');
							else
								playAnim('danceLeft');
						}

				case 'gf-christmas':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

					case 'gf-glitcher':
						if (!animation.curAnim.name.startsWith('hair'))
						{
							danced = !danced;
	
							if (danced)
								playAnim('danceRight');
							else
								playAnim('danceLeft');
						}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

					case 'gf-wire':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

					case 'gf-night':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						{
							
								playAnim('danceRight');
						}else{
							
								playAnim('danceLeft');
						}
	
						default:
							{
								playAnim('idle');
							}
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

}
