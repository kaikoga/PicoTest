package picotest.use.main;

import picotest.use.CommandHelper.HttpServer;

#if neko

class JsBrowserSpawnerMain {

	public static function main():Void {
		var args:JsBrowserSpawnerParams = CommandHelper.anotherNekoArgs();
		CommandHelper.remoteCommand('open', ['-a', 'Firefox', 'http://localhost:${args.httpServer.port}/'], args.reportFile, args.httpServer);
	}

}

#end

typedef JsBrowserSpawnerParams = {
	httpServer:HttpServer,
	reportFile:String
}
