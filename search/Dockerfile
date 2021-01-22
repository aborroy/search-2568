ARG SEARCH_TAG
FROM quay.io/alfresco/search-services:${SEARCH_TAG}
# FROM searchservices:develop

# COMMON
ARG ALFRESCO_HOSTNAME
ARG SOLR_HOSTNAME
ENV ALFRESCO_HOSTNAME $ALFRESCO_HOSTNAME
ENV SOLR_HOSTNAME $SOLR_HOSTNAME

# Configure Alfresco Service Name
RUN sed -i '/^bash.*/i sed -i "'"s/alfresco.host=localhost/alfresco.host=${ALFRESCO_HOSTNAME}/g"'" ${DIST_DIR}/solrhome/templates/rerank/conf/solrcore.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh && \
    sed -i '/^bash.*/i sed -i "'"s/solr.host=localhost/solr.host=${SOLR_HOSTNAME}/g"'" ${DIST_DIR}/solrhome/conf/shared.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh

# Disable content indexing
RUN sed -i '/^bash.*/i echo "alfresco.ignore.datatype.1=d:content" >> ${DIST_DIR}/solrhome/conf/shared.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh && \
    sed -i '/^bash.*/i echo "alfresco.index.transformContent=false" >> ${DIST_DIR}/solrhome/conf/shared.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh && \
    sed -i '/^bash.*/i sed -i "'"s/#alfresco.content.tracker.cron=/alfresco.content.tracker.cron=0 0 0 1 1 ? 2200/g"'" ${DIST_DIR}/solrhome/templates/rerank/conf/solrcore.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh

# Decrease Thread Pool Size for Cascade Tracker
RUN sed -i '/^bash.*/i sed -i "'"s/#alfresco.cascade.tracker.maxParallelism=32/alfresco.cascade.tracker.maxParallelism=8/g"'" ${DIST_DIR}/solrhome/templates/rerank/conf/solrcore.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh

# Skip initial transactions
RUN sed -i '/^bash.*/i sed -i "'"s/#solr.initial.transaction.id=/solr.initial.transaction.id=4250000/g"'" ${DIST_DIR}/solrhome/templates/rerank/conf/solrcore.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh

# Configure SOLR cores to run in HTTP mode from template
RUN sed -i '/^bash.*/i sed -i "'"s/alfresco.secureComms=https/alfresco.secureComms=none/g"'" ${DIST_DIR}/solrhome/templates/rerank/conf/solrcore.properties\n' \
    ${DIST_DIR}/solr/bin/search_config_setup.sh

# Set the search log level if requested.
ARG SEARCH_LOG_LEVEL
ENV SEARCH_LOG_LEVEL $SEARCH_LOG_LEVEL
RUN if [ "$SEARCH_LOG_LEVEL" ] ; then \
  sed -i '/^bash.*/i sed -i "'"s/log4j.rootLogger=WARN, file, CONSOLE/log4j.rootLogger=${SEARCH_LOG_LEVEL}, file, CONSOLE/g"'" ${DIST_DIR}/logs/log4j.properties\n' \
  ${DIST_DIR}/solr/bin/search_config_setup.sh; \
fi
