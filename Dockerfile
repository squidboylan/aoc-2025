# Use a minimal base image
FROM debian:bookworm-slim

# Install dependencies for Zig and Git for GitHub Actions
RUN apt-get update && apt-get install -y \
    wget \
    xz-utils \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Define Zig version and checksum
ENV ZIG_VERSION=0.15.2
ENV ZIG_SHA256=02aa270f183da276e5b5920b1dac44a63f1a49e55050ebde3aecc9eb82f93239

# Download and install Zig with checksum verification
RUN wget -q "https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz" \
    && echo "${ZIG_SHA256}  zig-x86_64-linux-${ZIG_VERSION}.tar.xz" | sha256sum -c - \
    && tar -xf "zig-x86_64-linux-${ZIG_VERSION}.tar.xz" \
    && mv "zig-x86_64-linux-${ZIG_VERSION}" /usr/local/zig \
    && ln -s /usr/local/zig/zig /usr/local/bin/zig \
    && rm "zig-x86_64-linux-${ZIG_VERSION}.tar.xz"

# Verify installation
RUN zig version

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
