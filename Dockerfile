FROM i386/alpine as build
WORKDIR /os-dev
COPY . /os-dev/
RUN  apk add gcc nasm
RUN  gcc -fno-pie -ffreestanding -c /os-dev/ckernel/main.c -o /os-dev/ckernel/kernel.o
RUN  ld -o /os-dev/ckernel/kernel.bin -Ttext 0x1000 /os-dev/ckernel/kernel.o --oformat binary
RUN  nasm /os-dev/boot-sector.asm -f bin -o /os-dev/boot_sector.bin
RUN  cat /os-dev/boot_sector.bin /os-dev/ckernel/kernel.bin > /os-dev/os-image
