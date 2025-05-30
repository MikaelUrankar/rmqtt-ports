PORTNAME=	rmqtt
DISTVERSION=	0.12.1
MASTER_SITES=	https://github.com/rmqtt/rmqtt/releases/download/${DISTVERSION}/
CATEGORIES=	net

MAINTAINER=	mikael@FreeBSD.org
COMMENT=	Scalable Distributed MQTT Message Broker for IoT in the 5G Era
WWW=		https://github.com/rmqtt/rmqtt

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

LIB_DEPENDS=	libzstd.so:archivers/zstd

USES=		cargo dos2unix ssl tar:bz2

DOS2UNIX_FILES=	rmqtt.toml \
		rmqtt-plugins/rmqtt-acl.toml \
		rmqtt-plugins/rmqtt-auth-http.toml \
		rmqtt-plugins/rmqtt-cluster-broadcast.toml \
		rmqtt-plugins/rmqtt-cluster-raft.toml \
		rmqtt-plugins/rmqtt-web-hook.toml

USE_RC_SUBR=	${PORTNAME}

post-patch:
	@${REINPLACE_CMD} 's|ETCDIR|${ETCDIR}|' \
		${WRKSRC}/rmqtt.toml \
		${WRKSRC}/rmqtt/src/settings/mod.rs

do-install:
	${MKDIR} ${STAGEDIR}${ETCDIR} ${STAGEDIR}${ETCDIR}/rmqtt-plugins
	${INSTALL_DATA} ${WRKSRC}/rmqtt.toml ${STAGEDIR}${ETCDIR}/rmqtt.toml.sample

	cd ${WRKSRC}/rmqtt-plugins && ( \
		for f in `${FIND} . -depth 1 -name "*.toml"`; do \
			${CP} $$f ${STAGEDIR}${ETCDIR}/rmqtt-plugins/$$f.sample; \
		done; \
	)

	${INSTALL_PROGRAM} ${CARGO_TARGET_DIR}/${CARGO_BUILD_TARGET}/*/rmqttd ${STAGEDIR}${LOCALBASE}/bin

.include <bsd.port.mk>
