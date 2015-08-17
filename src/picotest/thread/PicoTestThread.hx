package picotest.thread;
#if (cpp || neko)
typedef PicoTestThread = PicoTestHaxeThread;
#elseif python
typedef PicoTestThread = PicoTestPythonThread;
#elseif java
typedef PicoTestThread = PicoTestJavaThread;
#elseif cs
typedef PicoTestThread = PicoTestCsThread;
#else
typedef PicoTestThread = PicoTestThreadUnavailable;
#end
