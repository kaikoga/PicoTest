package picotest.macros;

#if (macro || macro_doc_gen)
import picotest.use.NekoSpawner;
import picotest.use.PythonSpawner;
import picotest.use.PhpSpawner;
import picotest.use.JsNodeSpawner;
import picotest.use.JavaSpawner;
import picotest.use.CsMonoSpawner;
import picotest.use.CsSpawner;
import picotest.use.CppSpawner;
import picotest.use.LimeSpawner;
import picotest.use.FlashStandaloneSpawner;
import picotest.use.TestSpawner;
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
	inline public static var PICOTEST_REPORT_REMOTE:String = "picotest_remote";
	inline public static var PICOTEST_REPORT_REMOTE_PORT:String = "picotest_remote_port";
	inline public static var PICOTEST_REPORT_DIR:String = "picotest_report_dir";
	inline public static var PICOTEST_FP:String = "picotest_fp";
	inline public static var PICOTEST_FLOG:String = "picotest_flog";

	private function new() {
	}

	public static var spawner:TestSpawner = null;

	private static var _testTarget:TestTarget = null;
	private static var testTarget(get, never):TestTarget;
	private static function get_testTarget():TestTarget {
		if (_testTarget == null) {
			_testTarget = TestTarget.Neko;
			for (target in TestTarget.allTargets) {
				if (Context.defined(target.toString())) _testTarget = target;
			}
		}
		return _testTarget;
	}

	public static function warn():Void {
		Compiler.define(PICOTEST_REPORT, PICOTEST_REPORT_JSON);
		Context.onAfterGenerate(runTests);
	}

	public static function runTests():Void {
		var reportDir:String = "bin/report";
		if (Context.defined(PICOTEST_REPORT_DIR)) reportDir = Context.definedValue(PICOTEST_REPORT_DIR);
		FileSystem.createDirectory(reportDir);

		if (spawner == null) spawner = guessSpawner();
		var reportFile:String = '$reportDir/${spawner.name}.json';
		spawner.execute(reportFile);
		readResult(reportFile, spawner.name);
	}

	public static function readResult(report:String, header:String):Void {
		var runner:PicoTestRunner = PicoTest.runner();
		runner.reporters = [new WarnReporter()];
		new PicoTestFileResultReader().read(runner, report, header);
		runner.run();
	}

	private static function guessSpawner():TestSpawner {
		var spawnerType:Array<String> = [testTarget.toString(), null];
		switch (testTarget) {
			case TestTarget.Flash:
				spawnerType[1] = "sa";
			case TestTarget.Neko:
			case TestTarget.Js:
				spawnerType[1] = "node";
			case TestTarget.Php:
			case TestTarget.Cpp:
			case TestTarget.Java:
			case TestTarget.Cs:
				if (Sys.systemName() != "Windows") spawnerType[1] = "mono";
			case TestTarget.Python:
			default:
				throw 'target ${testTarget.toString()} not supported';
		}

		var args:Array<String> = Sys.args();
		var main:String = args[args.indexOf("-main") + 1];
		var mainClass:String = main.split(".").pop();
		var bin:String = Compiler.getOutput();

		switch (spawnerType) {
			case ["flash", _]:
				return new FlashStandaloneSpawner();
			case ["neko", _]:
				return new NekoSpawner();
			case ["js", "node"]:
				return new JsNodeSpawner();
			case ["php", _]:
				return new PhpSpawner();
			case ["cpp", _]:
				return new CppSpawner();
			case ["java", _]:
				return new JavaSpawner();
			case ["cs", "mono"]:
				return new CsMonoSpawner();
			case ["cs", _]:
				return new CsSpawner();
			case ["python", _]:
				return new PythonSpawner();
			default:
				throw 'test spawner ${spawnerType[1]} in target ${spawnerType[0]} not found';
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
