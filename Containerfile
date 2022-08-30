ARG ACMESH_VER=latest
FROM docker.io/neilpang/acme.sh:${ACMESH_VER}

COPY ./bootstrap.sh /bootstrap.sh

ENTRYPOINT ["/bin/sh", "/bootstrap.sh"]
