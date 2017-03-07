package picotest.thread.threadImpl;

@:noDoc
interface IPicoTestThreadImpl {
	function kill():Void;
	var isHalted(get, never):Bool;
}
