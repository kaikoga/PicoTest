package picotest;

#if (macro || macro_doc_gen)
import haxe.macro.Compiler;
import haxe.macro.Context;
import picotest.readers.PicoTestFileResultReader;
import picotest.reporters.WarnReporter;

/**
	Macro definitions of PicoTest. Calling through `picotest.PicoTest` is recommended.
**/
class PicoTestMacros {

	inline public static var PICOTEST_REPORT:String = "picotest_report";
	inline public static var PICOTEST_REPORT_JSON:String = "json";
	inline public static var PICOTEST_REPORT_DIR:String = "picotest_report_dir";
	inline public static var PICOTEST_FP:String = "picotest_fp";
	inline public static var PICOTEST_FLOG:String = "picotest_flog";

	private function new() {
	}

	private static var testTarget(get, never):TestTarget;
	private static function get_testTarget():TestTarget {
		for (target in TestTarget.allTargets) {
			if (Context.defined(target.toString())) return target;
		}
		return TestTarget.Neko;
	}

	public static function warn():Void {
		Compiler.define(PICOTEST_REPORT, PICOTEST_REPORT_JSON);
		Context.onAfterGenerate(runTests);
	}

	public static function runTests():Void {
		var args:Array<String> = Sys.args();
		var main:String = args[args.indexOf("-main") + 1];
		var mainClass:String = main.split(".").pop();
		var system:String = Sys.systemName();
		var bin:String = Compiler.getOutput();
		var reportDir:String = "bin/report";
		if (Context.defined(PICOTEST_REPORT_DIR)) reportDir = Context.definedValue(PICOTEST_REPORT_DIR);
		var reportFile:String = '$reportDir/${testTarget.toString()}.json';
		switch (system) {
			case "Windows":
				command('mkdir $reportDir');
			case "Linux", "BSD", "Mac":
				command('mkdir -p $reportDir');
			default:
				throw 'Could not create report directory in platform $system';
		}
		switch (testTarget) {
			case TestTarget.Flash:
				var fp:String = null;
				var flog:String = null;
				if (Context.defined(PICOTEST_FP)) fp = Context.definedValue(PICOTEST_FP);
				if (Context.defined(PICOTEST_FLOG)) flog = Context.definedValue(PICOTEST_FLOG);
				switch (system) {
					case "Windows":
						if (fp == null) fp = '"C:/Program Files (x86)/FlashPlayerDebugger.exe"';
						if (flog == null) flog = '"%APPDATA%/Macromedia/Flash Player/Logs/flashlog.txt"';
						command('$fp $bin');
						command('cp $flog $reportFile');
					case "Linux":
						if (fp == null) fp = 'flashplayer';
						if (flog == null) flog = '~/Macromedia/Flash_Player/Logs/flashlog.txt';
						command('$fp $bin');
						command('cp $flog $reportFile');
					case "Mac":
						if (fp == null) fp = '"Flash Player Debugger"';
						if (flog == null) flog = '~/Library/Preferences/Macromedia/Flash\\ Player/Logs/flashlog.txt';
						command('open -nWa $fp $bin');
						command('cp $flog $reportFile');
					default:
						throw 'Flash warning in platform $system not supported';
				}
			case TestTarget.Neko:
				command('(neko $bin > $reportFile)');
			case TestTarget.Js:
				command('(node $bin > $reportFile)');
			case TestTarget.Php:
				command('(php $bin/index.php > $reportFile)');
			case TestTarget.Cpp:
				command('(./$bin/$mainClass-debug > $reportFile)');
			case TestTarget.Java:
				command('(java -jar ./$bin/$mainClass-debug.jar > $reportFile)');
			case TestTarget.Cs:
				switch (system) {
					case "Windows":
						command('(./$bin/bin/$mainClass-Debug.exe > $reportFile)');
					default:
						command('(mono ./$bin/bin/$mainClass-Debug.exe > $reportFile)');
				}
			case TestTarget.Python:
				command('(python $bin > $reportFile)');
			default:
				throw 'target ${testTarget.toString()} not supported';
		}
		readResult(reportFile, testTarget.toString());
	}

	public static function readResult(report:String, header:String):Void {
		var runner:PicoTestRunner = PicoTest.runner();
		runner.reporters = [new WarnReporter()];
		new PicoTestFileResultReader().read(runner, report, header);
		runner.run();
	}

	private static function command(cmd:String, ?args:Array<String>):Void {
		var c = (args != null) ? cmd + " " + args.join(" ") : cmd;
		var err:Int = neko.Lib.load("std","sys_command",1)(untyped(c.__s));
		if (err != 0) {
			throw c;
		}
	}

	private static var _lineNum:Int = 1;
	public static function println(line:String):Void {
		Context.warning(line, Context.makePosition({ file : "_", min : _lineNum, max : _lineNum }));
		_lineNum++;
	}
}
@:noDoc
@:enum abstract TestTarget(String) {
	public var Flash = "flash";
	public var As3 = "as3";
	public var Neko = "neko";
	public var Js = "js";
	public var Php = "php";
	public var Cpp = "cpp";
	public var Java = "java";
	public var Cs = "cs";
	public var Python = "python";

	public static var allTargets(get, never):Array<TestTarget>;
	public static function get_allTargets():Array<TestTarget> {
		return [
			TestTarget.Flash,
			TestTarget.As3,
			TestTarget.Neko,
			TestTarget.Js,
			TestTarget.Php,
			TestTarget.Cpp,
			TestTarget.Java,
			TestTarget.Cs,
			TestTarget.Python
		];
	}
	public function toString():String return this;
}

#else
@:noDoc class PicoTestMacros { private function new() {} }
#end
