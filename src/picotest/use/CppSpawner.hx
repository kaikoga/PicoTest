package picotest.use;

#if (macro || macro_doc_gen)

class CppSpawner extends TestSpawner {

	public function new():Void {
		super('cpp_${systemName().toLowerCase()}');
	}

	override public function execute(reportFile:String):Void {
		this.command('./${bin()}/${mainClass()}-debug', [], reportFile);
	}
}

#end
