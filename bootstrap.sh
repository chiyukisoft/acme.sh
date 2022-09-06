#!/bin/sh

# check env variable
if [[ -z "${ACME_SH_EMAIL}" ]]; then
    echo "env variable ACME_SH_EMAIL is missing."
    exit
fi

if [[ -z "${DOMAIN_NAME}" ]]; then
    echo "env variable DOMAIN_NAME is missing."
    exit
fi

if [[ -z "${ACME_SH_DEFAULT_CA}" ]]; then
    echo "env variable ACME_SH_DEFAULT_CA is missing. using letsencrypt ca."
    ACME_SH_DEFAULT_CA=letsencrypt
fi

ACME_SH_EMAIL=${ACME_SH_EMAIL:-default value}

if [ ! -f /acme.sh/account.conf ]; then
    echo "acme.sh is not initialized yet, run bootstrap steps now."
    echo "set default ca..."
    acme.sh --set-default-ca --server ${ACME_SH_DEFAULT_CA}
    echo "set email account..."
    acme.sh --register-account -m ${ACME_SH_EMAIL}
    echo "init request cert for ${DOMAIN_NAME} ..."

    if [ "${ACME_SH_WILDCARD}" = true ]; then
        acme.sh --issue \
        -d "${DOMAIN_NAME}" -d "*.${DOMAIN_NAME}" \
        --dns "${DNS_API}"
    else
        acme.sh --issue \
        -d "${DOMAIN_NAME}" \
        --dns "${DNS_API}"
    fi
else
    echo "acme.sh is already configured."
fi

echo "start acme.sh daemon"
# start acme.sh daemon
/entry.sh daemon
