# When clock skew appears uncomment this line
# $(shell find . -exec touch {} \;)

TARGET_EXEC := ./build/SpringBoard


XC_SYSROOT := ./sysroot
BUILD_DIR  := ./build
SRC_DIRS   := ./Bela/projects/SpringBoard ./Bela/libraries/Batk


TOOLCHAIN=/usr/lib/llvm-10
CLANG=/usr/bin/clang++-10

#-Wextra
CFLAGS=-O3 -fPIC -DXENOMAI_SKIN_posix -march=armv7-a -mtune=cortex-a8 -mfloat-abi=hard -mfpu=neon -ftree-vectorize -ffast-math -I$(XC_SYSROOT)/root/Bela -I$(XC_SYSROOT)/root/Bela/include -I$(XC_SYSROOT)/usr/xenomai/include

OPTS=--target=arm-linux-gnueabihf \
	--sysroot=$(XC_SYSROOT) \
	-isysroot $(XC_SYSROOT) \
	-isystem $(XC_SYSROOT)/usr/include/c++/6.3.0 \
	-isystem $(XC_SYSROOT)/usr/include/arm-linux-gnueabihf/c++/6.3.0 \
	-B$(XC_SYSROOT)/usr/lib/gcc/arm-linux-gnueabihf/6.3.0 \
	--gcc-toolchain=TOOLCHAIN/arm-linux-gnueabihf-binutils \

LOPTS=-L$(XC_SYSROOT)/usr/lib/gcc/arm-linux-gnueabihf/6.3.0

LDFLAGS=-Wl,--no-as-needed -L${XC_SYSROOT}/usr/local/lib \
    -L${XC_SYSROOT}/usr/xenomai/lib \
    -L${XC_SYSROOT}/root/Bela/lib \
    -lcobalt -lmodechk -lpthread -lrt\
    -lprussdrv -lstdc++ -lasound -lseasocks -lNE10 -lmathneon -ldl \
    -latomic \
    -lsndfile \
    -l:libbelafull.a\

SRCS := $(shell	find $(SRC_DIRS)	-name	*.cpp	-or	-name	*.c	-or	-name	*.s)
OBJS := $(SRCS:%.cpp=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)


CORE_OBJS := $(addprefix build/core/,)
ALL_DEPS += $(addprefix build/core/,$(notdir $(CORE_C_SRCS:.c=.d)))



$(TARGET_EXEC): $(OBJS)
	$(CLANG) $(OPTS) $(LOPTS) $(OBJS) -o $@ $(LDFLAGS)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(CLANG) $(OPTS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@ 

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CLANG) $(OPTS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CLANG) $(OPTS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	$(RM) -r $(BUILD_DIR) $(TARGET_EXEC)	

-include $(DEPS)

MKDIR_P := mkdir -p