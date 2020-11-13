PREFIX=olm
REGISTRY=$(hostname -f):5000
PULL_SECRET="/root/openshift_pull.json"
for packagemanifest in $(oc get packagemanifest -n openshift-marketplace -o name) ; do
  echo $packagemanifest
  for package in $(oc get $packagemanifest -o jsonpath='{.status.channels[*].currentCSVDesc.relatedImages}' | sed "s/ /\n/g" | tr -d '[],' | sed 's/"/ /g') ; do
    skopeo copy docker://$package docker://$REGISTRY/$PREFIX/openshift4-$(basename $package) --all --authfile $PULL_SECRET
  done
done