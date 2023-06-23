#!/bin/bash
set -e

# this script requires reading SPIs & other secrets before running
# for example: tenant_id and Azure-Service-Principal can be read from Azure KeyVault
# a read task exposes that secrets as environment variable during the pipeline run
# they are set via "bash task environment variable parameter"
# if you want to run this script locally, please run prepareTerraform.sh

if [ -z "$TF_VAR_labname" ] ;
then
    echo "environmentname is unset" ;
    exit 1;
fi

(
    set -x
    blob="${TF_VAR_labname}inventory"
    storageAccountName="${TF_VAR_labname}inventory"
    az storage blob download --account-name ${storageAccountName} --container-name vminventoryfiles --name ${blob} --file inventory
    az storage blob download --account-name ${storageAccountName} --container-name vminventoryfiles --name "k8sconf" --file /home/vsts/work/r1/a/_infrastructure/configurationAsCode/sharedFolder/tenancy/defaultkube.conf
    ansible-playbook -v -i inventory -T 500 --extra-vars keyboard_language=${TF_VAR_vmLang} /home/vsts/work/r1/a/_infrastructure/configurationAsCode/ldev-playbook.yml
    az storage blob delete --account-name ${storageAccountName} --container-name vminventoryfiles --name ${blob}

    status=$?
    [ $status -eq 0 ] && echo "Provision run successful" || exit $status
)
