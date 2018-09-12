@rest

Feature: Deploying marathon-lb-sec with client certificate
#Installing marathon-lb-sec
  @runOnEnv(INSTALL_MARATHON=true)
  @include(feature:../010_installation.feature,scenario:[Install Marathon-lb][01] Version 0.3.1)
  @include(feature:../010_installation.feature,scenario:[Install Marathon-lb][02] Install using config file and cli)
  @include(feature:../010_installation.feature,scenario:[Install Marathon][03][01] Check Marathon-lb has being installed correctly)
  @include(feature:../010_installation.feature,scenario:[Install Marathon][03][02] Obtain node where marathon-lb-sec is running)
  @include(feature:../010_installation.feature,scenario:[Install Marathon][03][03] Make sure service is ready)
  Scenario: Prueba install
    Then I wait '5' seconds

  @skipOnEnv(INSTALL_MARATHON=true)
  @include(feature:../010_installation.feature,scenario:[Install Marathon][03][02] Obtain node where marathon-lb-sec is running)
  Scenario: Prueba install
    Then I wait '5' seconds

#Deploying marathon with a clients certificate
  Scenario: Deploying marathon-lb-sec with a clients certificate
    Given I run 'cat /etc/hosts | grep nginx-qa.labs.stratio.com || echo "!{publicHostIP} nginx-qa.labs.stratio.com" | sudo tee -a /etc/hosts' locally
    Then I open a ssh connection to '${BOOTSTRAP_IP}' with user 'root' and password 'stratio'
    And I outbound copy 'src/test/resources/scripts/marathon-lb-manage-certs.sh' through a ssh connection to '/tmp'
    And I run 'cd /tmp && sudo chmod +x marathon-lb-manage-certs.sh' in the ssh connection
    And I run 'sudo mv /tmp/marathon-lb-manage-certs.sh /stratio_volume/marathon-lb-manage-certs.sh' in the ssh connection
    And I run 'docker ps | grep eos-installer | awk '{print $1}'' in the ssh connection and save the value in environment variable 'containerId'
    And I run 'sudo docker exec -t !{containerId} /stratio_volume/marathon-lb-manage-certs.sh' in the ssh connection
    And I wait '60' seconds
    And I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.labs.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
    And I outbound copy 'src/test/resources/schemas/nginx-qa-config.json' through a ssh connection to '/tmp'
    And I run 'dcos marathon app add /tmp/nginx-qa-config.json' in the ssh connection
    Then in less than '300' seconds, checking each '20' seconds, the command output 'dcos task | grep nginx-qa | grep R | wc -l' contains '1'
    And I run 'dcos marathon task list nginx-qa | awk '{print $5}' | grep nginx-qa' in the ssh connection and save the value in environment variable 'nginx-qaTaskId'
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{nginx-qaTaskId} | grep TASK_RUNNING | wc -l' contains '1'
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{nginx-qaTaskId} | grep healthCheckResults | wc -l' contains '1'
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{nginx-qaTaskId} | grep  '"alive": true' | wc -l' contains '1'
    #Uninstalling nginx-qa
    Given I run 'dcos marathon app remove --force nginx-qa' in the ssh connection
    Then in less than '300' seconds, checking each '10' seconds, the command output 'dcos task | awk '{print $1}' | grep -c nginx-qa' contains '0'

#Uninstalling marathon-lb-sec
#  @include(feature:../purge.feature,scenario:marathon-lb-sec can be uninstalled using cli)
#  Scenario: Prueba borrado
#    Then I wait '5' seconds

