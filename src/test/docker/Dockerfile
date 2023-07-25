FROM almalinux:9.2

RUN dnf -y install emacs emacs-nox git subversion
RUN dnf -y install java-{1.8.0,11,17}-openjdk-{src,devel,javadoc}
RUN dnf -y install epel-release sudo wget
RUN useradd -c "Software AG Productrs" sag
RUN usermod -aG wheel sag
RUN mkdir -p /usr/local/install
RUN git clone https://github.com/SagGcs/wm-installation.git
WORKDIR /usr/local/install/wm-installation/src/main/Installation
CMD /bin/bash

