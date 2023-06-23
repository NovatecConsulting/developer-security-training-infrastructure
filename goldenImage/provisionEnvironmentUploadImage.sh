#!/bin/bash
set -e

# this script requires reading SPIs & other secrets before running
# for example: tenant_id and Azure-Service-Principal can be read from Azure KeyVault
# a read task exposes that secrets as environment variable during the pipeline run
# they are set via "bash task environment variable parameter"
# if you want to run this script locally, please run prepareTerraform.sh

if [ -z "$TF_VAR_rsgcommon" ] ;
then
    echo "environmentname is unset" ;
    exit 1;
fi

(
    sudo apt-get install sshpass

    blob="ansibleinventorygold"
    #Download blobs: inventory file for ansible provision and k8sconf for kubectl ns/rbac based uservm config creation within in vms:
    az storage blob download --account-name ${STATE_SAACCOUNTNAME} --container-name vminventoryfiles --name ${blob} --file inventory
    #lets check which ansible version the agent is running
    ansible --version
    #execute ansible playbook with new inventory file:
    pwd 
    ls -altrh
    ansible-playbook -v -i inventory -T 500 --extra-vars keyboard_language=${TF_VAR_vmLang} /home/vsts/work/r1/a/_infrastructure/configurationAsCode/ldev-playbook.yml

    #delete blob file because tf cannot update it. if you want to update a lab evertime a new inventory file is created:
    az storage blob delete --account-name ${STATE_SAACCOUNTNAME} --container-name vminventoryfiles --name ${blob}

    set -x 
    #get image id for image upload - this ID we need later in TF. TODO add this ID as TF_VAR_IMAGEID
    ID=$(az vm get-instance-view -g $TF_VAR_rsgcommon -n gold-vm-goldenimage --query id)
    ID=$(sed -e 's/^"//' -e 's/"$//' <<<"$ID")
    #create image sig:
    az sig image-definition create \
   --resource-group $TF_VAR_rsgcommon \
   --gallery-name $TF_VAR_gal \
   --gallery-image-definition $TF_VAR_vmGoldenImageName \
   --publisher 'novatec' \
   --offer 'docker-aks-rdp' \
   --sku 'docker-aks-rdp-sku' \
   --os-type Linux \
   --os-state generalized
   #deallocate vm for image creation
   az vm deallocate -g $TF_VAR_rsgcommon --name gold-vm-goldenimage
   #generalize vm for image creation
   az vm generalize -g $TF_VAR_rsgcommon --name gold-vm-goldenimage
   #create image version and upload
   az sig image-version create -g $TF_VAR_rsgcommon --gallery-name $TF_VAR_gal --gallery-image-definition $TF_VAR_vmGoldenImageName --gallery-image-version $TF_VAR_vmGoldenImageVersion --managed-image $ID

    status=$?
    [ $status -eq 0 ] && echo "Provision run successful" || exit $status
)
