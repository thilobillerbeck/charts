{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "strapi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "strapi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "strapi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "strapi.labels" -}}
helm.sh/chart: {{ include "strapi.chart" . }}
{{ include "strapi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "strapi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "strapi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "strapi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "strapi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* CUSTOM FUNCTIONS*/}}

{{/*
Create a default fully qualified postgresql name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "strapi.postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified name for the secret that contains the database password.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "strapi.databaseSecret.fullname" -}}
{{- if .Values.postgresql.enabled -}}
{{- include "strapi.postgresql.fullname" . }}
{{- else -}}
{{- include "strapi.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Set the proper name for the secretKeyRef key that contains the database password.
*/}}
{{- define "strapi.databaseSecret.key" -}}
{{- if .Values.postgresql.enabled -}}
postgres-password
{{- else -}}
db-password
{{- end -}}
{{- end -}}

{{/*
Set the proper database host. If postgresql is installed as part of this chart, use the default service name,
else use user-provided host
*/}}
{{- define "strapi.database.host" }}
{{- if .Values.postgresql.enabled -}}
{{- include "strapi.postgresql.fullname" . }}
{{- else -}}
{{- .Values.database.host | quote }}
{{- end -}}
{{- end -}}

{{/*
Set the proper database port. If postgresql is installed as part of this chart, use the default postgresql port,
else use user-provided port
*/}}
{{- define "strapi.database.port" }}
{{- if .Values.postgresql.enabled -}}
{{- default "5432" ( .Values.postgresql.service.port | quote ) }}
{{- else -}}
{{- .Values.database.port | quote }}
{{- end -}}
{{- end -}}
