package picotest.use;

#if (macro || macro_doc_gen)

class JsNodeSpawner extends TestSpawner {

	public function new():Void {
		super('js_node');
	}

	override public function execute(reportFile:String):Void {
		this.command('node', [bin()], reportFile);
	}
}

#end
