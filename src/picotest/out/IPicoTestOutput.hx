package picotest.out;

import picotest.result.PicoTestResultMark;

interface IPicoTestOutput {
	function output(value:String):Void;
	function progress(rate:Float, completed:Int, total:Int):Void;
	function complete(success:PicoTestResultMark):Void;
	function close():Void;
}
