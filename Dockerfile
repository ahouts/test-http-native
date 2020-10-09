FROM alpine:20200917 AS alpine

RUN apk add libstdc++

FROM oracle/graalvm-ce:20.2.0-java11 AS graal-java

ENV RESULT_DIR=/libraries

# musl
RUN mkdir -p ${RESULT_DIR} && \
    yum install -y wget && \
    wget https://musl.libc.org/releases/musl-1.2.1.tar.gz && \
    tar -xzf musl-1.2.1.tar.gz
RUN cd musl-1.2.1 && \
    ./configure --disable-shared --prefix=${RESULT_DIR} && \
    make && \
    make install

ENV PATH=${RESULT_DIR}/bin:$PATH
ENV CC=musl-gcc

# zlib
RUN wget https://zlib.net/zlib-1.2.11.tar.gz && \
    tar -xzf zlib-1.2.11.tar.gz
RUN cd zlib-1.2.11 && \
    ./configure --static --prefix=${RESULT_DIR} && \
    make && \
    make install

COPY --from=alpine "/usr/lib/libstdc++.so.6" ${RESULT_DIR}/lib

RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo \
    -O /etc/yum.repos.d/epel-apache-maven.repo && \
    yum install -y apache-maven

ENV LD_LIBRARY_PATH=${RESULT_DIR}:$LD_LIBRARY_PATH

RUN gu install native-image
