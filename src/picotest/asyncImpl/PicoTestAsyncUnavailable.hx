package picotest.asyncImpl;

import haxe.PosInfos;
import picotest.PicoAssert.*;

@:noDoc
class PicoTestAsyncUnavailable implements IPicoTestAsyncImpl {

	public function new() return;

	public function assertLater<T>(func:Void->Void, delayMs:Int, ?p:PosInfos):Void {
		fail("assertLater() not supported in platform", p);
	}

	public function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		fail("createCallback() not supported in platform", p);
		return emptyCallback;
	}

	private function emptyCallback():Void return;
}
