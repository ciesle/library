CC = g++
CFLAGS_OPT = -std=c++20 -O2 -g
CFLAGS_DBG = -std=c++20 -O0 -g
OUT_DIR = ./.vscode/auto_build

LIBRARIES:=$(shell find ./library/ -type f)
SNIP_PATH=./.vscode/cpp.json.code-snippets
ADD_SH=../library/add.sh

$(OUT_DIR)/main: main.cpp
	$(CC) $(CFLAGS_OPT) -o $@ $^ 
$(OUT_DIR)/brute: brute.cpp
	$(CC) $(CFLAGS_OPT) -o $@ $^
$(OUT_DIR)/gen: gen.cpp
	$(CC) $(CFLAGS_OPT) -o $@ $^
$(OUT_DIR)/main_dbg: main.cpp
	$(CC) $(CFLAGS_DBG) -o $@ $^ 

main: $(OUT_DIR)/main
	@rm -f ./$@
	@cp $^ ./
brute: $(OUT_DIR)/brute
	@rm -f ./$@
	@cp $^ ./
gen: $(OUT_DIR)/gen
	@rm -f ./$@
	@cp $^ ./
main_dbg: $(OUT_DIR)/main_dbg
	@rm -f ./$@
	@cp $^ ./

.PHONY: clean
clean:
	@rm -f main brute gen main_dbg a.out test rnd*

.PHONY: gdb_clean
gdb_clean:
	@ls peda-session* && rm peda-session* || :
	@if [ -e .gdb_history ]; then rm gdb_history; fi

.PHONY: snippet
snippet:
	@printf "{\n\t\n}" > $(SNIP_PATH)
	@$(foreach file,$(LIBRARIES),$(ADD_SH) $(file);)
	@sed -i -e :a -e '$$d;N;2,2ba' -e 'P;D' $(SNIP_PATH)
	@echo "\t}\n}" >> $(SNIP_PATH)