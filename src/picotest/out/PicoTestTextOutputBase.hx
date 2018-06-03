package picotest.out;

import picotest.result.PicoTestResultMark;

class PicoTestTextOutputBase {
	public function new() return;
	public function progress(rate:Float, completed:Int, total:Int):Void return;
	public function complete(status:PicoTestResultMark):Void return;
}
