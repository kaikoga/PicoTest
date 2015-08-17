package picotest.use;

#if (macro || macro_doc_gen)

class JavaSpawner extends TestSpawner {

	public function new():Void {
		super('java');
	}

	override public function execute(reportFile:String):Void {
		this.command('java', ['-jar', './${bin()}/${mainClass()}-debug.jar'], reportFile);
	}
}

#end
