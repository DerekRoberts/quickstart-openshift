# `oc-secrets-backup`

Back up Kubernetes/OpenShift `Secret` objects to a PVC on a schedule.

## What it deploys

- A `PersistentVolumeClaim` (PVC) to store backups (kept on uninstall by default)
- A `CronJob` that dumps selected secrets to `/backups` and creates a `tar.gz` archive
- Optional namespaced RBAC (`Role` + `RoleBinding`) and `ServiceAccount`

## Install

```bash
helm upgrade --install oc-secrets-backup ./charts/oc-secrets-backup \
  --namespace <namespace> \
  --create-namespace
```

## Selecting secrets

You can back up:

- A fixed list of secrets:

```bash
helm upgrade --install oc-secrets-backup ./charts/oc-secrets-backup \
  --namespace <namespace> \
  --set backup.secrets.names='{my-secret-1,my-secret-2}'
```

- Or secrets matching a label selector:

```bash
helm upgrade --install oc-secrets-backup ./charts/oc-secrets-backup \
  --namespace <namespace> \
  --set backup.secrets.labelSelector='app.kubernetes.io/instance=my-release'
```

By default it excludes service-account token secrets (`kubernetes.io/service-account-token`) since they rotate and are noisy.

## Restore (manual)

Pick an archive from the PVC, extract it, then apply:

```bash
tar -xzf secrets_<namespace>_<timestamp>.tar.gz
kubectl apply -f ./secrets_<namespace>_<timestamp>/
```

## Notes

- This chart is **namespaced** by default. Backing up secrets from multiple namespaces would require broader RBAC (e.g., `ClusterRole`/`ClusterRoleBinding`) and is intentionally not enabled here.

