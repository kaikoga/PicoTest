package picotest.thread.impl;

@:noDoc
interface IPicoTestThreadImpl {
	function kill():Void;
	var isHalted(get, never):Bool;
}
