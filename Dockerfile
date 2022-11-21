ARG RUST_VERSION=1.64.0
FROM --platform=$BUILDPLATFORM rust:${RUST_VERSION}

RUN set -eux; \
    rustup target install x86_64-unknown-linux-gnu; \
    rustup target install aarch64-unknown-linux-gnu;

ENTRYPOINT [ "cargo", "lambda" ]

ARG ZIG_VERSION=0.9.1
RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    amd64) zigArch='x86_64';; \
    arm64) zigArch='aarch64';; \
    esac; \
    url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-${zigArch}-${ZIG_VERSION}.tar.xz"; \
    wget "$url"; \
    tar xf "zig-linux-${zigArch}-${ZIG_VERSION}.tar.xz"; \
    mv zig-linux-${zigArch}-${ZIG_VERSION} zig; \
    rm "zig-linux-${zigArch}-${ZIG_VERSION}.tar.xz";

ENV PATH=$PATH:/zig

ARG CARGO_LAMBDA_VERSION=v0.12.0
RUN set -eux; \
    mkdir cargo-lambda; \
    cd cargo-lambda; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    amd64) lambdaArch='x86_64-unknown-linux-musl';; \
    arm64) lambdaArch='aarch64-unknown-linux-musl';; \
    esac; \
    url="https://github.com/cargo-lambda/cargo-lambda/releases/download/${CARGO_LAMBDA_VERSION}/cargo-lambda-${CARGO_LAMBDA_VERSION}.${lambdaArch}.tar.gz"; \
    wget "$url"; \
    tar xf "cargo-lambda-${CARGO_LAMBDA_VERSION}.${lambdaArch}.tar.gz"; \
    rm "cargo-lambda-${CARGO_LAMBDA_VERSION}.${lambdaArch}.tar.gz";

ENV PATH=$PATH:/cargo-lambda
