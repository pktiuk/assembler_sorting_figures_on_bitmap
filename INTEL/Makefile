
CC = g++
CFLAGS = -Wall -m64 -g

all: main.o
	$(CC) $(CFLAGS) -o fun main.o f.o 
	
main.o: main.cpp
	$(CC) $(CFLAGS) -c -o main.o main.cpp

f.o: f.s
	nasm -f elf64 -o f.o f.s

clean:
	rm -f *.o
