FROM alpine:3.17.3 as base

LABEL version="0.0.1"
LABEL repository="https://github.com/nomadops/artifactory-action"
LABEL homepage="https://github.com/nomadops/artifactory-action"
LABEL maintainer="nomadops"
LABEL "com.github.actions.name"="Artifactory CLI Action"
LABEL "com.github.actions.description"="Run jFrog Artifactory CLI commands"
LABEL "com.github.actions.icon"="check"
LABEL "com.github.actions.color"="green"

RUN apk add curl
RUN apk add nodejs npm
RUN apk add --no-cache git make musl-dev go

# Required for gp commands
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

RUN curl -fL https://install-cli.jfrog.io | sh
FROM base as build
COPY "entrypoint.sh" "/entrypoint.sh"
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
