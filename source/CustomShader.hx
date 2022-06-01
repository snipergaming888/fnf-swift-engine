import openfl.display.Shader;
import flixel.system.FlxAssets.FlxShader;
import flixel.FlxG;
import Song.SwagSong;
//class CustomShader extends Shader {
class CustomShader extends FlxShader {
  //@fragment var fragCode = PlayState.SONG.fragcode; // we will have the user type out the frag code and save it in the json, then load it here
 //@vertex var vertCode = PlayState.SONG.vertexcode; // we will have the user type out the frag code and save it in the json, then load it here
  public function new() {
    super();
    glFragmentSource = PlayState.SONG.fragcode;
    trace('CREATED NEW SHADER WITH ' + PlayState.SONG.fragcode + 'AND ' + PlayState.SONG.vertexcode);
  }
}