UNAME := $(shell uname)
OS := $(OS)
PACKAGES := "-package process"
REMOVE_CMD = rm

ifeq ($(OS),Windows_NT)
    OS_FLAGS = -DWINDOWS
    NOTIFY_CMD = echo "Windows notification stub"
	REMOVE_CMD = del
else ifeq ($(UNAME), Darwin)
    OS_FLAGS = -DMAC
    NOTIFY_CMD = osascript -e 'display notification "Test" with title "ToDo"'
else ifeq ($(UNAME), Linux)
    OS_FLAGS = -DLINUX
    NOTIFY_CMD = notify-send "ToDo" "Test"
else
    OS_FLAGS =
    NOTIFY_CMD = echo "Nieznany system"
endif

todo: Main.hs lab/Notify.hs
	ghc -cpp -ilab $(OS_FLAGS) $(PACKAGES) -o build/todo Main.hs

run:
	./build/todo

notify:
	$(NOTIFY_CMD)

clean:
	$(REMOVE_CMD) *.o *.hi lab/*.o lab/*.hi