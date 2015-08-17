package picotest.use;

#if (macro || macro_doc_gen)

class CommandSpawner extends TestSpawner {

	private var cmd:String;
	private var args:Array<String>;

	public function new(name:String, cmd:String, args:Array<String> = null, outFile:String = null):Void {
		super(name);
		this.cmd = cmd;
		this.args = args;
	}

	override public function execute(reportFile:String):Void {
		this.command(this.cmd, this.args, reportFile);
	}
}

#end
