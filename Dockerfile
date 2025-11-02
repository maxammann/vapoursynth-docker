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
#RUN sed -i 's|^source=.*|source=("vsjetpack::git+https://github.com/Jaded-Encoding-Thaumaturgy/vs-jetpack.git#commit=6a88b9a59d67051afbb02d556117e6eaf20bc147")|' PKGBUILD && \
#    sed -i '/^pkgver()/,/^}/c\pkgver() {\n  echo "r0.6a88b9a59d67051afbb02d556117e6eaf20bc147"\n}' PKGBUILD

# Build and install
RUN yay -S --noconfirm \
    python-jetpytools \
    vapoursynth-plugin-vsakarin \
    vapoursynth-plugin-resize2 \
    python-rich \
    python-typing_extensions \
    python-scipy
RUN makepkg -si --noconfirm


#RUN yay -S --noconfirm vapoursynth-plugin-havsfunc-git
RUN yay -S --noconfirm vapoursynth-plugin-znedi3-git
RUN yay -S --noconfirm vapoursynth-plugin-eedi3m-git 
RUN yay -S --noconfirm vapoursynth-plugin-bestsource
#RUN yay -S --noconfirm cuda
RUN yay -S --noconfirm wget


RUN wget https://archive.archlinux.org/packages/c/cuda/cuda-12.9.1-2-x86_64.pkg.tar.zst     && sudo pacman -U --noconfirm  cuda-12.9.1-2-x86_64.pkg.tar.zst     


RUN source /etc/profile.d/cuda.sh && yay -S --noconfirm vapoursynth-plugin-dfttest2-git
RUN source /etc/profile.d/cuda.sh && yay -S --noconfirm vapoursynth-plugin-eedi2cuda-git 
RUN yay -S --noconfirm vapoursynth-plugin-eedi2-git 
RUN yay -S --noconfirm vapoursynth-plugin-bwdif-git 
RUN yay -S --noconfirm vapoursynth-plugin-eedi3m-git
#RUN yay -S --noconfirm vapoursynth-plugin-nnedi3-git 


RUN yay -S --noconfirm ffms2
USER root


RUN mkdir -p /workspace
WORKDIR /workspace
RUN wget https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-SNEEDIF/archive/refs/tags/R3.tar.gz
RUN tar -xvf R3.tar.gz
RUN cd vapoursynth-SNEEDIF-R3 && meson setup builddir --buildtype release && meson compile -C builddir
RUN cp vapoursynth-SNEEDIF-R3/builddir/libsneedif.so /usr/lib/vapoursynth/






RUN echo "/lib64" > /etc/ld.so.conf.d/lib64.conf



ENV CUDA_PATH=/opt/cuda
ENV NVCC_CCBIN='/usr/bin/g++'
ENV PATH="$PATH:/opt/cuda/bin"
#ENV LD_LIBRARY_PATH="/opt/cuda/lib"

#RUN pip uninstall -y --break-system-packages jetpytools
#RUN pip install --break-system-packages --force jetpytools==1.4.0 




# Clean up cache
RUN rm -rf /home/builder/.cache && \
    rm -rf /var/cache/pacman/pkg/*

# Default working directory
WORKDIR /workspace
RUN mkdir -p /workspace

CMD ["bash"]

