ARG TAG=26.0.0
FROM harbor.csde.caci.com/registry1.dso.mil/ironbank/opensource/keycloak/keycloak:${TAG}-patched

LABEL version=${TAG}
LABEL decription="Keycloak image that has been patched using copacetic"
LABEL com.devopsbase.base.image="registry1.dso.mil/ironbank/opensource/keycloak/keycloak"
LABEL com.devopsbase.base.tag=${TAG}

RUN dnf 

RUN mvn dependency:purge-local-repository && \
    mvn clean install -DskipTests