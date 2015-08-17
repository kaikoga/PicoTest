package picotest.tasks;

interface IPicoTestTask {
	var className(default, null):String;
	var methodName(default, null):String;
	function resume():Bool;
}
