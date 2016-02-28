package picotest.out;
interface IPicoTestOutput {
	function stdout(value:String):Void;
	function close():Void;
}
