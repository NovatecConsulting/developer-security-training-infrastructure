[academy]
${vmip_name} 

[guac]
${vmguac}

[all:vars]
ansible_connection=ssh 
ansible_ssh_user=${user} 
ansible_ssh_pass=${pass}

[guac:vars]
domain=${fqdnguac}

### SSH AND RDP ACCESS VIA BROWSER
Website is available at: [CLICK](https://${fqdnguac}/#/) 
Username is SchulungN (replace N with your assigned number)
PW:-'AguacNovatecSchulungCloud'-