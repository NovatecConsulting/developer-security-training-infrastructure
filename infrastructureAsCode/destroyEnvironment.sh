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
    
    terraform init \
              -backend-config="key=${TF_VAR_labname}-components.tfstate" \
              -backend-config="access_key=${STATE_BLOBACCESSKEY}" \
              -backend-config="storage_account_name=${STATE_SAACCOUNTNAME}"
    export TF_VAR_clientid=${ARM_CLIENT_ID}
    export TF_VAR_clientsecret=${ARM_CLIENT_SECRET}

    # This is a workaround for: 
    #Cannot delete custom domain "klilab.trainings.nvtc.io" because it is still directly or indirectly 
    #(using "cdnverify" prefix) CNAMEd to CDN endpoint "klilab.azureedge.net". 
    #Please remove the DNS CNAME record and try again.
    az network dns record-set cname delete -g ${TF_VAR_rsgcommon} -z ${TF_VAR_dnsZone} -n ${TF_VAR_labname} --yes

    terraform destroy -target module.components.azurerm_cdn_endpoint_custom_domain.static_website --auto-approve ;

    terraform destroy --auto-approve
    #delete blob file
    az storage blob delete --delete-snapshots include --account-name "${STATE_SAACCOUNTNAME}" --container-name terraformstate --name ${blob}

    status=$?
    [ $status -eq 0 ] && echo "IAC run successful" || exit $status
)
