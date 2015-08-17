package picotest.use;

#if (macro || macro_doc_gen)

class CsMonoSpawner extends TestSpawner {

	public function new():Void {
		super('cs_mono');
	}

	override public function execute(reportFile:String):Void {
		this.command('mono', ['./${bin()}/bin/${mainClass()}-Debug.exe'], reportFile);
	}
}

#end
