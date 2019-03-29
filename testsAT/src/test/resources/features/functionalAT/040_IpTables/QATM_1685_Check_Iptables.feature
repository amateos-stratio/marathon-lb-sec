@rest
Feature: Check iptables in the node to avoid conflicts with Marathon-lb calico and minuteman

  Scenario: [Install Marathon][03][02] Obtain node where marathon-lb-sec is running
    Given I open a ssh connection to '${DCOS_CLI_HOST:-dcos-cli.demo.labs.stratio.com}' with user '${CLI_USER:-root}' and password '${CLI_PASSWORD:-stratio}'
    When I run 'dcos task | grep ${SERVICE:-marathonlb} | awk '{print $2}'' in the ssh connection and save the value in environment variable 'publicHostIP'

  Scenario: Check iptables Marathon-lb, Calico y Minuteman [01]
    Given I open a ssh connection to '!{publicHostIP}' with user 'root' and password 'stratio'
    And I run 'iptables -L | tail -10' in the ssh connection and save the value in environment variable 'iptablesInicial'
    And I outbound copy 'src/test/resources/scripts/iptables.sh' through a ssh connection to '/tmp'
    And I run 'chmod +x /tmp/iptables.sh' in the ssh connection
    And I run '/tmp/iptables.sh !{publicHostIP}' in the ssh connection
    And I run 'iptables -L | tail -10' in the ssh connection and save the value in environment variable 'iptablesFinal'
    Then '!{iptablesFinal}' is '!{iptablesInicial}'

