Makefile Boilerplate
====================

This genereic makefile can assist in quick setup of C/C++ projects.

It's highlights are:

- Proper dependency autogeneration using gcc compiler output.
- Multiple compilation configurations (Debug / Release)
- Easy cross compiling.
- Separtate directory for object files and binary files.

It is written in a way that allows easy addition of platforms and configurations. 

It is also possible to use it "as is". Simply create the following directory structure for you project:

>Project Root
>├── makefile
>└── src
>    ├── file1.cpp
>    ├── file2.cpp
>    └── file3.h

Now you can build you project by calling:

```
make CFG=release PLAT=linux
```

**CFG** can be "*debug*" (default) or "*release*".
**PLAT** can be "*linux*" (default) or "*windows*".



