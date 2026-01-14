{{- define "oc-secrets-backup.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "oc-secrets-backup.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "oc-secrets-backup.name" . -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "oc-secrets-backup.labels" -}}
app.kubernetes.io/name: {{ include "oc-secrets-backup.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name (.Chart.Version | replace "+" "_") }}
{{- end -}}

{{- define "oc-secrets-backup.serviceAccountName" -}}
{{- if .Values.serviceAccount.name -}}
{{- .Values.serviceAccount.name -}}
{{- else -}}
{{- printf "%s" (include "oc-secrets-backup.fullname" .) -}}
{{- end -}}
{{- end -}}

{{- define "oc-secrets-backup.pvcName" -}}
{{- if .Values.pvc.name -}}
{{- .Values.pvc.name -}}
{{- else -}}
{{- printf "%s-backup" (include "oc-secrets-backup.fullname" .) -}}
{{- end -}}
{{- end -}}

