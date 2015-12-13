FROM gliderlabs/alpine:3.2
ENV GOPATH /go
ENV GOBIN /usr/local/bin
RUN apk-install go git mercurial
RUN apk add --update bash
ADD . /go/src/github.com/miketheprogrammer/go-thrust
RUN cd /go/src/github.com/miketheprogrammer/go-thrust \
  && go get -v \
  && go get -v github.com/nsf/bin2go \
  && go get -v github.com/gorilla/websocket \
  && go get -v github.com/tv42/birpc \
  && go get -v github.com/tv42/topic
WORKDIR /go/src/github.com/miketheprogrammer/go-thrust/examples/chat/server
CMD echo $PATH && ./run_server
