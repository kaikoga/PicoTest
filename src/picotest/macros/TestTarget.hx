package picotest.macros;

#if (macro || macro_doc_gen)

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

#end
