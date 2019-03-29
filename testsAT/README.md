# marathon-lb-sec

## Instalación
`mvn clean verify -Dgroups=installation -DDCOS_CLI_HOST=dcos-nightly -DCLUSTER_ID=nightly -DDCOS_IP=10.200.0.156 -DBOOTSTRAP_IP=10.200.0.155 -DCLUSTER_SSO=nightly.labs.stratio.com`

### Instalación con Command Center
`mvn clean verify -Dgroups=installation_cct -DDCOS_CLI_HOST=dcos-nightly -DCLUSTER_ID=nightly -DDCOS_IP=10.200.0.156 -DBOOTSTRAP_IP=10.200.0.155 -DCLUSTER_SSO=nightly.labs.stratio.com -DMLB_FLAVOUR=andromeda`

## Pruebas

##### Nightly CC
'mvn clean verify -Dgroups=nightly -DDCOS_CLI_HOST=dcos-cli-nightly -DDCOS_IP=10.200.0.156 -DCLUSTER_SSO=nightly.labs.stratio.com -DBOOTSTRAP_IP=10.200.0.155 -DCLUSTER_ID=nightly -DMLB_FLAVOUR=pegaso -DlogLevel=DEBUG -DVAULT_HOST=vault.service.paas.labs.stratio.com'

##### iptables
`mvn clean verify -Dgroups=iptables -DDCOS_CLI_HOST=dcos-nightly -DDCOS_IP=10.200.0.156 -DCLUSTER_SSO=nightly.labs.stratio.com -DBOOTSTRAP_IP=10.200.0.155 -DCLUSTER_ID=nightly`

## Desinstalación
`mvn clean verify -Dgroups=purge`

### Desinstalación con Command Center
`mvn clean verify -Dgroups=uninstall_cct -DDCOS_CLI_HOST=dcos-nightly -DCLUSTER_ID=nightly -DDCOS_IP=10.200.0.156 -DBOOTSTRAP_IP=10.200.0.155 -DCLUSTER_SSO=nightly.labs.stratio.com`



