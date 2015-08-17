package picotest.use;

#if (macro || macro_doc_gen)

class PythonSpawner extends TestSpawner {

	public function new():Void {
		super('python');
	}

	override public function execute(reportFile:String):Void {
		this.command('python', [bin()], reportFile);
	}
}

#end
