#!/bin/bash
terraform apply -auto-approve
terraform output > deploy_ips.txt
ansible-playbook -i inventory Playbook.yaml
git add ..
git commit -m "new deploy"
git push