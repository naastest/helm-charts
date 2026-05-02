{{/*
Fully qualified resource name. Uses fullnameOverride if set, otherwise release name.
*/}}
{{- define "service.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels applied to all resources.
*/}}
{{- define "service.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "service.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels — used by Deployment.spec.selector and Service.spec.selector.
*/}}
{{- define "service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Resolve the Service targetPort: explicit override or falls back to containerPort.
*/}}
{{- define "service.targetPort" -}}
{{- if .Values.service.targetPort }}
{{- .Values.service.targetPort }}
{{- else }}
{{- .Values.containerPort }}
{{- end }}
{{- end }}

{{/*
Resolve the probe port: explicit override or falls back to containerPort.
*/}}
{{- define "service.probePort" -}}
{{- if .Values.probes.port }}
{{- .Values.probes.port }}
{{- else }}
{{- .Values.containerPort }}
{{- end }}
{{- end }}
