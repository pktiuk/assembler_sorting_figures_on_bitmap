
CC = g++
CFLAGS = -Wall -m64 -g

all: main.o f.o
	$(CC) $(CFLAGS) -o sort_figures main.o f.o  -lglut -lGLU -lGL
	
main.o: main.cpp
	$(CC) $(CFLAGS) -c -o main.o main.cpp

f.o: f.s
	nasm -f elf64 -o f.o f.s

clean:
	rm -f *.o
