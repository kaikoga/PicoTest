package picotest.use.main;

import picotest.use.http.PicoHttpServer.PicoHttpServerSetting;

#if neko

class JsBrowserSpawnerMain {

	public static function main():Void {
		var args:JsBrowserSpawnerParams = CommandHelper.anotherNekoArgs();
		CommandHelper.remoteCommand('open', ['-a', 'Firefox', 'http://localhost:${args.httpServerSetting.port}/'], args.reportFile, args.httpServerSetting);
	}

}

#end

typedef JsBrowserSpawnerParams = {
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
