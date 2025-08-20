# Use official Jenkins agent base image
FROM jenkins/inbound-agent:latest

# Switch to root to install dependencies
USER root

# Install essential tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        curl \
        unzip \
        bash \
        gnupg \
        software-properties-common \
        openssh-client && \
    # Force /bin/sh to point to bash for better compatibility
    ln -sf /bin/bash /bin/sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt update && \
    apt install -y gh && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Diagnostics (optional)
RUN bash -c "echo ✅ Shell: \$(which sh); bash --version" && \
    git --version && \
    gh --version

# Switch back to Jenkins user
USER jenkins
