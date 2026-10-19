FROM archlinux:latest

ARG USERNAME=dotfiles
ARG USER_UID=1000
ARG USER_GID=1000

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PNPM_HOME=/home/${USERNAME}/.local/share/pnpm \
    PATH=/home/${USERNAME}/.local/share/pnpm/bin:/home/${USERNAME}/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin

RUN pacman -Sy --noconfirm reflector \
    && reflector \
    --latest 20 \
    --protocol https \
    --sort rate \
    --save /etc/pacman.d/mirrorlist \
    && pacman -Syu --noconfirm --needed \
    base-devel \
    aria2 \
    ccache \
    curl \
    git \
    make \
    mold \
    rustup \
    sudo \
    && pacman -Scc --noconfirm
RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" --create-home --shell /usr/bin/bash "${USERNAME}" \
    && printf '%s ALL=(ALL) NOPASSWD: ALL\n' "${USERNAME}" > /etc/sudoers.d/"${USERNAME}" \
    && chmod 0440 /etc/sudoers.d/"${USERNAME}"

WORKDIR /workspace
COPY --chown=${USERNAME}:${USERNAME} . /workspace
USER ${USERNAME}

RUN git config --global --add safe.directory /workspace \
    && rm -f "/home/${USERNAME}/.bashrc" "/home/${USERNAME}/.bash_profile" "/home/${USERNAME}/.bash_logout" \
    && PACMAN_DISABLE_SANDBOX=1 make -C home/.scripts/installation system-config \
    && make -C home/.scripts/installation prerequisites submodules rust paru packages flatpak haskell stow pnpm hooks \
    && if git -C /workspace rev-parse --is-inside-work-tree >/dev/null 2>&1; then pre-commit run --all-files; else echo '[SKIP] pre-commit run skipped (no .git in /workspace).'; fi

CMD ["bash"]
