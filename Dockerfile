FROM  debian:stable-slim
LABEL maintainer="Job Diogenes<jobdiogenes@gmail.com>"
LABEL version="latest"

ENV   GRAAL_BASE=https://github.com/graalvm/graalvm-ce-builds/releases/latest
ENV   GRAAL_DIR=/usr/lib/jvm/graalvm

RUN   perl -pi.orig -0e 's/^(deb .*\n)# (deb-src)/$1$2/mg' /etc/apt/sources.list  && \
      apt-get update && \
      apt-get install -y curl wget tar gzip gcc libz-dev \
      build-essential gfortran libxml2-dev libc++-dev \
      libcurl4-gnutls-dev liblzma-dev liblzma5 liblz-dev \
      libbz2-dev libzip-dev libreadline-dev libgomp1 libssl-dev

WORKDIR /tmp

RUN   export GRAAL_VERSION=`curl -Ls -o /dev/null -w %{url_effective} $GRAAL_BASE | awk -F"[-]" '{print $NF}'`&&\
      export GRAAL_CE_URL="https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$GRAAL_VERSION/graalvm-ce-java11-linux-amd64-$GRAAL_VERSION.tar.gz" &&\
      curl -L $GRAAL_CE_URL -o graalvm-ce-linux-amd64.tar.gz && \
      mkdir -p /usr/lib/jvm/graalvm && \
      tar -xvzf graalvm-ce-linux-amd64.tar.gz --strip 1 -C /usr/lib/jvm/graalvm && \
      rm graalvm-ce-linux-amd64.tar.gz && \
      apt-get -y remove curl && \
      apt-get clean && \
      rm -rf /var/lib/lists/* &&\  
      { test ! -d /usr/lib/jvm/graalvm/src.zip || rm -rf /usr/lib/jvm/graalvm/src.zip; } 

ENV   JAVA_HOME=/usr/lib/jvm/graalvm
ENV   PATH=$PATH:$JAVA_HOME/bin
ENV   GRAALVM_HOME=/usr/lib/jvm/graalvm

RUN   gu install native-image && \
      gu install R && \
      yes | /usr/lib/jvm/graalvm/languages/R/bin/install_r_native_image && \
      R --vanilla -e "install.fastr.packages('data.table')" && \
      R --vanilla -e "install.fastr.packages('fastRCluster')" && \
      R --vanilla -e "install.fastr.packages('refcmp')" && \
      R --vanilla -e "install.fastr.packages('rJava')" 

RUN  rm -fr /tmp/*

CMD ["/bin/sh"]