package picotest.use;

#if (macro || macro_doc_gen)

class PhpSpawner extends TestSpawner {

	public function new():Void {
		super('php');
	}

	override public function execute(reportFile:String):Void {
		this.command('php', ['${bin()}/index.php'], reportFile);
	}
}

#end
