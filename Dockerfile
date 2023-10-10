
# syntax=docker/dockerfile:1.6
FROM alpine:latest
LABEL org.opencontainers.image.source https://github.com/clingclangclick/pre-commit-docker-kustomize

RUN <<-EOF
    adduser kustomize -D
    apk --no-cache add curl git openssh
    git config --global url.ssh://git@github.com/.insteadOf https://github.com/
EOF

ARG KUSTOMIZE_DL_ARCH="${KUSTOMIZE_DL_ARCH:-amd64}"
ARG KUSTOMIZE_DL_VERSION="${KUSTOMIZE_DL_VERSION:-5.1.1}"
ARG KUSTOMIZE_DL_HASH="${KUSTOMIZE_DL_HASH:-3b30477a7ff4fb6547fa77d8117e66d995c2bdd526de0dafbf8b7bcb9556c85d}"
RUN <<-EOF
    curl -L --output /tmp/kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_DL_VERSION}/kustomize_v${KUSTOMIZE_DL_VERSION}_linux_amd64.tar.gz
    echo "${KUSTOMIZE_DL_HASH}  /tmp/kustomize.tar.gz" | sha256sum -c
    tar -xvzf /tmp/kustomize.tar.gz -C /usr/local/bin
    chmod +x /usr/local/bin/kustomize
    mkdir ~/.ssh
    ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
EOF

COPY kustomize_build_subdirs /usr/local/bin/kustomize_build_subdirs

ENV BASEDIR=/overlays
VOLUME [ "/overlays" ]

USER kustomize

WORKDIR /overlays

ENTRYPOINT [ "/usr/local/bin/kustomize_build_subdirs" ]

CMD ["overlays","4"]
