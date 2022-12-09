FROM ubuntu:latest

COPY zsh-in-docker.sh /tmp/zsh-in-docker.sh
COPY download-vscode-server.sh /tmp/download-download-vscode-server.sh
SHELL ["/bin/bash", "-c"]

ENV PATH="/home/bhaveshdev/bin:${PATH}"
ENV PATH="/home/bhaveshdev/.local/bin:${PATH}"
ENV PATH="/home/bhaveshdev/.nix-profile/bin:${PATH}"
ENV TERM "xterm-256color"

RUN DEBIAN_FRONTEND=noninteractive apt -y update \ 
    && echo "------------------------------------------------------ Common" \
    && apt install -y sudo curl wget telnet jq dnsutils apt-utils\
         software-properties-common zip gzip tar \
    && echo "------------------------------------------------------ User" \
    && useradd -u 8877 bhaveshdev \
    && chown -R bhaveshdev /home \
    && mkdir -p /home/bhaveshdev \
    && chown -R bhaveshdev /home/bhaveshdev \
    && mkdir -p /home/bhaveshdev/apps \
    && chown -R bhaveshdev /home/bhaveshdev/apps \
    && echo "------------------------------------------------------ Nix folder and conf" \
    && mkdir -m 0750 /nix && chown bhaveshdev /nix \
    && echo "------------------------------------------------------ docker systemctl replacement" \
    && wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -O /usr/local/bin/systemctl  \
    && chown -R bhaveshdev /usr/local/bin/systemctl \ 
    && echo "------------------------------------------------------ Python" \
    && apt install -y python3-distutils python3-pip python-is-python3 \
    && echo "------------------------------------------------------ Allow users to install packages with apt" \
    && echo "# Allow non-admin users to install packages" >> /etc/sudoers \
    && echo "bhaveshdev ALL = NOPASSWD : /usr/bin/apt, /usr/bin/apt-get, /usr/bin/aptitude, /usr/bin/add-apt-repository, /usr/local/bin/pip, /usr/local/bin/systemctl, /usr/bin/dpkg, /usr/sbin/dpkg-reconfigure" >> /etc/sudoers \
    && chown bhaveshdev /etc/apt/sources.list.d \
    && chown bhaveshdev /etc/apt/trusted.gpg.d \
    && echo "------------------------------------------------------ GIT" \
    && apt install -y git \
    && echo "------------------------------------------------------ Cron" \
    && apt install -y cron \
    && chown -R bhaveshdev /var/spool/cron/crontabs \
    && chown -R bhaveshdev /var/log \
    && chmod gu+rw /var/run \
    && chmod gu+s /usr/sbin/cron \
    && echo "# Allow cron for user bhaveshdev" >> /etc/sudoers \
    && echo "bhaveshdev ALL = NOPASSWD : /usr/sbin/cron " >> /etc/sudoers \
    && echo "------------------------------------------------------ ZSH root" \
    && HOME=/root \
    && chmod +x /tmp/zsh-in-docker.sh \
    && /tmp/zsh-in-docker.sh \
    -t https://github.com/pascaldevink/spaceship-zsh-theme \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -a 'export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"' \
    -a 'SPACESHIP_USER_SHOW="false"' \
    -a 'SPACESHIP_TIME_SHOW="true"' \
    -a 'SPACESHIP_TIME_COLOR="grey"' \
    -a 'SPACESHIP_DIR_COLOR="cyan"' \
    -a 'SPACESHIP_GIT_SYMBOL="⇡"' \
    -a 'SPACESHIP_BATTERY_SHOW="false"' \
    -a 'if [[ $(pwd) != /root  ]]; then cd /root; fi  # Set starting dir to /root ' \
    -a 'hash -d r=/root' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search' \
    -p https://github.com/bobthecow/git-flow-completion \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down' \
    && printf '%s\n%s\n' "export ZSH_DISABLE_COMPFIX=true" "$(cat /root/.zshrc)" > /root/.zshrc \
    && echo "------------------------------------------------------ ZSH bhaveshdev" \
    && HOME=/home/bhaveshdev \
    && /tmp/zsh-in-docker.sh \
    -t https://github.com/pascaldevink/spaceship-zsh-theme \
    -a 'DISABLE_UPDATE_PROMPT="true"' \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -a 'export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"' \
    -a 'SPACESHIP_USER_SHOW="true"' \
    -a 'SPACESHIP_TIME_SHOW="true"' \
    -a 'SPACESHIP_TIME_COLOR="grey"' \
    -a 'SPACESHIP_DIR_COLOR="cyan"' \
    -a 'SPACESHIP_GIT_SYMBOL="⇡"' \
    -a 'SPACESHIP_BATTERY_SHOW="false"' \
    -p git \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    -p https://github.com/zsh-users/zsh-history-substring-search \
    -p https://github.com/zsh-users/zsh-syntax-highlighting \
    -p 'history-substring-search' \
    -p https://github.com/bobthecow/git-flow-completion \
    -a 'bindkey "\$terminfo[kcuu1]" history-substring-search-up' \
    -a 'bindkey "\$terminfo[kcud1]" history-substring-search-down' \
    && rm /tmp/zsh-in-docker.sh \
    && printf '%s\n%s\n' "export ZSH_DISABLE_COMPFIX=true" "$(cat /home/bhaveshdev/.zshrc)" > /home/bhaveshdev/.zshrc \
    && echo "------------------------------------------------------ Code editors" \
    && apt install -y nano vim \
    && apt install -y tilde \
    && echo "------------------------------------------------------ Sys monitoring: Glances, Vizex" \
    && apt install -y ncdu htop \
    && echo "------------------------------------------------------ User" \
    && mkdir -p /home/bhaveshdev/bin \ 
    && chown bhaveshdev /home/bhaveshdev/bin \
    && mkdir -p /home/bhaveshdev/.local/bin \ 
    && chown bhaveshdev /home/bhaveshdev/.local && chown bhaveshdev /home/bhaveshdev/.local/bin \
    && chown bhaveshdev /home/bhaveshdev/.local && chown bhaveshdev /home/bhaveshdev/.local/bin  \
    && find /home -type d | xargs -I{} chown -R bhaveshdev {} \
    && find /home -type f | xargs -I{} chown bhaveshdev {} \
    && echo "------------------------------------------------------ Aliases" \
    && echo 'alias python="python3"' >> /root/.zshrc \
    && echo 'alias python="python3"' >> /home/bhaveshdev/.zshrc \
    && echo 'alias pm2="cd /home/bhaveshdev/apps/node && . env/bin/activate && pm2"' >> /home/bhaveshdev/.zshrc \
    && echo 'alias lg="lazygit"' >> /home/bhaveshdev/.zshrc \
    && echo "------------------------------------------------------ Clean" \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && apt-get -y autoclean \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/.git \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/.github \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/custom/plugins/git-flow-completion/.git \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/custom/plugins/zsh-autosuggestions/.git \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/custom/plugins/zsh-completions/.git \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/custom/plugins/zsh-history-substring-search/.git \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/.git \
    && rm -rf /home/bhaveshdev/.oh-my-zsh/custom/themes/spaceship-zsh-theme/.git 



