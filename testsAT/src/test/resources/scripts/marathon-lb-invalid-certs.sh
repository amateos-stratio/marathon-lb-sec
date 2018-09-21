#!/bin/bash

set -e # Exit in case of any error

err_report() {
    echo "$2 -> Error on line $1 with $3"
}
trap 'err_report $LINENO ${BASH_SOURCE[$i]} ${BASH_COMMAND}' ERR

VAULT_TOKEN=$(grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//')
INTERNAL_DOMAIN=$(grep -Po '"internalDomain":\s"(\d*?,|.*?[^\\]")' /stratio_volume/descriptor.json | awk -F":" '{print $2}' | sed -e 's/^\s"//' -e 's/"$//')
CONSUL_DATACENTER=$(grep -Po '"consulDatacenter":\s"(\d*?,|.*?[^\\]")' /stratio_volume/descriptor.json | awk -F":" '{print $2}' | sed -e 's/^\s"//' -e 's/"$//')

curl -k -s -GET -H "X-Vault-Token:${VAULT_TOKEN}" "https://vault.service.${INTERNAL_DOMAIN}:8200/v1/userland/certificates/marathon-lb" | jq .data > /stratio_volume/marathon-lb-cert-backup.json

curl -k -s -XDELETE -H "X-Vault-Token:${VAULT_TOKEN}" "https://vault.service.${INTERNAL_DOMAIN}:8200/v1/userland/certificates/marathon-lb"