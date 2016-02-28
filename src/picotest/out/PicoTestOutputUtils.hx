package picotest.out;

class PicoTestOutputUtils {

	private static var _currentLine:String = "";

	public static function cachedOutput(value:String, println:String->Void):Void {
		var lines:Array<String> = (_currentLine + value).split("\n");
		_currentLine = lines.pop();
		for (line in lines) println(line);
	}
}
