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

This chart is intentionally minimal: you **must** provide an explicit list of secret names to back up.

```bash
helm upgrade --install oc-secrets-backup ./charts/oc-secrets-backup \
  --namespace <namespace> \
  --set backup.secrets.names='{my-secret-1,my-secret-2}'
```
This is designed for small sets like **route TLS cert secrets**.

## Restore (manual)

Pick an archive from the PVC, extract it, then apply:

```bash
tar -xzf secrets_<namespace>_<timestamp>.tar.gz
kubectl apply -f ./secrets_<namespace>_<timestamp>/
```

## Notes

- This chart is **namespaced** by default. Backing up secrets from multiple namespaces would require broader RBAC (e.g., `ClusterRole`/`ClusterRoleBinding`) and is intentionally not enabled here.

