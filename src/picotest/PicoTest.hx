package picotest;

import picotest.reporters.JsonReporter;
import haxe.PosInfos;
import picotest.reporters.TraceReporter;
import picotest.printers.TracePrinter;

class PicoTest {

	/**
		Version of PicoTest.
	**/
	inline public static var VERSION:String = "0.1.0";

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
		#if picotest_report
		haxe.Log.trace = emptyTrace;
		runner.printers = [];
		runner.reporters = [new JsonReporter()];
		#else
		runner.printers = [new TracePrinter()];
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
		Read test results from file.
	**/
	public static function readResult(report:String, header:String):Void {
		PicoTestMacros.readResult(report, header);
	}

	private static function println(line:String):Void {
		PicoTestMacros.println(line);
	}
	#else
	private static function println(line:String):Void {
		#if flash
		flash.Lib.trace(line);
		#elseif neko
		untyped $print('$line\n');
		#elseif js
		untyped js.Boot.__trace(cast line, null);
		#elseif php
		untyped __call__('_hx_trace', line, null);
		#elseif cpp
		untyped __cpp__('puts(line.__s)');
		#elseif cs
		untyped __cs__("System.Console.WriteLine(line);");
		#elseif java
		untyped __java__("java.lang.System.out.println(line);");
		#elseif python
		python.Lib.println(line);
		#end
	}
	#end

	private static var _currentLine:String = "";
	/**
		Low-level cross-platform output without decoration.
	**/
	public static dynamic function stdout(value:String):Void {
		var lines:Array<String> = (_currentLine + value).split("\n");
		_currentLine = lines.pop();
		for (line in lines) println(line);
	}

}
