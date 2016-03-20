package picotest;

import picotest.printers.VerboseTracePrinter;
import picotest.out.PicoTestOutput;
import picotest.out.IPicoTestOutput;
import picotest.macros.PicoTestMacros;
import picotest.reporters.JsonReporter;
import haxe.PosInfos;
import picotest.reporters.TraceReporter;
import picotest.printers.SimpleTracePrinter;

class PicoTest {

	/**
		Version of PicoTest.
	**/
	inline public static var VERSION:String = "0.7.3";

	/**
		Current target runner which assertions are run against.
	**/
	@:allow(picotest.PicoTestRunner)
	public static var currentRunner(default, null):PicoTestRunner;

	private static var output:IPicoTestOutput;

	private function new() {
	}

	/**
		Creates a PicoTestRunner.
	**/
	public static function runner():PicoTestRunner {
		var runner = new PicoTestRunner();

		output = new PicoTestOutput();

		#if picotest_remote
		var onComplete = runner.onComplete;
		runner.onComplete = function() {
			output.close();
			onComplete();
		}
		#end

		#if picotest_report
		haxe.Log.trace = emptyTrace;
		runner.printers = [new VerboseTracePrinter()];
		runner.reporters = [new JsonReporter()];
		#else
		runner.printers = [new VerboseTracePrinter()];
		runner.reporters = [new TraceReporter()];
		#end

		return runner;
	}

	private static function emptyTrace(v:Dynamic, ?infos:PosInfos):Void {

	}

	#if (macro || macro_doc_gen)
	/**
		Run tests after compile and emits result as compiler warnings.
	**/
	public static function warn():Void {
		PicoTestMacros.warn();
	}

	/**
		Build tests for executing in runTests().
	**/
	public static function setup():Void {
		PicoTestMacros.setup();
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

	public static function stdout(value:String):Void {
		output.stdout(value);
	}

}

