FROM gliderlabs/alpine:3.2
ENV GOPATH /go
RUN apk-install go git mercurial
ADD . /go/src/github.com/miketheprogrammer/hello-go
RUN cd /go/src/github.com/miketheprogrammer/hello-go \
  && go get -v
WORKDIR /go/src/github.com/miketheprogrammer/hello-go
CMD /usr/bin/go run ./main.go
