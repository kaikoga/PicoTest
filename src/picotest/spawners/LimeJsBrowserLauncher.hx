package picotest.spawners;

import picotest.spawners.http.PicoHttpServer.PicoHttpServerSetting;

#if neko

import picotest.spawners.common.ITestExecuter;
import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.PicoTestExternalCommandHelper;

class LimeJsBrowserLauncher implements ITestExecuter {

	public function new() {
	}

	public function execute():Void {
		var args:LimeJsBrowserLauncherParams = PicoTestExternalCommandHelper.anotherNekoArgs();
		PicoTestExternalCommand.open(args.browser, 'http://localhost:${args.httpServerSetting.port}/', false, args.reportFile).executeRemote(args.httpServerSetting);
	}

	public static function main():Void {
		new LimeJsBrowserLauncher().execute();
	}
}

#end

typedef LimeJsBrowserLauncherParams = {
	browser:String,
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
