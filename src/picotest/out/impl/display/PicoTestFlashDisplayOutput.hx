package picotest.out.impl.display;

#if flash

import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextField;
import flash.Lib;

class PicoTestFlashDisplayOutput implements IPicoTestOutput {

	private var parent:IPicoTestOutput;
	private var textField:TextField;

	public function new(parent:IPicoTestOutput) {
		this.parent = parent;
		this.textField = new TextField();
		this.textField.defaultTextFormat = new TextFormat("_sans", 10, 0xff000000);
		this.textField.border = true;
		this.textField.borderColor = 0x66000000;
		this.textField.background = true;
		this.textField.backgroundColor = 0x66ffffff;
		this.textField.selectable = true;
		this.textField.type = TextFieldType.INPUT;
		this.textField.width = Lib.current.stage.stageWidth;
		this.textField.height = Lib.current.stage.stageHeight;
		Lib.current.stage.addChild(this.textField);
	}

	public function output(value:String):Void {
		this.parent.output(value);
		this.textField.appendText(value);
		this.textField.scrollV = this.textField.bottomScrollV;
	}

	public function close():Void this.parent.close();
}

#end

