package picotest.use.main;

import picotest.use.http.PicoHttpServer.PicoHttpServerSetting;

#if neko

import picotest.use.common.ITestExecuter;
import picotest.use.common.CommandHelper;

class JsBrowserSpawnerMain implements ITestExecuter {

	public static function main():Void {
		new JsBrowserSpawnerMain().execute();
	}

	public function execute():Void {
		var args:JsBrowserSpawnerParams = CommandHelper.anotherNekoArgs();
		CommandHelper.remoteCommand('open', ['-a', 'Firefox', 'http://localhost:${args.httpServerSetting.port}/'], args.reportFile, args.httpServerSetting);
	}

}

#end

typedef JsBrowserSpawnerParams = {
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
