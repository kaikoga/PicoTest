package picotest.use.main;

import picotest.use.http.PicoHttpServer.PicoHttpServerSetting;

#if neko

import picotest.use.common.PicoTestExternalCommandHelper;
import picotest.use.common.ITestExecuter;
import picotest.use.common.PicoTestExternalCommand;

class JsBrowserSpawnerMain implements ITestExecuter {

	public function new() {
	}

	public function execute():Void {
		var args:JsBrowserSpawnerParams = PicoTestExternalCommandHelper.anotherNekoArgs();
		PicoTestExternalCommand.open(args.browser, 'http://localhost:${args.httpServerSetting.port}/', false, args.reportFile).executeRemote(args.httpServerSetting);
	}

	public static function main():Void {
		new JsBrowserSpawnerMain().execute();
	}

}

#end

typedef JsBrowserSpawnerParams = {
	browser:String,
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
