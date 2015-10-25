package picotest.readers;

interface IPicoTestReader {

	function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>, defaultParameters:Iterable<Array<Dynamic>> = null):Void;

}
