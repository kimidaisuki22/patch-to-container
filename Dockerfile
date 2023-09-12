FROM debian AS Base

RUN apt-get -y update
RUN apt-get -y install patchelf

WORKDIR /fix
ADD No_name-0.1.1-Linux.tar.gz .
WORKDIR /fix/No_name-0.1.1-Linux/bin

RUN cp main cold-main

RUN patchelf --set-rpath . main
RUN patchelf --set-interpreter ./ld-linux-x86-64.so.2 main

RUN chmod +x *
RUN ./main


FROM alpine
# FROM debian
WORKDIR /dest
COPY --from=Base /fix/No_name-0.1.1-Linux/bin .

# This line fix problem on alpine: alpine doesn't have libm.so.5 in /lib
# But I already have it in /dest, why?
RUN cp libm.so.6 /lib/