TARGETS := 	

SELECTED_TARGETS := $(TARGETS)

all: $(TARGETS)
RUN_DIR := /home/local/nu/shg/systolic_tlv

$(SELECTED_TARGETS):
	fusesoc run --target=$@ --build-root=$(addprefix $(RUN_DIR),$(addprefix run_,$@)) openhw:cv32e40p:core:0.1

.PHONY: run

run:
	fusesoc run --target=$(CURRENT_TARGET) --build-root=$(addprefix $(RUN_DIR),$(addprefix run_,$(CURRENT_TARGET))) openhw:cv32e40p:core:0.1
