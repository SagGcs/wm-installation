FROM almalinux:9.1

RUN dnf -y install emacs emacs-nox git subversion
RUN dnf -y install java-{1.8.0,11,17}-openjdk-{src,devel,javadoc}
RUN dnf -y install epel-release sudo wget
RUN useradd -c "Software AG Productrs" sag
RUN usermod -aG wheel sag
RUN mkdir -p /usr/local/install
COPY scripts /usr/local/install/scripts/
COPY licenses /usr/local/install/licenses/
WORKDIR /usr/local/install/scripts
RUN find /usr/local/install -print  &&  sh /usr/local/install/scripts/install.sh
CMD /bin/bash

