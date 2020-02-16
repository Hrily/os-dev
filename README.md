# OS from Scratch

This project is my stab at the book [Writing a Simple Operating System from
Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)
by Nick Blunden.

## Usage

### Compile Boot Sector Assembly Code

```
nasm boot-sector.asm -f bin -o boot-sector.bin
```

### Start the Boot Sector

```
qemu boot-sector.bin
```
