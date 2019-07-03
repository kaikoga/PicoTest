# PicoTest

PicoTest, with spirit of [NanoTest](https://github.com/shohei909/NanoTest),
is a very versatile unit testing framework for Haxe.
It attempts to be customizable to fit various use cases.

PicoTest key features:

- [Write](doc/tests.md) parametrized and async tests. 
- [Run](doc/runners.md) tests with HXML workflow, and format display failures as compiler warnings. 
- [Assertions](doc/assertions.md) based on structure based pattern matching.
- [Customize](doc/defines.md) with compiler defines


## Installing PicoTest

Use haxelib git.

```
haxelib git picotest https://github.com/kaikoga/PicoTest.git develop src
```


## Supported system and targets

PicoTest is developed using Haxe 4.0.0-rc.2, but is supposed to run with Haxe 3.4.0 or over.

PicoTest is currently tested in Mac.
Windows, Linux, and BSD are not tested but maybe work.

Currently supported targets are:

- Flash (test runs with standalone Flash Player Debugger)
- Neko
- JavaScript (test runs with Node.js, or with web browsers)
- PHP ( ```-D php7``` is supported )
- Python
- Lua
- C++
- Java (hamcrest not working)
- C# (test runs with Mono (or native on Windows), hamcrest not working)

Note: Running PicoTest with IntelliJ IDEA is supposed to work,
as long as environment variables are properly set and executables such as ```neko```, ```node```, ```java```, ```mono```, etc. are accessible from IDEA. 


# License

The MIT License
