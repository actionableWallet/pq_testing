# Dynamic ARRF

The repo consists of the code used in our testing. The original `copy_section` algorithm is within `static.c` and our dynamic solution is within `dynamic.c`. In order to run your own experiment via our script use `./benchmark.sh`. These results are reflected in the paper.

There exists a `Makefile` which compiles to two different executables - one executable (`arrf_static`) is the original implementation and the other (`arrf_dynamic`) is our modifications to `copy_section`. Within `handler.c` is the code which generates the input to `copy_section` and obtains the timings within `send_packets`

# Instructions
**number-of-fragments** - Choose the number of fragments which are sized at 1232 bytes. For example 100 fragments will contribute to 123200 bytes of data.

**attack** - Conducts a memory exhaustion attack which is possible on the original function by acting as an on-path adversary and forcing the program to allocate an excessive amount of memory.

**no** - Does not conduct memory exhaustion attack.
### Building
1. Run the `Makefile` via `make`
2. Choose whether to run `./arrf_static <number-of-fragments> <attack|no attack>` or `./arrf_dynamic <number-of-fragments> <attack|no attack>`. 
3. The output is from `handler.c` which produces the timings of the `copy_section` function in milliseconds.

### Example
1. If you want to test the dynamic variant with 1000 fragments and do not want to conduct an attack we run `./arrf_dynamic 1000 no`.

2. If you want to test the static variant with 250 fragments and want to conduct the attack we run `./arrf_static 250 attack`.

### Scripts

`attack.sh` runs a basic memory exhaustion attack using 250, 500, 1000, 1250 fragments. It will print a message "Successful memory exhaustion attack!" if a program fails. Otherwise it will print "Memory exhaustion attack bypassed".

`benchmark.sh` runs the timings of the `copy_section` function. It prints mean, standard deviation and standard error values. On line 15, one can increase the number of experiments run. The output is written within `results.txt`.



