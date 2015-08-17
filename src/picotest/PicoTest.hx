package picotest;

import picotest.reporters.JsonReporter;
import haxe.PosInfos;
import picotest.reporters.TraceReporter;
import picotest.printers.TracePrinter;

class PicoTest {

	inline public static var VERSION:String = "0.0.0";
	public static var currentRunner:PicoTestRunner;
	public static var classPaths:Array<String> = [];

	private function new() {
	}

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

	#if macro
	public static function warn():Void {
		PicoTestMacros.warn();
	}

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
	public static dynamic function stdout(value:String):Void {
		var lines:Array<String> = (_currentLine + value).split("\n");
		_currentLine = lines.pop();
		for (line in lines) println(line);
	}

}
