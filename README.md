# k0s on gcp vm instance

* Prerequisites:

- Create a VM instance and install Terraform and ansible
- Generate ssh key and add under gcp vm instances metadata ssh keys

```
sudo apt install openssh-server
systemctl enable ssh --now
ssh-keygen

##for terraform

- https://github.com/tfutils/tfenv
- tfenv install 1.0.5
- tfenv use 1.0.5

##for ansible
apt install ansible
```

Steps:

- Clone the repo
git clone https://github.com/anskrish/k0s.git

- Create copy the gcp service account json file

```
cp <your-keyfile-path>/server-account.json .

```

- Apply the changes

```
terraform apply -auto-approve
```

- Update the ansible inventory

```
cd ansible
sed -i 's/35.225.98.11/<first-ip-from-terraform-output>/g' hosts.ini
sed -i 's/34.67.119.193/<second-ip-from-terraform-output>/g' hosts.ini

```

- Apply the playbook

```
ansible-playbook script.yaml -i hosts.ini 

```

- Login to first node

```
ssh <first-ip>
k0sctl init > k0sctl.yaml
vim k0sctl.yaml
### update address and keyPath
```
Ex:

```
apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
  name: k0s-cluster
spec:
  hosts:
  - ssh:
      address: 35.225.98.11
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
    role: controller
  - ssh:
      address: 34.67.119.193
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
    role: worker
  k0s:
    version: 1.27.2+k0s.0
    dynamicConfig: false
```
- Apply the cluster

```
k0sctl apply --config k0sctl.yaml
```

- Copy the kubeconfig

```
k0sctl kubeconfig --config k0sctl.yaml > ~/.kube/config
```

- Validate the cluster status

```
kubectl cluster-info
kubectl get nodes
```

- Install simple application

```
kubectl run nginx --image=nginx
kubectl expose pod nginx --type=NodePort --name=nginx-service --port=80 --target-port=80
```

- Access your application

```
http:<second ip>:<node-port>


- 
