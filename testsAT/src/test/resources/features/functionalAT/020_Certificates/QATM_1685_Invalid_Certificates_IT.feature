@rest
Feature: Marathon-lb not able to run without valid certificates in Vault

  Scenario: [01] Delete valid marathon-lb certificate in vcli
    Given I open a ssh connection to '${BOOTSTRAP_IP}' with user 'root' and password 'stratio'
    When I run 'grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
    Then I outbound copy 'src/test/resources/scripts/marathon-lb-invalid-certs.sh' through a ssh connection to '/tmp'
    And I run 'cp /stratio_volume/certs.list certs_custom_app_marathonlb.list' in the ssh connection
    And I run 'cd /tmp && sudo chmod +x marathon-lb-invalid-certs.sh' in the ssh connection
    And I run 'sudo mv /tmp/marathon-lb-invalid-certs.sh /stratio_volume/marathon-lb-invalid-certs.sh' in the ssh connection
    And I run 'docker ps | grep eos-installer | awk '{print $1}'' in the ssh connection and save the value in environment variable 'containerId'
    And I run 'sudo docker exec -t !{containerId} /stratio_volume/marathon-lb-invalid-certs.sh' in the ssh connection

  @include(feature:../010_Installation/010_installation.feature,scenario:[Install Marathon-lb][01])

  Scenario: Prepare configuration to install Marathon-lb
    Then I wait '5' seconds

  Scenario: [03] Install using config file and cli
    #Copy DEPLOY JSON to DCOS-CLI
    Given I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
    When I outbound copy 'target/test-classes/config.${MARATHON_LB_VERSION:-0.3.1}.json' through a ssh connection to '/tmp/'
    And I run 'dcos package install --yes --package-version=${MARATHON_LB_VERSION:-0.3.1} --options=/tmp/config.${MARATHON_LB_VERSION:-0.3.1}.json ${PACKAGE_MARATHON_LB:-marathon-lb-sec}' in the ssh connection
    Then the command output contains 'Marathon-lb DC/OS Service has been successfully installed!'
    And I run 'rm -f /tmp/config.${MARATHON_LB_VERSION:-0.3.1}.json' in the ssh connection
    And I wait '45' seconds
#    Marathon-lb-sec is not installed because certificates are incorrect
    And in less than '300' seconds, checking each '20' seconds, the command output 'dcos task | grep -w ${SERVICE:-marathonlb}. | wc -l' contains '0'

  Scenario: Restore Certificates for Marathon-lb-sec
    Given I open a ssh connection to '${BOOTSTRAP_IP}' with user 'root' and password 'stratio'
    When I run 'grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
    Then I outbound copy 'src/test/resources/scripts/marathon-lb-restore-certs.sh' through a ssh connection to '/tmp'
    And I run 'cp /stratio_volume/certs.list certs_custom_app_marathonlb.list' in the ssh connection
    And I run 'cd /tmp && sudo chmod +x marathon-lb-restore-certs.sh' in the ssh connection
    And I run 'sudo mv /tmp/marathon-lb-restore-certs.sh /stratio_volume/marathon-lb-restore-certs.sh' in the ssh connection
    And I run 'docker ps | grep eos-installer | awk '{print $1}'' in the ssh connection and save the value in environment variable 'containerId'
    And I run 'sudo docker exec -t !{containerId} /stratio_volume/marathon-lb-restore-certs.sh' in the ssh connection

    #Uninstalling marathon-lb-sec
  @include(feature:../099_Uninstall/purge.feature,scenario:marathon-lb-sec can be uninstalled using cli)

  Scenario: Uninstall marathon-lb-sec
    Then I wait '5' seconds
