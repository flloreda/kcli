VERSION="v[[ kubevirt_version ]]"
yum -y install xorg-x11-xauth remote-viewer wget
sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/selinux/config
setenforce 0
kubectl config set-context `kubectl config current-context` --namespace=kube-system
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/kubevirt.yaml
kubectl create -f kubevirt.yaml
kubectl expose deploy haproxy  --port=8184
kubectl expose svc haproxy
wget https://github.com/kubevirt/kubevirt/releases/download/$VERSION/virtctl-$VERSION-linux-amd64
mv virtctl-$VERSION-linux-amd64 /usr/bin/virtctl
chmod u+x /usr/bin/virtctl
kubectl create -f /root/iscsi-demo-target.yaml
kubectl patch deployment/iscsi-demo-target-tgtd --patch '{"spec":{"template":{"spec":{"nodeSelector":{"kubernetes.io/hostname":"kumaster"}}}}}'
kubectl config set-context `kubectl config current-context` --namespace=default