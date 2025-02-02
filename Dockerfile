ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/redhat/openjdk/openjdk21-devel
ARG BASE_TAG=1.21

FROM quay.io/keycloak/keycloak:26.1.0 as upstream

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

USER root

RUN microdnf upgrade -y && \
    microdnf clean all && \
    rm -rf /var/cache/yum && \
    # We have to add the FIPS provider to make SAML work: https://www.keycloak.org/server/fips
    echo "fips.provider.7=XMLDSig" >> /usr/lib/jvm/java/conf/security/java.security && \
    # User stuff
    echo "keycloak:x:2000:root" >> /etc/group && \
    echo "keycloak:x:2000:2000:keycloak user:/opt/keycloak:/sbin/nologin" >> /etc/passwd

COPY --from=upstream --chown=2000:2000 /opt/keycloak /opt/keycloak

# Prevent CCE-84038-9 and CCE-85888-6
RUN chmod -R 0750 /opt/keycloak

USER keycloak

EXPOSE 8080 8443