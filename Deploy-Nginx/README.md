# Deploy NGINX Proxy to Prod

This ansible playbook was an attempt to

- Deploy a Proxmox VM from clone
- Configure VM network settings
- Configure VM (Install Docker)
- Deploy my NGINX docker container
- Depoy Configs

The Idea is to run this playbook to bring my Proxy server up an in an operational state.



## TODO
### Priority 

##### High
 - deploy configs
    - current workaround - mount NFS and cp files. I will host these types of things   
    within an internal HTTP file server
 - DNS entry for VM - TBD

##### Medium
 - workout backup crons - TBD

##### Low
 - DNS Entries for configs within ansbile - TBD
    - This will require a restPS server and some scripts to allow for this to happen. for now it's manual.
    - a future state would be an API call to a windows endpoint with the ability to make / delete / update DNS records for a given zone.



