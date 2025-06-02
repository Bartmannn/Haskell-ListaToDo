UNAME := $(shell uname)
OS := $(OS)
REMOVE_CMD = rm -f
GHC_OPTS = -i:src -i:tests

# windows może być do poprawy!
ifeq ($(OS),Windows_NT)
    EXEC = build\\todo.exe
    CLEAN_CMD = powershell -Command "Get-ChildItem -Recurse -Include *.o,*.hi,*.exe | Remove-Item -Force"
else
    EXEC = ./build/todo
    CLEAN_CMD = \
        find . -name "*.o" -type f -delete && \
        find . -name "*.hi" -type f -delete && \
        rm -f build/todo NUL || true
endif


.PHONY: all run test clean

all: build/todo

build/todo: app/Main.hs
	@mkdir -p build
	ghc $(GHC_OPTS) -package time -package HUnit -o build/todo app/Main.hs

run: build/todo
	$(EXEC)

test: tests/TestMain.hs
	ghc $(GHC_OPTS) -package time -package HUnit -o build/tests tests/TestMain.hs
	./build/tests

clean:
	@$(CLEAN_CMD)
