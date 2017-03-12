package picotest.out;

class PicoTestOutputBuffer {

	private var _currentLine:String = "";

	public function new() return;

	public function output(value:String, println:String->Void):Void {
		this._currentLine += value;
		var lines:Array<String> = this._currentLine.split("\n");
		this._currentLine = lines.pop();
		for (line in lines) println(line);
	}
}
