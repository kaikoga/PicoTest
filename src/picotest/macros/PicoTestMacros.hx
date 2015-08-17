package picotest.macros;

#if (macro || macro_doc_gen)
import picotest.macros.runners.CommandExecuter;
import picotest.macros.runners.FlashStandaloneExecuter;
import picotest.macros.runners.TestExecuter;
import sys.io.File;
import sys.FileSystem;
import sys.io.Process;
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
		var bin:String = Compiler.getOutput();
		var reportDir:String = "bin/report";
		if (Context.defined(PICOTEST_REPORT_DIR)) reportDir = Context.definedValue(PICOTEST_REPORT_DIR);
		var reportFile:String = '$reportDir/${testTarget.toString()}.json';
		FileSystem.createDirectory(reportDir);

		var executer:TestExecuter;
		switch (testTarget) {
			case TestTarget.Flash:
				executer = new FlashStandaloneExecuter();
			case TestTarget.Neko:
				executer = new CommandExecuter('neko', [bin]);
			case TestTarget.Js:
				executer = new CommandExecuter('node', [bin]);
			case TestTarget.Php:
				executer = new CommandExecuter('php', ['$bin/index.php']);
			case TestTarget.Cpp:
				executer = new CommandExecuter('./$bin/$mainClass-debug', []);
			case TestTarget.Java:
				executer = new CommandExecuter('java', ['-jar', './$bin/$mainClass-debug.jar']);
			case TestTarget.Cs:
				switch (Sys.systemName()) {
					case "Windows":
						executer = new CommandExecuter('./$bin/bin/$mainClass-Debug.exe', []);
					default:
						executer = new CommandExecuter('mono', ['./$bin/bin/$mainClass-Debug.exe']);
				}
			case TestTarget.Python:
				executer = new CommandExecuter('python', [bin]);
			default:
				throw 'target ${testTarget.toString()} not supported';
		}

		executer.execute(reportFile);
		readResult(reportFile);
	}

	public static function readResult(report:String, header:String = null):Void {
		if (header == null) header = testTarget.toString();
		var runner:PicoTestRunner = PicoTest.runner();
		runner.reporters = [new WarnReporter()];
		new PicoTestFileResultReader().read(runner, report, header);
		runner.run();
	}

	private static function command(cmd:String, args:Array<String> = null, outFile:String = null):Void {
		if (args == null) args = [];
		var process:Process = new Process(cmd, args);
		var err:Int = process.exitCode();
		if (err != 0) {
			throw '$cmd ${args.join(" ")}:$err: ${process.stdout.readAll()}';
		}
		if (outFile != null) {
			var out = File.write(outFile);
			out.write(process.stdout.readAll());
			out.close();
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
