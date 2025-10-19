FROM mcr.microsoft.com/devcontainers/java:8-bookworm

# Install additional tools
RUN apt-get update && apt-get install -y \
    maven \
    git \
    curl \
    vim \
    postgresql-client \
    jq \
    zip \
    unzip

# Install Node.js 12 using direct binary download for legacy compatibility
RUN curl -fsSL https://nodejs.org/download/release/v12.22.12/node-v12.22.12-linux-x64.tar.gz | tar -xz -C /tmp && \
    mv /tmp/node-v12.22.12-linux-x64 /usr/local/node && \
    ln -sf /usr/local/node/bin/node /usr/local/bin/node && \
    ln -sf /usr/local/node/bin/npm /usr/local/bin/npm && \
    ln -sf /usr/local/node/bin/npx /usr/local/bin/npx && \
    node --version && npm --version

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Environment variables
ENV JAVA_HOME=/usr/local/sdkman/candidates/java/8.0.462-tem
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin

# Development ports
EXPOSE 8080 3000 5432 35729

# Working directory
WORKDIR /workspace
