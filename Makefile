QEMU := qemu-system-i386

all: os-image

# Run qemu to simulate booting of our code .
run: build
	$(QEMU) os-image

# This is the actual disk image that the computer loads ,
# which is the combination of our compiled bootsector and kernel
os-image: boot-sector.bin ckernel/kernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel
ckernel/kernel.bin: ckernel/kernel.o
	ld -o ckernel/kernel.bin -Ttext 0x1000 $^ --oformat binary

# Build our kernel object file
ckernel/kernel.o: ckernel/kernel.c
	gcc -fno-pie -ffreestanding -c $< -o $@

# Assemble the boot sector to raw machine code
# The -I options tells nasm where to find our useful assembly
# routines that we include in boot-sector.asm
boot-sector.bin: boot-sector.asm
	nasm $< -f bin -o $@

# Clear away all generated files .
clean:
	rm -fr *.bin */*.bin *.dis *.o */*.o os-image *.map

# Disassemble our kernel, might be useful for debugging
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

#
# Docker targets
#

build:
	docker create --name os-image-container os-image; \
	docker cp os-image-container:/os-dev/os-image .; \
	docker rm os-image-container
