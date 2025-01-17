# Installation of kubeadm cluster on Ubuntu 22.04 that I personally use on my ubuntu VPS machines to deploy pods via github actions

# 1. Disable swap:
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 2. Test the ports:
# On the server: nc -l 6443
# On the local machine: nc x.x.x.x 6443

# 3. Setup ipv4 bridge on all nodes
# Create config file for modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Load modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Create another config file for sysctl
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Apply sysctl parameters
sudo sysctl --system

# 4. Update apt source list
sudo apt-get update
# sudo apt-get upgrade -y

# 5. Install containerd
# sudo apt-get install containerd -y
# OR if you are planning to also use docker:
sudo apt-get install docker.io -y

# 6. Configure containerd for the cgroup driver used by kubeadm (systemd)
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

# 7. Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

# 8. Install helper tools
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# 9. Download the public signing key for the Kubernetes package repositories
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# 10. Add the Kubernetes apt repository for v1.29
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 11. Update apt source list, install kubelet, kubeadm and kubectl and hold them at the current version
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 12. Initialize the cluster
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# 13. Copy the kubeconfig file to the user's home directory and change the ownership
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 14. Install the Tigera Calico operator and custom resource definitions
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml

# 15. Install Calico by creating the necessary custom resource. For more information on configuration options available in this manifest
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml

# 16. Check the status of the cluster
# kubectl get pods -n calico-system

# 17. Remove the taints on the control plane so that you can schedule pods on it
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# 18. Check the nodes
# kubectl get nodes -o wide
