FROM i386/alpine as build
WORKDIR /os-dev
COPY . /os-dev/
RUN  apk add gcc nasm make
RUN  make clean all
