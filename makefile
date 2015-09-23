# The MIT License (MIT)
# Copyright © 2015 Artium Nihamkin, artium@nihamin.com, http://nihamkin.com
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 
# Makefile Boilerplate
# ====================
# 
# This genereic makefile can assist in quick setup of C/C++ projects.
# 
# It's highlights are:
# 
# - Proper dependency autogeneration using gcc compiler output.
# - Multiple compilation configurations (Debug / Release)
# - Easy cross compiling.
# - Separtate directory for object files and binary files.
# 
# It is written in a way that allows easy addition of platforms and configurations. 
# 
# It is also possible to use it "as is". Simply create the following directory structure for you project:
# 
# Project Root
# ├── makefile
# └── src
#     ├── file1.cpp
#     ├── file2.cpp
#     └── file3.h
# 
# Now you can build you project by calling:
# 
# make CFG=release PLAT=linux
# 
# CFG can be "debug" (default) or "release".
# PLAT can be "linux" (default) or "windows".
# 


# Compiler related common configurations
#
CC_FLAGS := -c -MMD -MP -Wall -std=c++0x
LD_FLAGS=
LD_LIBS=



# makefile commands line parameters
#
ifeq ($(PLAT), windows)

CXX=i586-mingw32msvc-g++ 
SUFFIX := win

else

CXX=g++
SUFFIX := linux

endif


ifeq ($(CFG), release)

CC_FLAGS += -g -O3 -DNDEBUG
LD_FLAGS += -DNDEBUG 
SUFFIX := $(SUFFIX)_release

else

CC_FLAGS += -g -D_GLIBCXX_DEBUG
SUFFIX:=$(SUFFIX)_debug

endif


# Path related configurations
#
SRC_DIR=src
SRCS=$(wildcard $(SRC_DIR)/*.cpp)
OBJ_DIR=obj
BIN_DIR=bin

EXE=$(BIN_DIR)/run_$(SUFFIX)
OBJS=$(SRCS:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%_$(SUFFIX).o)

OBJS_WITHOUT_MAIN=$(filter-out $(OBJ_DIR)/main_$(SUFFIX).o, $(OBJS))

.PHONY: all clean

all: dirs $(EXE) 

# Link only if dependency changed
#
$(EXE): $(OBJS)
	$(CXX) $(LD_FLAGS) -o $@ $^ $(LD_LIBS)

# Create directories. No error if directory already exists
#
dirs:
	mkdir -p $(OBJ_DIR)
	mkdir -p $(BIN_DIR)

# Compile all sources and generate dependency lists
#
$(OBJ_DIR)/%_$(SUFFIX).o: $(SRC_DIR)/%.cpp
	g++ $(CC_FLAGS) -o $@ $<

# Include previously generated dependency lists.
# First time build will build all sources anyway.
#
-include $(OBJ_DIR)/*.d


# Clean
#
clean:
	rm -rf obj bin
