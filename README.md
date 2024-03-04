# desafio2-eks

Arquivos de deploy do EKS usando terraform na pasta [eks](eks), alteração de arquivos nessa pasta disparam a [pipeline](.github/workflows/pipeline.yaml).

Na pasta [manifests-monitoring](manifests-monitoring) estão os arquivos para implementar o prometheus e o grafana. Foi adicionado o alerta Node Exporter HostCpuIsUnderutilized em [05-prometheus-alertrules.yaml](manifests-monitoring/05-prometheus-alertrules.yaml) e feito o deployment conforme [README](manifests-monitoring/README.md).

Em [manifests-alerting](manifests-alerting) estão os arquivos para implementar o alert manager, foi configurado o email a serem enviados os alertas no [configmap](manifests-alerting/alertmanager-configmap.yaml).

Antes de implementar o efk foi instalado o eck conforme [documentação](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-eck.html).
Em [efk](efk) estão os arquivos para implementar o elastic, fluentd e kibana.

Em [apm](apm) estão os arquivos para implementar o Elastic APM e uma app node de exemplo.

O argo cd foi implementado seguindo a [documentação](https://argo-cd.readthedocs.io/en/stable/getting_started/), o deployment de frontend foi separado das demais aplicações e está na pasta [frontend](frontend).






