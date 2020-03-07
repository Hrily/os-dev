# OS from Scratch

This project is my stab at the book [Writing a Simple Operating System from
Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)
by Nick Blunden.

## Usage

### Build

You can build the image using:

```
make all
```

In case you want to use docker for build (if you are not on linux)

```
make build
```

### Run

Run the image using qemu
```
qemu-system-i386 os-image
```
