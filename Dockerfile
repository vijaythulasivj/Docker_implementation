# Use a basic Ubuntu base image for local testing
FROM ubuntu:22.04

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        unzip \
        ca-certificates \
        openssh-client \
        bash \
        gnupg \
        software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && \
    apt install -y gh && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Optional: Install Java (if needed)
RUN apt-get update && apt-get install -y openjdk-17-jdk

# Default command
CMD ["/bin/bash"]
