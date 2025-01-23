ARG TAG=26.0.0
FROM harbor.csde.caci.com/registry1.dso.mil/ironbank/opensource/keycloak/keycloak:${TAG}-patched

LABEL version=${TAG}
LABEL decription="Keycloak image that has been patched using copacetic"
LABEL patched-by-copacetic="true"

# USER root

# RUN dnf update -y && \
#     dnf upgrade -y

USER keycloak

ENTRYPOINT [ "/opt/keycloak/bin/kc.sh" ]