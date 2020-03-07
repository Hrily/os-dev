FROM i386/alpine as build
WORKDIR /os-dev
RUN  apk add gcc nasm make
COPY . /os-dev/
RUN  make clean all
