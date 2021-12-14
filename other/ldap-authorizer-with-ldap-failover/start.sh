#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/../../scripts/utils.sh

${DIR}/../../environment/ldap-authorizer-sasl-plain/start.sh "${PWD}/docker-compose.ldap-authorizer-sasl-plain.ldap-failover.yml"

# docker exec --privileged --user root -i broker yum install bind-utils

# nslookup -type=SRV _ldap._tcp.example.com
# Server:         127.0.0.11
# Address:        127.0.0.11#53

# _ldap._tcp.example.com  service = 10 50 389 ldap2.example.com.
# _ldap._tcp.example.com  service = 10 50 389 ldap.example.com.
# _ldap._tcp.example.com  service = 20 75 389 ldap3.example.com.


# [2021-12-14 17:20:39,198] ERROR LDAP search failed, search will be retried. Groups from the last successful search will continue to be applied until the configured retry timeout or the next successful search. (io.confluent.security.auth.provider.ldap.LdapGroupManager)
# io.confluent.security.auth.provider.ldap.LdapException: LDAP context could not be created with provided configs
#         at io.confluent.security.auth.provider.ldap.LdapContextCreator.lambda$createLdapContext$0(LdapContextCreator.java:82)
#         at java.base/java.security.AccessController.doPrivileged(Native Method)
#         at java.base/javax.security.auth.Subject.doAs(Subject.java:361)
#         at io.confluent.security.auth.provider.ldap.LdapContextCreator.createLdapContext(LdapContextCreator.java:78)
#         at io.confluent.security.auth.provider.ldap.LdapGroupManager.searchAndProcessResults(LdapGroupManager.java:347)
#         at io.confluent.security.auth.provider.ldap.LdapGroupManager.start(LdapGroupManager.java:185)
#         at io.confluent.security.auth.provider.ldap.LdapGroupProvider.configure(LdapGroupProvider.java:32)
#         at io.confluent.security.authorizer.ConfluentAuthorizerConfig.lambda$createProviders$2(ConfluentAuthorizerConfig.java:167)
#         at java.base/java.lang.Iterable.forEach(Iterable.java:75)
#         at io.confluent.security.authorizer.ConfluentAuthorizerConfig.createProviders(ConfluentAuthorizerConfig.java:167)
#         at io.confluent.security.authorizer.EmbeddedAuthorizer.configureServerInfo(EmbeddedAuthorizer.java:96)
#         at io.confluent.kafka.security.authorizer.ConfluentServerAuthorizer.configureServerInfo(ConfluentServerAuthorizer.java:85)
#         at io.confluent.kafka.security.authorizer.ConfluentServerAuthorizer.start(ConfluentServerAuthorizer.java:148)
#         at kafka.server.KafkaServer.startup(KafkaServer.scala:553)
#         at kafka.Kafka$.main(Kafka.scala:108)
#         at kafka.Kafka.main(Kafka.scala)
# Caused by: javax.naming.CommunicationException: example.com:389 [Root exception is java.net.UnknownHostException: example.com]
#         at java.naming/com.sun.jndi.ldap.Connection.<init>(Connection.java:252)
#         at java.naming/com.sun.jndi.ldap.LdapClient.<init>(LdapClient.java:137)
#         at java.naming/com.sun.jndi.ldap.LdapClient.getInstance(LdapClient.java:1616)
#         at java.naming/com.sun.jndi.ldap.LdapCtx.connect(LdapCtx.java:2847)
#         at java.naming/com.sun.jndi.ldap.LdapCtx.<init>(LdapCtx.java:348)
#         at java.naming/com.sun.jndi.ldap.LdapCtxFactory.getLdapCtxFromUrl(LdapCtxFactory.java:262)
#         at java.naming/com.sun.jndi.ldap.LdapCtxFactory.getUsingURL(LdapCtxFactory.java:226)
#         at java.naming/com.sun.jndi.ldap.LdapCtxFactory.getUsingURLs(LdapCtxFactory.java:280)
#         at java.naming/com.sun.jndi.ldap.LdapCtxFactory.getLdapCtxInstance(LdapCtxFactory.java:185)
#         at java.naming/com.sun.jndi.ldap.LdapCtxFactory.getInitialContext(LdapCtxFactory.java:115)
#         at java.naming/javax.naming.spi.NamingManager.getInitialContext(NamingManager.java:730)
#         at java.naming/javax.naming.InitialContext.getDefaultInitCtx(InitialContext.java:305)
#         at java.naming/javax.naming.InitialContext.init(InitialContext.java:236)
#         at java.naming/javax.naming.ldap.InitialLdapContext.<init>(InitialLdapContext.java:154)
#         at io.confluent.security.auth.provider.ldap.LdapContextCreator.lambda$createLdapContext$0(LdapContextCreator.java:80)
#         ... 15 more
# Caused by: java.net.UnknownHostException: example.com