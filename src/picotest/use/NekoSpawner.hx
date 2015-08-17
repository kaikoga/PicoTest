package picotest.use;

#if (macro || macro_doc_gen)

class NekoSpawner extends TestSpawner {

	public function new():Void {
		super('neko');
	}

	override public function execute(reportFile:String):Void {
		CommandHelper.command('neko', [bin()], reportFile);
	}
}

#end
