# Use an official Jenkins agent base image with Java and basic tools
FROM jenkins/inbound-agent:latest

# Install tools as root
USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        openssh-client \
        curl \
        unzip \
        bash \
        gnupg \
        software-properties-common \
    && apt-get clean && \
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

# Switch back to the Jenkins user
USER jenkins

# (Optional) Verify installs
RUN git --version && java -version && gh --version
