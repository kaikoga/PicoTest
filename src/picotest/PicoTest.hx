package picotest;

import picotest.macros.PicoTestFilter;
import picotest.macros.PicoTestConfig;
import picotest.printers.VerboseTracePrinter;
import picotest.out.PicoTestOutput;
import picotest.macros.PicoTestMacros;
import picotest.reporters.JsonTraceReporter;
import haxe.PosInfos;
import picotest.reporters.TraceReporter;

#if flash
import picotest.out.impl.display.PicoTestFlashDisplayOutput;
#end

#if js
import picotest.out.impl.display.PicoTestJsDisplayOutput;
#end

class PicoTest {

	/**
		Version of PicoTest.
	**/
	inline public static var VERSION:String = "0.9.0";

	/**
		Current target runner which assertions are run against.
	**/
	@:allow(picotest.PicoTestRunner)
	public static var currentRunner(default, null):PicoTestRunner;

	private function new() {
	}

	/**
		Creates a PicoTestRunner.
	**/
	public static function runner():PicoTestRunner {
		var runner = new PicoTestRunner();

		var output = new PicoTestOutput();
		var displayOutput = #if flash new PicoTestFlashDisplayOutput(output) #elseif js new PicoTestJsDisplayOutput(output) #else output #end ;

		if (PicoTestConfig.remote) {
			var onComplete = runner.onComplete;
			runner.onComplete = function() {
				onComplete();
			}
		}

		if (PicoTestConfig.reportJson) {
			haxe.Log.trace = emptyTrace;
			runner.printers = [new VerboseTracePrinter(displayOutput)];
			runner.reporters = [new JsonTraceReporter(output)];
		} else {
			runner.printers = [new VerboseTracePrinter(displayOutput)];
			runner.reporters = [new TraceReporter(output)];
		}

		return runner;
	}

	private static function emptyTrace(v:Dynamic, ?infos:PosInfos):Void {

	}

	#if (macro || macro_doc_gen)
	/**
		Run tests after compile and emits result as compiler warnings.
		How to run tests is defined with spawnerVariant argument.
	**/
	public static function warn(spawnerVariant:String = null):Void {
		PicoTestMacros.warn(spawnerVariant);
	}

	/**
		Build tests for executing in runTests().
		How to run tests is defined with spawnerVariant argument.
	**/
	public static function setup(spawnerVariant:String = null):Void {
		PicoTestMacros.setup(spawnerVariant);
	}

	/**
		Run tests, assuming app has been compiled at given path.
	**/
	public static function runTests():Void {
		PicoTestMacros.runTests();
	}

	/**
		Read test results from file.
	**/
	public static function readResult(report:String, header:String = null):Void {
		PicoTestMacros.readResult(report, header = null);
	}

	/**
		Add test filter.
	**/
	public static function filter(pattern:Dynamic):Void {
		if (Std.is(pattern, String)) {
			PicoTestFilter.addPattern(pattern);
		} else if (Std.is(pattern, Class)) {
			PicoTestFilter.addPattern(Type.getClassName(pattern));
		}
	}

	/**
		Add test filters from file.
	**/
	public static function filterFile(fileName:String = "picofilter.txt"):Void {
		PicoTestFilter.readFromFile(fileName);
	}

	#end

}

