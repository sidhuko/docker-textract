FROM debian:wheezy

# Set Noninteractive shell
ENV DEBIAN_FRONTEND noninteractive

# Node ENV Variables
ENV NODE_VERSION 4.2.1
ENV NODE_ENV production
ENV NPM_CONFIG_LOGLEVEL info

# Allow execution at install
RUN echo exit 101 > /usr/sbin/policy-rc.d && \
  # Setup timezone
  echo 'Europe/London' > /etc/timezone && dpkg-reconfigure tzdata && \
  # Server dependencies
  apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    openssh-client \
  # Project dependencies
    apt-utils \
    poppler-utils \ 
    catdoc \
    xpdf \
    tesseract-ocr \
  # Clean up
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  # Install Node keys
  && set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done \
  # Install Node and NPM
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc