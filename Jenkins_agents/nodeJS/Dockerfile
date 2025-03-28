FROM jenkins/inbound-agent
USER root
RUN apt update && apt install curl -y
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
RUN \. "$HOME/.nvm/nvm.sh" && nvm install 22 && node -v