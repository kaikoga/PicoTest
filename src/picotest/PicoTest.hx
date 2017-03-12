package picotest;

import picotest.macros.PicoTestConfig;
import picotest.printers.VerboseTracePrinter;
import picotest.out.PicoTestOutput;
import picotest.macros.PicoTestMacros;
import picotest.reporters.JsonReporter;
import haxe.PosInfos;
import picotest.reporters.TraceReporter;

class PicoTest {

	/**
		Version of PicoTest.
	**/
	inline public static var VERSION:String = "0.7.7";

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

		if (PicoTestConfig.remote) {
			var onComplete = runner.onComplete;
			runner.onComplete = function() {
				onComplete();
			}
		}

		if (PicoTestConfig.reportJson) {
			haxe.Log.trace = emptyTrace;
			runner.printers = [new VerboseTracePrinter(output)];
			runner.reporters = [new JsonReporter(output)];
		} else {
			runner.printers = [new VerboseTracePrinter(output)];
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

	#end

}

