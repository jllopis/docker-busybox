# This Dockerfile is a modified version from
# https://github.com/jpetazzo/docker-busybox/blob/master/tarmaker-buildroot/Dockerfile
# modified to include libc and libssl
FROM ubuntu:10.04
# This will make it easier to upgrade to the next version of buildroot.
# You might have to also update the busybox version at the end of this file!
ENV BUILDROOT_VERSION 2014.05
# This will get rid of a build warning related to 'tput'.
ENV TERM dumb
RUN locale-gen es_ES.UTF-8
ENV LANG es_ES.UTF-8
ENV LC_ALL es_ES.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q
RUN apt-get install -qy wget build-essential libncurses-dev rsync unzip bc bzip2
# Buildroot needs Python. Let's git it!
RUN which python || ln /usr/bin/python3 /usr/bin/python
# Let's make wget output a bit less verbose.
RUN echo progress = dot:mega > /.wgetrc
RUN wget http://buildroot.uclibc.org/downloads/buildroot-$BUILDROOT_VERSION.tar.bz2
# Check that we got the right tarball (update this when upgrading buildroot!)
RUN echo "19d81668e20676d87a3f3a762022b104  buildroot-$BUILDROOT_VERSION.tar.bz2" > buildroot.md5
RUN md5sum --check buildroot.md5
RUN tar -jxf buildroot-$BUILDROOT_VERSION.tar.bz2
# This symlink is because WORKDIR doesn't expand $VARS.
RUN ln -s buildroot-$BUILDROOT_VERSION buildroot
WORKDIR /buildroot
RUN make defconfig
RUN sed -i "s/BR2_i386=y/# BR2_i386 is not set/" .config
RUN sed -i "s/BR2_TOOLCHAIN_BUILDROOT_UCLIBC=y/# BR2_TOOLCHAIN_BUILDROOT_UCLIBC is not set/" .config
RUN sed -i "s/BR2_GCC_TARGET_TUNE=\"i686\"/BR2_GCC_TARGET_TUNE=\"generic\"/" .config
RUN sed -i "s/BR2_x86_i686=y/BR2_x86_generic=y/" .config
RUN sed -i "s/BR2_TOOLCHAIN_USES_UCLIBC=y/BR2_TOOLCHAIN_USES_GLIBC=y/" .config
RUN sed -i "s/BR2_TOOLCHAIN_BUILDROOT_LIBC=\"uclibc\"/BR2_TOOLCHAIN_BUILDROOT_LIBC=\"glibc\"/" .config
RUN for CFGVAR in \
    "# uClibc Options" \
    "# BR2_UCLIBC_VERSION_0_9_32 is not set" \
    "BR2_UCLIBC_VERSION_0_9_33=y" \
    "# BR2_UCLIBC_VERSION_SNAPSHOT is not set" \
    "BR2_UCLIBC_VERSION_STRING=\"0.9.33.2\"" \
    "BR2_UCLIBC_CONFIG=\"package\/uclibc\/uClibc-0.9.33.config\"" \
    "# BR2_TOOLCHAIN_BUILDROOT_LARGEFILE is not set" \
    "# BR2_TOOLCHAIN_BUILDROOT_INET_IPV6 is not set" \
    "# BR2_TOOLCHAIN_BUILDROOT_INET_RPC is not set" \
    "# BR2_TOOLCHAIN_BUILDROOT_WCHAR is not set" \
    "# BR2_TOOLCHAIN_BUILDROOT_LOCALE is not set" \
    "# BR2_PTHREADS_NONE is not set" \
    "# BR2_PTHREADS is not set" \
    "# BR2_PTHREADS_OLD is not set" \
    "BR2_PTHREADS_NATIVE=y" \
    "# BR2_PTHREAD_DEBUG is not set" \
    "# BR2_TOOLCHAIN_BUILDROOT_USE_SSP is not set" \
    "BR2_UCLIBC_INSTALL_UTILS=y" \
    "# BR2_UCLIBC_INSTALL_TEST_SUITE is not set" \
    "BR2_UCLIBC_TARGET_ARCH=\"i386\"" \
    "BR2_UCLIBC_X86_TYPE=\"686\"" \
    ; do sed -i "/$CFGVAR/d" .config ; done

RUN for CFGVAR in \
    "BR2_LARGEFILE=y" \
    "BR2_INET_IPV6=y" \
    "BR2_TOOLCHAIN_HAS_NATIVE_RPC=y" \
    "BR2_USE_WCHAR=y" \
    "BR2_ENABLE_LOCALE=y" \
    ; do sed -i "184i$CFGVAR" .config ; done

RUN for CFGVAR in \
    BR2_x86_64 \
    BR2_TOOLCHAIN_BUILDROOT_GLIBC \
    BR2_PACKAGE_BRIDGE_UTILS \
    BR2_PACKAGE_IPROUTE2 \
    BR2_PACKAGE_IPTABLES \
    BR2_PACKAGE_ZLIB \
    BR2_PACKAGE_OPENSSL \
    ; do sed -i "s/# $CFGVAR is not set/$CFGVAR=y/" .config ; done
RUN for CFGVAR in \
    CONFIG_NC \
    CONFIG_NC_SERVER \
    CONFIG_NC_EXTRA \
    CONFIG_BRCTL \
    CONFIG_FEATURE_BRCTL_FANCY \
    CONFIG_FEATURE_BRCTL_SHOW \
    ; do sed -i "s/# $CFGVAR is not set/$CFGVAR=y/" package/busybox/busybox-1.22.x.config ; done
RUN make olddefconfig
RUN make
RUN ln -s /buildroot/output/images/rootfs.tar /rootfs.tar

