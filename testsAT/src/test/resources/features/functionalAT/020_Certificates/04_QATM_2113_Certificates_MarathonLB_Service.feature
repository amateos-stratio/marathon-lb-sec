@rest
Feature: [QATM-2113] Vault Renewal Token

  Scenario:[01] Check Vault path by default
    Given I open a ssh connection to '${BOOTSTRAP_IP}' with user '${REMOTE_USER:-operador}' using pem file 'src/test/resources/credentials/${PEM_FILE:-key.pem}'
    When I run 'grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
    And I run 'curl -X GET -fskL --tlsv1.2 -H "X-Vault-Token:!{vaultToken}" "https://${VAULT_HOST}:${VAULT_PORT:-8200}/v1/${VAULT_USERLAND_CERTIFICATE_BASE_PATH:-userland/certificates/}marathon-lb" | jq '.data."marathon-lb_crt"'' locally
    And I run 'curl -X GET -fskL --tlsv1.2 -H "X-Vault-Token:!{vaultToken}" "https://${VAULT_HOST}:${VAULT_PORT:-8200}/v1/${VAULT_USERLAND_CERTIFICATE_BASE_PATH:-userland/certificates/}marathon-lb" | jq '.data."marathon-lb_key"'' locally

#  Scenario:[02] Check Vault path by service name
#    Given I open a ssh connection to '${BOOTSTRAP_IP}' with user '${REMOTE_USER:-operador}' using pem file 'src/test/resources/credentials/${PEM_FILE:-key.pem}'
#    When I run 'grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
#    And I run 'curl -X GET -fskL --tlsv1.2 -H "X-Vault-Token:!{vaultToken}" "https://${VAULT_HOST}:${VAULT_PORT}/v1/${VAULT_USERLAND_CERTIFICATE_BASE_PATH:-userland/certificates/}${SERVICE:-marathonlb}" | jq '.data."marathon-lb_crt"'' locally
#    And I run 'curl -X GET -fskL --tlsv1.2 -H "X-Vault-Token:!{vaultToken}" "https://${VAULT_HOST}:${VAULT_PORT}/v1/${VAULT_USERLAND_CERTIFICATE_BASE_PATH:-userland/certificates/}${SERVICE:-marathonlb}" | jq '.data."marathon-lb_key"'' locally



