@rest

Feature: [QATM-2113] Download certificates only of new deployed apps - Invalid certs for nginx-qa
#Installing marathon-lb-sec with Nginx certificate
  @runOnEnv(INSTALL_MARATHON=true)
  @include(feature:../010_Installation/010_installation.feature,scenario:[Install Marathon-lb][01])
  @include(feature:../010_Installation/010_installation.feature,scenario:[Install Marathon-lb][02] Install using config file and cli)
  @include(feature:../010_Installation/010_installation.feature,scenario:[Install Marathon][03][01] Check Marathon-lb has being installed correctly)
  @include(feature:../010_Installation/010_installation.feature,scenario:[Install Marathon][03][02] Obtain node where marathon-lb-sec is running)
  @include(feature:../010_Installation/010_installation.feature,scenario:[Install Marathon][03][03] Make sure service is ready)
  Scenario: [MARATHONLB-1386] Install marathon-lb
    Then I wait '5' seconds

  @skipOnEnv(INSTALL_MARATHON=true)
  @include(feature:../010_Installation/010_installation.feature,scenario:[Install Marathon][03][02] Obtain node where marathon-lb-sec is running)
  Scenario: [MARATHONLB-1386] Obtain marathon-lb node
    Then I wait '5' seconds


  Scenario: [01] Delete valid nginx-qa certificate in vcli
    Given I open a ssh connection to '${BOOTSTRAP_IP}' with user 'root' and password 'stratio'
    When I run 'grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
    Then I outbound copy 'src/test/resources/scripts/nginx-qa-invalid-certs.sh' through a ssh connection to '/tmp'
    And I run 'cp /stratio_volume/certs.list certs_custom_app_nginxqa.list' in the ssh connection
    And I run 'cd /tmp && sudo chmod +x nginx-qa-invalid-certs.sh' in the ssh connection
    And I run 'sudo mv /tmp/nginx-qa-invalid-certs.sh /stratio_volume/nginx-qa-invalid-certs.sh' in the ssh connection
    And I run 'docker ps | grep eos-installer | awk '{print $1}'' in the ssh connection and save the value in environment variable 'containerId'
    And I run 'sudo docker exec -t !{containerId} /stratio_volume/nginx-qa-invalid-certs.sh' in the ssh connection

#Deploying marathon with an app certificate
  Scenario: Deploying nginx-qa without valid certificate
    Given I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.labs.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
    And I outbound copy 'src/test/resources/schemas/nginx-qa-config.json' through a ssh connection to '/tmp'
    And I run 'dcos marathon app add /tmp/nginx-qa-config.json' in the ssh connection
    Then in less than '300' seconds, checking each '20' seconds, the command output 'dcos task | grep nginx-qa | grep R | wc -l' contains '1'
    When I run 'dcos task | grep ${SERVICE:-marathonlb} | tail -1 | awk '{print $5}'' in the ssh connection and save the value in environment variable 'TaskID'
    And I run 'dcos marathon task list nginx-qa | awk '{print $5}' | grep nginx-qa' in the ssh connection and save the value in environment variable 'nginx-qaTaskId'
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{nginx-qaTaskId} | grep TASK_RUNNING | wc -l' contains '1'
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{nginx-qaTaskId} | grep healthCheckResults | wc -l' contains '1'
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{nginx-qaTaskId} | grep  '"alive": true' | wc -l' contains '1'
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos task log --lines 100 !{TaskID} 2>/dev/null | grep 'Does not exists certificate for nginx-qa' | wc -l' contains '1'

  Scenario: Uninstall nginx-qa
    Given I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.labs.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
    Given I run 'dcos marathon app remove --force nginx-qa' in the ssh connection
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos task | awk '{print $1}' | grep -c nginx-qa' contains '0'

  Scenario: Restore Certificates for nginx-qa
    Given I open a ssh connection to '${BOOTSTRAP_IP}' with user 'root' and password 'stratio'
    When I run 'grep -Po '"root_token":\s*"(\d*?,|.*?[^\\]")' /stratio_volume/vault_response | awk -F":" '{print $2}' | sed -e 's/^\s*"//' -e 's/"$//'' in the ssh connection and save the value in environment variable 'vaultToken'
    Then I outbound copy 'src/test/resources/scripts/nginx-qa-restore-certs.sh' through a ssh connection to '/tmp'
    And I run 'cp /stratio_volume/certs.list certs_custom_app_nginxqa.list' in the ssh connection
    And I run 'cd /tmp && sudo chmod +x nginx-qa-restore-certs.sh' in the ssh connection
    And I run 'sudo mv /tmp/nginx-qa-restore-certs.sh /stratio_volume/nginx-qa-restore-certs.sh' in the ssh connection
    And I run 'docker ps | grep eos-installer | awk '{print $1}'' in the ssh connection and save the value in environment variable 'containerId'
    And I run 'sudo docker exec -t !{containerId} /stratio_volume/nginx-qa-restore-certs.sh' in the ssh connection