package picotest.use;

import picotest.use.http.PicoHttpServer.PicoHttpServerSetting;

#if neko

import picotest.use.common.PicoTestExternalCommandHelper;
import picotest.use.common.ITestExecuter;
import picotest.use.common.PicoTestExternalCommand;

class JsBrowserLauncher implements ITestExecuter {

	public function new() {
	}

	public function execute():Void {
		var args:JsBrowserLauncherParams = PicoTestExternalCommandHelper.anotherNekoArgs();
		PicoTestExternalCommand.open(args.browser, 'http://localhost:${args.httpServerSetting.port}/', false, args.reportFile).executeRemote(args.httpServerSetting);
	}

	public static function main():Void {
		new JsBrowserLauncher().execute();
	}

}

#end

typedef JsBrowserLauncherParams = {
	browser:String,
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}