RUN echo "------------------------------------------------------ Docker" \
    && apt install -y apt-transport-https ca-certificates gnupg lsb-release \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN chmod +x /tmp/download-download-vscode-server.sh 
USER bhaveshdev

    # && echo "------------------------------------------------------ Nix" \
    # && curl -L https://nixos.org/nix/install > /tmp/nix.sh \
    # && chmod +x /tmp/nix.sh \
    # && sh /tmp/nix.sh --no-daemon  \
    # && rm /tmp/nix.sh \

ENV SHELL '/bin/zsh'
RUN git config --global credential.helper cache \
    && pip install --upgrade pip \
    && pip install --upgrade setuptools \
    && pip install --upgrade distlib \
    && pip install glances \
    && curl -fsSL https://fnm.vercel.app/install | bash


# Download VS Code Server tarball to tmp directory.
# Make the parent directory where the server should live.
# NOTE: Ensure VS Code will have read/write access; namely the user running VScode or container user.
# Extract the tarball to the right location.
RUN /tmp/download-download-vscode-server.sh


###### ENTRY

# note! this will have consequences only when started as root (docker run ... --user root ...)  
# systemctl start systemd-journald 
#   I remove this from entrypoint, as it is not used significantly, but slows down the start

# this entrypoint should be the same for all images that are built on top of this one
ENTRYPOINT /bin/zsh
