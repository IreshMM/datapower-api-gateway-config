FROM vmware/powerclicore:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing -y

RUN apt-get install -y vim

RUN /opt/microsoft/powershell/7-lts/pwsh -Command 'Set-PowerCLIConfiguration -InvalidCertificateAction ignore -Confirm:$false'

