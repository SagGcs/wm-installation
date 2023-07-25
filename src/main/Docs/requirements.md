# Requirements

As of this writing (July 2023), the following requirements have to be met for using the wm-installation scripts:


1.) The target platform needs to be running
    [Red Hat Enterprise Linux](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux), or a
    compatible operating system, like [CentOS](https://www.centos.org/), [AlmaLinux](https://almalinux.org/),
    [Rocky Linux](https://rockylinux.org/), or the like. The scripts have been developed on versions 8.x, and 9.x,
    so they are supposed to work fine on those.
    
   Of course, the target platform is supposed to be certified by Software AG for the installed products,
    and the respective product version (See the [official matrix](https://documentation.softwareag.com/system_platform_requirements/)
    for details on that.
    
   Note, that this is supposed to specifically include creating Docker images, or setting up WSL instances,
    assuming that they use a suitable base image. In the case of Docker, that means, that your *Dockerfile* would start with
    something like `FROM almalinux/almalinux:9.2`. In the case of WSL, this can be dony by simply using
    **OracleLinux_9_1** as the base image.
   
   In fact, these use cases have been one of the primary drivers for creating the project.
    
2.) For setting up, and running the installation scripts, the following programs should be installed
    on the target platform before starting: **git**, **wget**, **Java 11 SDK** (or any later version).

   If necessary, you can install these easily by running `sudo install git wget java-11-openjdk-devel`.

3.) A dedicated operating system user must be available for running the installer scripts (and, later on, the installed
    products. In what follows, we'll assume, that this user has the id **sag**, and refer to it as the *sag user*.
    For the installation process, that user needs sudo permissions. (It's fine, to take them away after the
    installation has been completed.)

   If not already done, that user can be created by running the following commands:

```bash
   sudo /usr/sbin/useradd -c "Software AG Products"
```
    