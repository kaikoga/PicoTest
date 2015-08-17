package picotest.use;

#if (macro || macro_doc_gen)

class CppSpawner extends TestSpawner {

	public function new():Void {
		super('cpp_${CommandHelper.systemName().toLowerCase()}');
	}

	override public function execute(reportFile:String):Void {
		CommandHelper.command('./${bin()}/${mainClass()}-debug', [], reportFile);
	}
}

#end
