echo off
cd build\tools\
masm ..\..\src\main.asm;
link main.obj;
copy main.exe ..\output
del main.exe
del main.obj
cd ..\output\
echo Finished building, type "main" to start the program