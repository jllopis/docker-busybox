define BBDOCKERFILE
FROM scratch
ADD ${TARGETFS} /
CMD ["/bin/sh"]
endef

DOCKER=docker
ROOTFS=bbrootfs
TARGETFS=rootfs.tar
TMPDOCKERFILE=BBDockerfile
BUILDCTX=docker_context.tar.gz
REPOSITORY?=jllopis/busybox
TAG?=latest

busybox: ${BUILDCTX}
	@cd rootfs                                        ; \
	echo "Building docker busybox image from context" ; \
	${DOCKER} build -t ${REPOSITORY}:${TAG} - < ${BUILDCTX}

export BBDOCKERFILE
${BUILDCTX}: ${TARGETFS}
	@cd rootfs                               ; \
	echo "Building docker context"           ; \
	echo "$$BBDOCKERFILE" > ${TMPDOCKERFILE} ; \
	tar --transform='flags=r;s|${TMPDOCKERFILE}|Dockerfile|' -czf ${BUILDCTX} ${TARGETFS} ${TMPDOCKERFILE}

${TARGETFS}:
	@cd rootfs                                                              ; \
	echo "Building rootfs in `pwd`"                                         ; \
	${DOCKER} build -t ${ROOTFS} .                                          ; \
	${DOCKER} run --name tmprootfs ${ROOTFS} cat /${TARGETFS} > ${TARGETFS} ; \
	cp -uf ${TARGETFS} ../latest.${TARGETFS}

clean:
	@rm rootfs/${TARGETFS}      || true
	@rm rootfs/${BUILDCTX}      || true
	@rm rootfs/${TMPDOCKERFILE} || true
	${DOCKER} rm tmprootfs      || true
	${DOCKER} rmi ${ROOTFS}     || true
