package picotest.out.impl.display;

#if flash

import picotest.result.PicoTestResultMark;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextField;
import flash.Lib;

class PicoTestFlashDisplayOutput implements IPicoTestOutput {

	private var parent:IPicoTestOutput;
	private var header:TextField;
	private var textField:TextField;

	public function new(parent:IPicoTestOutput) {
		this.parent = parent;
		this.header = new TextField();
		this.header.defaultTextFormat = new TextFormat("_sans", 10, 0xff000000);
		this.header.width = Lib.current.stage.stageWidth;
		this.header.height = 50;
		Lib.current.stage.addChild(this.header);

		this.textField = new TextField();
		this.textField.defaultTextFormat = new TextFormat("_sans", 10, 0xff000000);
		this.textField.border = true;
		this.textField.borderColor = 0x66000000;
		this.textField.background = true;
		this.textField.backgroundColor = 0x66ffffff;
		this.textField.selectable = true;
		this.textField.type = TextFieldType.INPUT;
		this.textField.width = Lib.current.stage.stageWidth;
		this.textField.y = 50;
		this.textField.height = Lib.current.stage.stageHeight - 50;
		Lib.current.stage.addChild(this.textField);
	}

	public function output(value:String):Void {
		this.parent.output(value);
		this.textField.appendText(value);
		this.textField.scrollV = this.textField.bottomScrollV;
	}

	public function progress(rate:Float, completed:Int, total:Int):Void {
		this.parent.progress(rate, completed, total);
		return;
	}

	public function complete(status:PicoTestResultMark):Void {
		this.header.background = true;
		switch (status) {
			case PicoTestResultMark.Invalid | PicoTestResultMark.Error:
				this.header.backgroundColor = 0xff990033;
			case PicoTestResultMark.Failure:
				this.header.backgroundColor = 0x66ff0000;
			case PicoTestResultMark.Skip | PicoTestResultMark.Ignore:
				this.header.backgroundColor = 0x66ffff00;
			case PicoTestResultMark.Success:
				this.header.backgroundColor = 0x6600ff00;
			case _:
				this.header.textColor = 0xff999999;
		}
		this.parent.complete(status);
		return;
	}

	public function close():Void this.parent.close();
}

#end

