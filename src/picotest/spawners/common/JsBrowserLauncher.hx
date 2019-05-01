package picotest.spawners.common;

#if neko

import picotest.spawners.common.ITestExecuter;
import picotest.spawners.common.PicoTestExternalCommand;
import picotest.spawners.common.PicoTestExternalCommandHelper;
import picotest.spawners.http.PicoHttpServer;
import picotest.spawners.http.PicoHttpServerSetting;

class JsBrowserLauncher implements ITestExecuter {

	public function new() {
	}

	public function execute():Void {
		var args:JsBrowserLauncherParams = PicoTestExternalCommandHelper.anotherNekoArgs();
		var picoServer:PicoHttpServer = PicoTestExternalCommandHelper.startServer(args.httpServerSetting);

		PicoTestExternalCommand.open(args.browser, 'http://localhost:${picoServer.port}/', false, args.reportFile).executeRemote(picoServer);
	}

	public static function main():Void {
		new JsBrowserLauncher().execute();
	}

}


typedef JsBrowserLauncherParams = {
	browser:String,
	httpServerSetting:PicoHttpServerSetting,
	reportFile:String
}

#end
