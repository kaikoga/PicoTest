package picotest;

import haxe.io.Bytes;
import picotest.macros.PicoTestMacros;
import picotest.reporters.JsonReporter;
import haxe.PosInfos;
import picotest.reporters.TraceReporter;
import picotest.printers.TracePrinter;

#if sys
import sys.net.Host;
import sys.net.Socket;
#end

#if js
import js.html.XMLHttpRequest;
#end

class PicoTest {

	/**
		Version of PicoTest.
	**/
	inline public static var VERSION:String = "0.5.0";

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

		#if picotest_remote
		stdout = stdoutRemote;
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

	public static dynamic function stdoutRemote(value:String):Void {
		// we use HTTP POST compatible format, as JS doesn't support raw sockets
		#if sys
		var socket:Socket = new Socket();
		socket.connect(new Host("127.0.0.1"), 8001);
		socket.write("POST result .\r\n\r\n");
		socket.output.write(Bytes.ofString(value));
		socket.close();
		#elseif js
		var xhr:XMLHttpRequest = new XMLHttpRequest();
		xhr.open("POST", "result");
		xhr.send(value);
		#end
	}

}
