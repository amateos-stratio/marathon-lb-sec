@rest
Feature: [QATM-2113] Vault Renewal Token

  Scenario:[01] Check marathon-lb logs
    Given I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.labs.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
    And I run 'dcos task | grep marathon.*lb.* | tail -1 | awk '{print $5}'' in the ssh connection and save the value in environment variable 'TaskID'
    When in less than '300' seconds, checking each '10' seconds, the command output 'dcos task log --lines 10 !{TaskID} 2>/dev/null' contains 'INFO - 0 python marathon-lb.token_renewal.py {"@message": "Checking if token needs renewal"}'

  Scenario:[02] Change token period and check renewal
    Given I open a ssh connection to '${BOOTSTRAP_IP}' with user '${REMOTE_USER:-operador}' using pem file 'src/test/resources/credentials/${PEM_FILE:-key.pem}'
    When I run 'grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
    When I run 'sudo docker exec -it paas-bootstrap curl -k -H "X-Vault-Token:!{vaultToken}" https://${VAULT_HOST}:${VAULT_PORT:-8200}/v1/auth/approle/role/open -k -XPOST -d '{"period": 60}' | jq .' in the ssh connection
    And I wait '5' seconds
    Then in less than '300' seconds, checking each '10' seconds, the command output 'sudo docker exec -it paas-bootstrap curl -k -s -XGET -H 'X-Vault-Token:!{vaultToken}' https://${VAULT_HOST}:${VAULT_PORT:-8200}/v1/auth/approle/role/open | jq -rMc .data.period' contains '60'
    When I run 'sudo docker exec -it paas-bootstrap curl -k -H "X-Vault-Token:!{vaultToken}" https://${VAULT_HOST}:${VAULT_PORT:-8200}/v1/auth/approle/role/open -k -XPOST -d '{"period": 600}' | jq .' in the ssh connection
    And I wait '5' seconds
    Then in less than '300' seconds, checking each '10' seconds, the command output 'sudo docker exec -it paas-bootstrap curl -k -s -XGET -H 'X-Vault-Token:!{vaultToken}' https://${VAULT_HOST}:${VAULT_PORT:-8200}/v1/auth/approle/role/open | jq -rMc .data.period' contains '600'

  Scenario:[01] Check marathon-lb logs
    Given I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.labs.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
    And I run 'dcos task | grep marathon.*lb.* | tail -1 | awk '{print $5}'' in the ssh connection and save the value in environment variable 'TaskID'
    When in less than '300' seconds, checking each '10' seconds, the command output 'dcos task log --lines 10 !{TaskID} 2>/dev/null' contains 'INFO - 0 python marathon-lb.token_renewal.py {"@message": "Checking if token needs renewal"}'
