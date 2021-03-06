## goals

This project provides a simple to install and use cross compiler environment, 


- simple installation of cross compiling environment
e.g ./install.sh

- easy to workflow with target board
e.g xcCompileRun render.cpp

- support for cmake, with cmake toolchain

- use modern tools
clang-10, llvm, cmake


## requirements
supported OS are:
- macOS
- Linux (debian based e.g. deb/ubuntu)

it would be easy to add other linux variants
windows could probably be done using gnu/cygwin tools
however, I dont have the time.... but Im happy to accept pull requests from others :)



## installation
see [install.md](https://github.com/TheTechnobear/xcBela/blob/master/install.md)


## usage

installs and runs by default using 
location: `~/xcBela`
bela hostname : `192.168.7.2` , default for usb

you can override with environment variables, if using a different bela, or scripts placed somewhere else
e.g.

```
export XC_IP=salt.local
export XC_ROOT=~/projects/xcBela
```

note: when these are stored in `~/.xcBela.config`, by install.sh, and xcSetEnv, so only need to be done once, or if you are changing target etc.

## setup environment
```
. $XC_ROOT/xcSetEnv
```
usage note: . (dot) - do **not** run as a script directly 



## commands
xcExec remotecmd - execute command on remote 
xcCopy localfile remotefile - copy local file to remote 
xcCompile patch - compile all cpp in directory, executable name path
xcRun  patch - run (local executable) patch on remote
xcCompileRun patch  - compile local file and run on remote 
xcScope - bring up scope
xcGui - bring up gui

## compilation
the compile scripts are **very** simple

`xcCompile patch` 
will compile all cpp files in current directory, and then produce an output (executable) file called patch
note: exe name can be anything,
note: compiling takes no arguments, see below.

`xcRun patch -h` 
will copy the 'patch' executable to the target machine and run it passing the arguments to it (-h in this example)
ctrl-C will quit it, and kill the process (patch)

`xcCompileRun patch -h` 
will call xcCompile then xcRun, note: how args are for the running on patch, not the compiler


**Using Compiler and Link flags**
if you want to use compiler and link flags, use the env vars CPPFLAGS and LDFLAGS
e.g. 
```
CPPFLAGS="-v --save-temps" LDFLAGS=-Wl,--verbose=1 xcCompile abc
```
note: how I use quotes for multiple flags


## using with cmake
included in this project is a template which can be used as a cmake toolchain, 
see [cmakefaq.md](https://github.com/TheTechnobear/xcBela/blob/master/cmake/cmakefaq.md)


## using Bela tools


### Bela commands
the 'usual' bela command line scripts are also available (and on the path),
e.g. we can disable the ide with
```
ide.sh stop
```

### Accessing Bela IDE
my main intention is not to use the IDE for development so editing and compiling. but it still has a couple of useful features I will use
(assuming, Ive not disabled ide at that time ;)  ) 

note: shortcuts assume chromium-browser on linux

**Oscilloscope**
shortcut: xcScope
this is available directly in a browser using: http://bela.local/scope



**Bela Patch GUI** 
bela now supports web user interfaces
shortcut: xcGui
this can be access in the browser using: http://bela.local/gui

## Credits & Resources

article on cross-compiling on mac 
https://medium.com/@haraldfernengel/cross-compiling-c-c-from-macos-to-raspberry-pi-in-2-easy-steps-23f391a8c63

cross compile script from by Andrew Capon, can be found here:
https://github.com/AndrewCapon/OSXBelaCrossCompiler

Bela wiki on remote compilation with Eclipse
https://github.com/BelaPlatform/Bela/wiki/Compiling-Bela-projects-in-Eclipse

