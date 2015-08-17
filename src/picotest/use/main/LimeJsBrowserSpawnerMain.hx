package picotest.use.main;

import picotest.use.http.PicoHttpServer.PicoHttpServerSetting;

#if neko

import picotest.use.common.ITestExecuter;
import picotest.use.common.CommandHelper;

class LimeJsBrowserSpawnerMain implements ITestExecuter {

	public static function main():Void {
		new LimeJsBrowserSpawnerMain().execute();
	}

	public function execute():Void {
		var args:LimeJsBrowserSpawnerParams = CommandHelper.anotherNekoArgs();
		CommandHelper.remoteCommand('open', ['-a', 'Firefox', 'http://localhost:${args.httpServerSetting.port}/'], args.reportFile, args.httpServerSetting);
	}
}

#end

typedef LimeJsBrowserSpawnerParams = {
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
