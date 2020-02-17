{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "minikube-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "minikube-helm.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "minikube-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "minikube-helm.labels" -}}
helm.sh/chart: {{ include "minikube-helm.chart" . }}
{{ include "minikube-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "minikube-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "minikube-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Evaluate Db Name
*/}}
{{- define "minikube-helm.env.db-name" -}}
{{- if (eq .Values.db.config.type "configmap") -}}
valueFrom:
  configMapKeyRef:
    name: {{ .Values.db.config.name }}
    key: {{ .Values.db.config.nameKey }}
{{- else if (eq .Values.db.config.type "secret") -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.db.config.name }}
    key: {{ .Values.db.config.nameKey }}
{{- else -}}
value: {{ .Values.db.config.dbName }}
{{- end -}}
{{- end -}}

{{/*
Evaluate Db User
*/}}
{{- define "minikube-helm.env.db-user" -}}
{{- if (eq .Values.db.config.type "configmap") -}}
valueFrom:
  configMapKeyRef:
    name: {{ .Values.db.config.name }}
    key: {{ .Values.db.config.userKey }}
{{- else if (eq .Values.db.config.type "secret") -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.db.config.name }}
    key: {{ .Values.db.config.userKey }}
{{- else -}}
value: {{ .Values.db.config.dbUser }}
{{- end -}}
{{- end -}}

{{/*
Evaluate Db Password
*/}}
{{- define "minikube-helm.env.db-password" -}}
{{- if (eq .Values.db.config.type "configmap") -}}
valueFrom:
  configMapKeyRef:
    name: {{ .Values.db.config.name }}
    key: {{ .Values.db.config.passwordKey }}
{{- else if (eq .Values.db.config.type "secret") -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.db.config.name }}
    key: {{ .Values.db.config.passwordKey }}
{{- else -}}
value: {{ .Values.db.config.dbPassword }}
{{- end -}}
{{- end -}}

