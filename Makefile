include MakefileTop.in

TARGET_EXEC := ./build/$(PROJECT)
SYSROOT := ./sysroot
BUILD_DIR := ./build
PROJECT_SRC := ./Bela/projects/$(PROJECT)
BATK_SRC := ./sysroot/root/Bela/libraries/Batk ./sysroot/root/Bela/libraries/midifile

PROJECT_SRCS := $(shell	find $(PROJECT_SRC)	-name	*.cpp	-or	-name	*.c	-or	-name	*.s) ./Bela/Core/default_main.cpp
PROJECT_OBJS := $(PROJECT_SRCS:%.cpp=$(BUILD_DIR)/%.o)
PROJECT_DEPS := $(PROJECT_OBJS:.o=.d)

BATK_SRCS := $(shell find $(BATK_SRC)	-name	*.cpp	-or	-name	*.c	-or	-name	*.s)
BATK_OBJS := $(BATK_SRCS:%.cpp=$(BUILD_DIR)/%.o)
BATK_DEPS := $(BATK_OBJS:.o=.d)

OBJS := $(PROJECT_OBJS) $(BATK_OBJS)
DEPS := $(PROJECT_DEPS) $(BATK_DEPS)

# application
$(TARGET_EXEC): $(OBJS)
	@$(CLANG) $(OPTS) $(LOPTS) $(OBJS) -o $@ $(LDFLAGS)
	@echo Building: $(notdir $@)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	@$(MKDIR_P) $(dir $@)
	@$(CLANG) $(OPTS) $(CPPFLAGS) -Wall -c -fmessage-length=0 -U_FORTIFY_SOURCE -MMD -MP -MF"$(@:%.o=%.d)" $< -o $@
	@echo Building: $(notdir $@)

# c source
$(BUILD_DIR)/%.c.o: %.c
	@$(MKDIR_P) $(dir $@)
	@$(CLANG) $(OPTS) $(CPPFLAGS) -Wall -c -fmessage-length=0 -U_FORTIFY_SOURCE -MMD -MP -MF"$(@:%.o=%.d)" $< -o $@
	@echo Building: $(notdir $@)

# c++ source
$(BUILD_DIR)/%.o: %.cpp
	@$(MKDIR_P) $(dir $@)
	@$(CLANG) $(OPTS) $(CPPFLAGS) -Wall -c -fmessage-length=0 -U_FORTIFY_SOURCE -MMD -MP -MF"$(@:%.o=%.d)" $< -o $@
	@echo Building: $(notdir $@)

.PHONY: clean cleanall

clean:
	$(RM) -r $(BUILD_DIR)/Bela/projects/$(PROJECT)

cleanall:
	$(RM) -r $(BUILD_DIR)	

-include $(DEPS)

MKDIR_P := mkdir -p