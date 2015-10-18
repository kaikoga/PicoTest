package picotest.readers;

interface IPicoTestReader {

	function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>, defaultParameters:Iterable<Dynamic> = null):Void;

}
