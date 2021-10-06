FROM javiervarez/ate_builder:main

EXPOSE 10240

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y wget tar xz-utils \
    && wget https://nodejs.org/dist/v14.18.0/node-v14.18.0-linux-x64.tar.xz \
    && tar -xf node-v14.18.0-linux-x64.tar.xz \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/*

ENV PATH="/node-v14.18.0-linux-x64/bin:${PATH}"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y \
        curl \
        ca-certificates \
        nodejs \
        make \
        git \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/* \
    && git clone https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && npm i @sentry/node \
    && make webpack

ADD c++.properties /compiler-explorer/etc/config/c++.local.properties

WORKDIR /compiler-explorer

ENTRYPOINT [ "make", "run" ]
