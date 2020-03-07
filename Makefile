QEMU := qemu-system-i386

# Automatically generate lists of sources using wildcards .
C_SOURCES = $(wildcard ckernel/*.c drivers/*.c)
HEADERS = $(wildcard ckernel/*.h drivers/*.h)

# TODO: Make sources dep on all header files
# Convert the *.c filenames to *.o to give a list of object files to build
OBJ = ${C_SOURCES:.c=.o}

all: os-image

# Run qemu to simulate booting of our code .
run: build
	$(QEMU) os-image

# This is the actual disk image that the computer loads ,
# which is the combination of our compiled bootsector and kernel
os-image: boot-sector.bin ckernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel
ckernel.bin: ${OBJ}
	ld -o ckernel.bin -Ttext 0x1000 $^ --oformat binary

# Generic rule for compiling C code to an object file
# For simplicity, we C files depend on all header files
%.o: %.c ${HEADERS}
	gcc -fno-pie -ffreestanding -c $< -o $@

%.bin : %.asm
	nasm $< -f bin -o $@

# Clear away all generated files .
clean:
	rm -fr *.bin */*.bin *.dis *.o */*.o os-image *.map

# Disassemble our kernel, might be useful for debugging
ckernel.dis: ckernel.bin
	ndisasm -b 32 $< > $@

#
# Docker targets
#

build:
	docker build . -t os-image; \
	docker create --name os-image-container os-image; \
	docker cp os-image-container:/os-dev/os-image .; \
	docker rm os-image-container
