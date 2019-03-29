@rest
Feature: [QATM-1870] Service_Installation

  @skipOnEnv(ADVANCED_CONFIGURATION=TRUE)
  Scenario: [QATM-1870][01] Marathon-LB Simple Installation - Deploy service
    Given I authenticate to DCOS cluster '${DCOS_IP}' using email '${DCOS_USER:-admin}' with user '${REMOTE_USER:-operador}' and pem file 'src/test/resources/credentials/${PEM_FILE:-key.pem}'
    And I securely send requests to '${CLUSTER_ID}.${CLUSTER_DOMAIN:-labs.stratio.com}:443'
    # Obtain schema
    When I send a 'GET' request to '/service/deploy-api/deploy/marathon-lb/${MLB_FLAVOUR}/schema?level=1'
    Then I save element '$' in environment variable 'marathonlb-json-schema'
    And I run 'echo !{marathonlb-json-schema}' locally
    # Convert json
    And I convert jsonSchema '!{marathonlb-json-schema}' to json and save it in variable 'marathonlb-basic.json'
    And I run 'echo '!{marathonlb-basic.json}' > target/test-classes/schemas/marathonlb-basic.json' locally
    # Launch installation
    When I send a 'POST' request to '/service/deploy-api/deploy/marathon-lb/${MLB_FLAVOUR}/schema' based on 'schemas/marathonlb-basic.json' as 'json' with:
      |$.general.serviceId                           | UPDATE  | ${SERVICE:-marathonlb}                                     |n/a     |
    Then the service response status must be '202'
    And I run 'rm -f target/test-classes/schemas/cct/marathonlb-basic.json' locally

  Scenario: [QATM-1870][02] Marathon-LB Installation - Status
    Given I authenticate to DCOS cluster '${DCOS_IP}' using email '${DCOS_USER:-admin}' with user '${REMOTE_USER:-operador}' and pem file 'src/test/resources/credentials/${PEM_FILE:-key.pem}'
    And I securely send requests to '${CLUSTER_ID}.${CLUSTER_DOMAIN:-labs.stratio.com}:443'
    #Check status in API
    When in less than '500' seconds, checking each '20' seconds, I send a 'GET' request to '/service/deploy-api/deploy/status/service?service=/${SERVICE:-marathonlb}' so that the response contains '"healthy":1'
    #Check status in DCOS
    When I open a ssh connection to '${DCOS_CLI_HOST}' with user 'root' and password 'stratio'
    Then in less than '500' seconds, checking each '20' seconds, the command output 'dcos task | grep ${SERVICE:-marathonlb} | grep R | wc -l' contains '1'
    When I run 'dcos task |  awk '{print $5}' | grep ${SERVICE:-marathonlb}' in the ssh connection and save the value in environment variable 'marathonlb-TaskId'
    Then in less than '1200' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{marathonlb-TaskId} | grep TASK_RUNNING' contains 'TASK_RUNNING'
    And in less than '1200' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{marathonlb-TaskId} | grep healthCheckResults' contains 'healthCheckResults'
    And in less than '1200' seconds, checking each '10' seconds, the command output 'dcos marathon task show !{marathonlb-TaskId} | grep  '"alive": true'' contains '"alive": true'
