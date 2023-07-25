# webMethods automated installation

This project provides a set of scripts, that may be used to perform an automated installation of the webMethods suite, or another Software AG product, that may be installed by using the so-called **Software AG Installer**.

Basically, installation works like this:

1. Clone this repository to your local hard drive.
2. Go top the directory src/main/Installation.
3. Create a small property file (settings-local.sh), typically by copying a sample file (settings-local-sample.sh).
4. Edit the above property file, entering values like your [Empower](https://empower.softwareag.com/) credentials, the installation directory, the requested product version, locations of the necessary license files, etc.
5. Run the installation script. The script will perform, among others, the following steps:
    - Create a working directory, where files can be cached.
    - Download the Software AG Installer to the working directory.
    - Run the Software AG Installer to build an image file by downloading the product files from [Empower](https://empower.softwareag.com/).
    - Run the Software AG Installer to perform the actual installation by using the above image file.

The procedure is carefully designed to work with a *Dockerfile*, when setting up a *WSL* instance, a virtual, or typical machine, as long as you are using Red Hat Enterprise Linux, CentOS, AlmaLinux, Rocky Linux, or any
compatible operating system. (In the case of Docker, WSL, or a VM, that would be the guest operating system, not the hosts.)
