include MakefileTop.in

TARGET_EXEC := ./build/$(PROJECT)
BUILD_DIR := ./build
PROJECT_SRC := ./src/projects/$(PROJECT)
LIBRARIES_SRC := ./src/libraries/*

PROJECT_SRCS := $(shell	find $(PROJECT_SRC)	-name	*.cpp	-or	-name	*.c	-or	-name	*.s) ./Bela/Core/default_main.cpp
PROJECT_OBJS := $(PROJECT_SRCS:%.cpp=$(BUILD_DIR)/%.o)

LIBRARIES_SRCS := $(shell find $(LIBRARIES_SRC)	-name	*.cpp	-or	-name	*.c	-or	-name	*.s)
LIB_OBJS := $(LIBRARIES_SRCS:%.cpp=$(BUILD_DIR)/%.o)

OBJS := $(PROJECT_OBJS) $(LIB_OBJS)

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

MKDIR_P := mkdir -p