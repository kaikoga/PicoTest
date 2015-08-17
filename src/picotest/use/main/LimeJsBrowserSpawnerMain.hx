package picotest.use.main;

#if neko

import picotest.use.http.PicoHttpServer.PicoHttpServerSetting;

class LimeJsBrowserSpawnerMain {

	public static function main():Void {
		var args:LimeJsBrowserSpawnerParams = CommandHelper.anotherNekoArgs();
		CommandHelper.remoteCommand('open', ['-a', 'Firefox', 'http://localhost:${args.httpServerSetting.port}/'], args.reportFile, args.httpServerSetting);
	}

}

#end

typedef LimeJsBrowserSpawnerParams = {
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
