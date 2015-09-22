
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
