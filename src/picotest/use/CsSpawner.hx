package picotest.use;

#if (macro || macro_doc_gen)

class CsSpawner extends TestSpawner {

	public function new():Void {
		super('cs');
	}

	override public function execute(reportFile:String):Void {
		this.command('./${bin()}/bin/${mainClass()}-Debug.exe', [], reportFile);
	}
}

#end
