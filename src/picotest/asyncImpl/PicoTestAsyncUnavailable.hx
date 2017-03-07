package picotest.asyncImpl;

import haxe.PosInfos;
import picotest.PicoAssert.*;

@:noDoc
class PicoTestAsyncUnavailable {

	public static function assertLater<T>(func:Void->Void, delayMs:Int, ?p:PosInfos):Void {
		fail("assertLater() not supported in platform", p);
	}

	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		fail("createCallback() not supported in platform", p);
		return emptyCallback;
	}

	private static function emptyCallback():Void {}

}
