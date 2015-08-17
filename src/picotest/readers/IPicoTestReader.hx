package picotest.readers;

interface IPicoTestReader {

	function load(runner:PicoTestRunner, testCaseClass:Class<Dynamic>):Void;

}
