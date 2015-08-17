package picotest.use.common;

import haxe.macro.Context;
import sys.io.File;
import haxe.Unserializer;
import haxe.crypto.Base64;
import haxe.Serializer;
import haxe.io.Bytes;

#if (sys || macro || macro_doc_gen)

class PicoTestExternalCommandHelper {

	inline public static var PICOTEST_ANOTHER_NEKO_ARGS:String = "picotest_another_neko_args";

	private function new():Void {
	}

	public static function serializeBase64(value:Dynamic):String {
		return Base64.encode(Bytes.ofString(Serializer.run(value)), false);
	}

	public static function deserializeBase64(value:String):Dynamic {
		return Unserializer.run(Base64.decode(value, false).toString());
	}

	macro public static function anotherNekoArgs():Dynamic {
		return macro PicoTestExternalCommandHelper.deserializeBase64($v{Context.definedValue(PicoTestExternalCommandHelper.PICOTEST_ANOTHER_NEKO_ARGS)});
	}

	public static function writeFile(data:Bytes, fileName:String = null):Void {
		if (fileName != null) {
			var out = File.write(fileName);
			out.write(data);
			out.close();
		}
	}

}

#end
