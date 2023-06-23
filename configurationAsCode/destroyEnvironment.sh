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
    blob="${TF_VAR_labname}-components.tfstate"

    terraform -chdir=./components/ init \
              -backend-config="key=${TF_VAR_labname}-components.tfstate" \
              -backend-config="access_key=${STATE_BLOBACCESSKEY_CAC}" \
              -backend-config="storage_account_name=${STATE_SAACCOUNTNAME_CAC}"
    export TF_VAR_clientid=${ARM_CLIENT_ID}
    export TF_VAR_clientsecret=${ARM_CLIENT_SECRET}

    terraform -chdir=./components/ destroy -target=module.certManager --auto-approve ;

    if [ "$jenkins" == true ] ;
    then
        terraform -chdir=./components/ destroy -target=module.jenkins --auto-approve ;
    fi

    if [ "$nexus" == true ] ;
    then
        terraform -chdir=./components/ destroy -target=module.nexus --auto-approve ;
    fi

    if [ "$keycloak" == true ] ;
    then
        terraform -chdir=./components/ destroy -target=module.keycloak --auto-approve ;
    fi

    if [ "$gitlab" == true ] ;
    then
        terraform -chdir=./components/ destroy -target=module.gitlab --auto-approve ;
    fi

    if [ "$argocd" == true ] ;
    then
        terraform -chdir=./components/ destroy -target=module.argocd --auto-approve ;
    fi    

    if [ "$tekton" == true ] ;
    then
        terraform -chdir=./components/ destroy -target=module.tekton --auto-approve ;
    fi

    #delete blob file
    az storage blob delete --delete-snapshots include --account-name "${STATE_SAACCOUNTNAME_CAC}" --container-name terraformstate --name ${blob}

    status=$?
    [ $status -eq 0 ] && echo "CAC run successful" || exit $status
)