# https://stackoverflow.com/questions/5950395/makefile-to-compile-multiple-c-programs

CC = gcc
CFLAGS = -Wall -g 

COMMON_OBJ = dns_message.o packedrr.o question.o resource_record.o rrfrag.o handler.o

DYNAMIC_OBJ = DYNAMIC.o
STATIC_OBJ = STATIC.o

all: arrf_dynamic arrf_static

arrf_dynamic: $(COMMON_OBJ) $(DYNAMIC_OBJ)
	$(CC) $(CFLAGS) -o arrf_dynamic $(COMMON_OBJ) $(DYNAMIC_OBJ) -lm

arrf_static: $(COMMON_OBJ) $(STATIC_OBJ)
	$(CC) $(CFLAGS) -o arrf_static $(COMMON_OBJ) $(STATIC_OBJ) -lm

dns_message.o: dns_message.c
	$(CC) $(CFLAGS) -c dns_message.c

packedrr.o: packedrr.c
	$(CC) $(CFLAGS) -c packedrr.c

question.o: question.c
	$(CC) $(CFLAGS) -c question.c

resource_record.o: resource_record.c
	$(CC) $(CFLAGS) -c resource_record.c

rrfrag.o: rrfrag.c
	$(CC) $(CFLAGS) -c rrfrag.c

handler.o: handler.c
	$(CC) $(CFLAGS) -c handler.c

DYNAMIC.o: DYNAMIC.c
	$(CC) $(CFLAGS) -c DYNAMIC.c

STATIC.o: STATIC.c
	$(CC) $(CFLAGS) -c STATIC.c

clean:
	rm -f *.o arrf_dynamic arrf_static
