FROM ubuntu:jammy AS builder

RUN apt-get update && apt-get install -y \
        make wget golang libarchive-tools zip patch \
        libargon2-dev libbz2-dev libcurl4-openssl-dev libkrb5-dev \
        liblzma-dev libmariadb-dev libpng-dev libreadline-dev \
        libsqlite3-dev libssl-dev libxml2-dev libz-dev \
        libzip-dev zlib1g zlib1g-dev libonig-dev

COPY ./php_8.1.4.diff .

RUN wget https://www.php.net/distributions/php-8.1.4.tar.gz -qO - | tar xzf - \
    && cd ./php-8.1.4/ \
    && patch -p1 < ../php_8.1.4.diff \
    && ./configure \
        --prefix=/php/ \
        --enable-dba \
        --enable-fpm \
        --enable-gd \
        --enable-mysqlnd \
        --enable-zts \
        --enable-mbstring \
        --with-password-argon2 \
        --with-bz2 \
        --with-curl \
        --with-kerberos \
        --with-mysqli=mysqlnd \
        --with-openssl \
        --with-pdo-mysql=mysqlnd \
        --with-pdo-sqlite \
        --with-readline \
        --enable-embed=static \
        --with-zip \
        --with-zlib \
    && sed -e 's/#define PHP_CAN_SUPPORT_PROC_OPEN 1//g' -i ./main/php_config.h \
    && sed -e 's/#define HAVE_FORK 1//g' -i ./main/php_config.h \
    && sed -e 's/#define HAVE_RFORK 1//g' -i ./main/php_config.h \
	&& make -j \
    && make install

COPY webserver .

RUN export CGO_CFLAGS_ALLOW=".*" \
    && export CGO_LDFLAGS_ALLOW=".*" \
    && go build -a



FROM enclaive/gramine-os:jammy-7e9d6925

RUN apt-get update &&\
    apt-get install -y bash curl libargon2-1 libonig5 libpng16-16 libprotobuf-c1 libxml2 libzip4 netcat-openbsd wget &&\
    rm -rf /var/lib/apt/lists/*

RUN  mkdir -p /app/wordpress/

COPY --from=builder /phphttpd /app/
COPY ./app.manifest.template /app/
COPY ./entrypoint.sh /app/
COPY ./php.ini /php/lib/
COPY ./index.php /app/wordpress

WORKDIR /app

RUN gramine-sgx-gen-private-key \
    && gramine-manifest -Dlog_level=error -Darch_libdir=/lib/x86_64-linux-gnu app.manifest.template app.manifest \
    && gramine-sgx-sign --manifest app.manifest --output app.manifest.sgx

EXPOSE 80 443
ENTRYPOINT ["/app/entrypoint.sh"]
