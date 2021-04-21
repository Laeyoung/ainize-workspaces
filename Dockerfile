# [Choice] Node.js version: 14, 12, 10
ARG VARIANT=12
FROM mcr.microsoft.com/vscode/devcontainers/typescript-node:${VARIANT}

#ARG VARIANT=3
#FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}


# Install Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN sudo apt-get update
RUN sudo apt -y --fix-broken install ./google-chrome-stable_current_amd64.deb

# Copy Browser Preview Extension settings
COPY vscode.settings.json /root/.local/share/code-server/User/settings.json

# Install VSCODE Server.
# install VS Code
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN code-server --install-extension ms-python.python --install-extension dbaeumer.vscode-eslint --install-extension auchenberg.vscode-browser-preview
EXPOSE 8010

WORKDIR /
#RUN wget https://github.com/tsl0922/ttyd/archive/refs/tags/1.6.2.zip
#RUN unzip 1.6.2.zip
#RUN cd ttyd-1.6.2 && mkdir build && cd build && cmake .. && make && sudo make install

COPY start.sh /scripts/start.sh
RUN ["chmod", "+x", "/scripts/start.sh"]

WORKDIR /workspace
ENV PASSWORD=''
ENTRYPOINT "/scripts/start.sh"
