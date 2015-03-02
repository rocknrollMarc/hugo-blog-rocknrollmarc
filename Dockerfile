FROM ubuntu:trusty
MAINTAINER rocknrollmarc

  RUN apt-get update && apt-get install -y nginx && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get install -y && apt-get install --no-install-recommends -y -q curl \
    build-essential ca-certificates git mercurial bzr
RUN mkdir /goroot && curl \
    https://storage.googleapis.com/go1.3.1.linux-amd64.tar.gz | tar xvzf - -C /go \
    root --strip-components=1
RUN mkdir /gopath

ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN go get -v github.com/spf13/hugo
RUN go install github.com/spf13/hugo

ONBUILD ADD . /site-source
ONBUILD RUN cd /site-source && hugo

ONBUILD RUN cp -R /site-source/public /app/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD sites-enabled/ /etc/nginx/sites-enabled/

EXPOSE 80

CMD ["/usr/sbin/nginx"]
