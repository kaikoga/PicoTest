package picotest.asyncImpl;

import haxe.PosInfos;

@:noDoc
interface IPicoTestAsyncImpl {
	function assertLater<T>(func:Void->Void, delayMs:Int, ?p:PosInfos):Void;
	function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void;
}
