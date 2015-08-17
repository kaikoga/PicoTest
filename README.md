PicoTest, based on [NanoTest](https://github.com/shohei909/NanoTest),
is a (to-be) very versatile unit testing framework for Haxe.
It attempts to be customizable to fit various use cases, without meddling.

PicoTest can run tests and display failures as compiler warnings.

#Installing PicoTest

You can install PicoTest from haxelib.

```
haxelib git picotest https://github.com/kaikoga/PicoTest.git master src
haxelib install hamcrest
```

PicoTest is developed using Haxe 3.2.

#Running test through macro

Write test classes and run with 

```
cd samples
haxe swf.hxml
```

Adding ```--macro picotest.PicoTest.warn()``` is supposed to work without customizations.
(only tested in Mac for now)

Currently supported targets are:

- Flash (test runs with standalone Flash Player Debugger)
- Neko
- JavaScript (test runs with Node.js)
- PHP
- C++
- Java (hamcrest not working)
- C# (test runs with Mono (or native on Windows), hamcrest not working)

Python target is currently not working.

Currently supported systems are:
- Mac

Windows, Linux, and BSD are not tested but maybe work.

##Running using IntelliJ IDEA

Supposed to work, as long as you set the $PATH of IDEA to point the executables
of ```neko```, ```node```, ```java```, ```mono```, etc.

Launching IDEA from Terminal with ```open -a "IntelliJ IDEA 14"``` will be the easiest in Mac.

#Compiler Defines

##Cross

```-D picotest_nodep``` Removes hamcrest support

##Flash

```-D picotest_fp``` Path to executable of Flash Player  
```-D picotest_flog``` Path to flashlog.txt  
```-D picotest_report=json``` output report file (used internally by PicoTest.warn())  
```-D picotest_report_dir``` Path to output test report file (default ```bin/report```)  

#Planned Features

- Support basic assertions standalone
- "throw" testing
- Async testing
- Options to run Flash/js in browser 
- Setting path to executables of ```neko```, ```node```, ```java```, ```mono```, etc... 
- Support more platforms! 

#License

The MIT License
