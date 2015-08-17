package picotest.macros.runners;

#if (macro || macro_doc_gen)

class CommandExecuter extends TestExecuter {

	private var cmd:String;
	private var args:Array<String>;

	public function new(cmd:String, args:Array<String> = null, outFile:String = null):Void {
		super();
		this.cmd = cmd;
		this.args = args;
	}

	override public function execute(reportFile:String):Void {
		this.command(this.cmd, this.args, reportFile);
	}
}

#end
