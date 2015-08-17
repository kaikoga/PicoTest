package picotest.use.main;

import picotest.use.http.PicoHttpServer.PicoHttpServerSetting;

#if neko

import picotest.use.common.ITestExecuter;
import picotest.use.common.PicoTestExternalCommand;
import picotest.use.common.PicoTestExternalCommandHelper;

class LimeJsBrowserSpawnerMain implements ITestExecuter {

	public function new() {
	}

	public function execute():Void {
		var args:LimeJsBrowserSpawnerParams = PicoTestExternalCommandHelper.anotherNekoArgs();
		PicoTestExternalCommand.open('Firefox', 'http://localhost:${args.httpServerSetting.port}/', false, args.reportFile).executeRemote(args.httpServerSetting);
	}

	public static function main():Void {
		new LimeJsBrowserSpawnerMain().execute();
	}
}

#end

typedef LimeJsBrowserSpawnerParams = {
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
