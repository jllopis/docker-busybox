Busybox Docker Image
====================

This image is based upon the one from _Jérôme Petazzoni_ than can be found
at https://github.com/jpetazzo/docker-busybox

I needed an image with **glibc** and **libssl** to be able to run [Mosquitto MQTT Brocker](http://www.eclipse.org/proposals/technology.mosquitto/).

# Version

- **busybox**   v1.22.1
- **buildroot** v2014.05
- **glibc**     v2.18
- **openssl**   v1.0.1g

# Build from repository

(https://github.com/jllopis/docker-busybox)

    $ git clone git@github.com:jllopis/docker-busybox.git
    $ cd docker-busybox
    $ sudo make

The repository contains a **Makefile** that can build the image from scratch.

Possible *make* targets:

- **clean** : delete all files and docker images and containers. Use with caution.
              If you want to build from scratch, you have to clean first so the
              build context be rebuild.
- **rootfs.tar** : this targe build the base filesystem using **buildroot**. It can
                   take a long time to finish but its needed if you want a pristine image.
- **busybox** : same as call withouth arguments. Build the busybox image.

**NOTE**: This Makefile is tested in _Ubuntu 14.04_. It should work in other environments. Under ubuntu you must
run make with sudo; otherwise it will error when trying to call **docker**.

# Run

The image use _"/bin/sh"_ as **CMD** so you can start it as

    $ sudo docker run -ti jllopis/busybox

Anyway, this container goal is to run servers that need **glibc** and **openssl** so its intended
to be used as the **FROM** image for other images.

For other uses the original default **busybox** image from **jpetazzo** can be a better choice.

