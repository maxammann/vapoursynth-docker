FROM archlinux:latest

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm

# Update and install base development tools and required packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        git \
        sudo \
        python \
        python-pip \
        vapoursynth \
        ffmpeg && \
    pacman -Scc --noconfirm

# Create a non-root user (required for yay and makepkg)
RUN useradd -m builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER builder
WORKDIR /home/builder

# Install yay (AUR helper)
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf yay


RUN yay -S --noconfirm vapoursynth-plugin-adjust
RUN yay -S --noconfirm vapoursynth-plugin-misc
RUN yay -S --noconfirm vapoursynth-plugin-mvtools
RUN yay -S --noconfirm ffms2


WORKDIR /home/builder

# Clone AUR PKGBUILD
RUN git clone https://aur.archlinux.org/vapoursynth-plugin-vsjetpack-git.git

WORKDIR /home/builder/vapoursynth-plugin-vsjetpack-git

# Replace source in PKGBUILD via sed (example hash shown)
RUN sed -i 's|^source=.*|source=("vsjetpack::git+https://github.com/Jaded-Encoding-Thaumaturgy/vs-jetpack.git#commit=6a88b9a59d67051afbb02d556117e6eaf20bc147")|' PKGBUILD && \
    sed -i '/^pkgver()/,/^}/c\pkgver() {\n  echo "r0.6a88b9a59d67051afbb02d556117e6eaf20bc147"\n}' PKGBUILD

# Build and install
RUN yay -S --noconfirm \
    python-jetpytools \
    vapoursynth-plugin-vsakarin \
    vapoursynth-plugin-resize2 \
    python-rich \
    python-typing_extensions \
    python-scipy
RUN makepkg -si --noconfirm


RUN yay -S --noconfirm vapoursynth-plugin-havsfunc-git
RUN yay -S --noconfirm vapoursynth-plugin-znedi3-git
RUN yay -S --noconfirm vapoursynth-plugin-eedi3m-git 
RUN yay -S --noconfirm vapoursynth-plugin-bestsource

USER root


RUN pip uninstall -y --break-system-packages jetpytools
RUN pip install --break-system-packages --force jetpytools==1.4.0 




# Clean up cache
RUN rm -rf /home/builder/.cache && \
    rm -rf /var/cache/pacman/pkg/*

# Default working directory
WORKDIR /workspace
RUN mkdir -p /workspace

CMD ["bash"]

