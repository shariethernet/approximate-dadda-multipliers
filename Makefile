TARGETS := 	s_dadda_8 \
			s_dadda_16 \
			s_app2_da_8_LFA \
			s_app2_da_8_LS \
			s_app2_da_8_MFA \
			s_app2_da_8_LSB \
			s_app3_da_8_LFA \
			s_app3_da_8_LS \
			s_app3_da_8_MFA\
			s_app3_da_8_LSB \
			s_app4_da_8_LFA \
			s_app4_da_8_LS \
			s_app4_da_8_MFA \
			s_app4_da_8_LSB \
			s_app2_da_16_LFA \
			s_app2_da_16_LS \
			s_app2_da_16_MFA \
			s_app2_da_16_LSB \
			s_app3_da_16_LFA \
			s_app3_da_16_LS \
			s_app3_da_16_MFA \
			s_app3_da_16_LSB \
			s_app4_da_16_LFA \
			s_app4_da_16_LS \
			s_app4_da_16_MFA \
			s_app4_da_16_LSB 

SELECTED_TARGETS := $(TARGETS)

all: $(TARGETS)
RUN_DIR := /home/local/nu/shg/systolic_tlv/runs/

$(SELECTED_TARGETS):
	fusesoc run --target=$@ --build-root=$(addprefix $(RUN_DIR),$(addprefix run_,$@)) mult

.PHONY: run

run:
	fusesoc run --target=$(CURRENT_TARGET) --build-root=$(addprefix $(RUN_DIR),$(addprefix run_,$(CURRENT_TARGET))) mult
