cwd := $(shell readlink -f .)
db  := $(shell echo $(PSQL_DB))

hamming_distance.so: hamming_distance.o
	cc -shared -o hamming_distance.so hamming_distance.o

hamming_distance.o: hamming_distance.c
	cc -I/usr/include/postgresql/9.0/server -fpic -c hamming_distance.c

install: hamming_distance.so
	psql $(db) -c \
            "create or replace function hamming_distance(bigint, bigint) returns int \
             as '$(cwd)/hamming_distance.so', 'hamming_distance' \
             LANGUAGE C STRICT"

