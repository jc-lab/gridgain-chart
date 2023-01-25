{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gridgain.name" -}}
{{- include "common.names.name" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gridgain.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Create a default mongo service name which can be overridden.
*/}}
{{- define "gridgain.service.nameOverride" -}}
    {{- if and .Values.service .Values.service.nameOverride -}}
        {{- print .Values.service.nameOverride -}}
    {{- else -}}
        {{- printf "%s-headless" (include "gridgain.fullname" .) -}}
    {{- end }}
{{- end }}

{{/*
Create a default mongo arbiter service name which can be overridden.
*/}}
{{- define "gridgain.arbiter.service.nameOverride" -}}
    {{- if and .Values.arbiter.service .Values.arbiter.service.nameOverride -}}
        {{- print .Values.arbiter.service.nameOverride -}}
    {{- else -}}
        {{- printf "%s-arbiter-headless" (include "gridgain.fullname" .) -}}
    {{- end }}
{{- end }}

{{/*
Return the proper gridgain&reg; image name
*/}}
{{- define "gridgain.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.gridgain.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "gridgain.volumePermissions.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.gridgain.volumePermissions.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "gridgain.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.gridgain.image .Values.gridgain.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper gridgain&reg; image name
*/}}
{{- define "gridgain.webconsole-backend.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.webConsoleBackend.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "gridgain.webconsole-backend.volumePermissions.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.webConsoleBackend.volumePermissions.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "gridgain.webconsole-backend.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.webConsoleBackend.image .Values.gridgain.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper gridgain&reg; image name
*/}}
{{- define "gridgain.webconsole-frontend.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.webConsoleFrontend.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "gridgain.webconsole-frontend.volumePermissions.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.webConsoleFrontend.volumePermissions.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "gridgain.webconsole-frontend.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.webConsoleFrontend.image .Values.gridgain.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper gridgain&reg; image name
*/}}
{{- define "gridgain.web-agent.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.webAgent.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "gridgain.web-agent.volumePermissions.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.webAgent.volumePermissions.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "gridgain.web-agent.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.webAgent.image .Values.gridgain.volumePermissions.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "gridgain.namespace" -}}
    {{- if and .Values.global .Values.global.namespaceOverride -}}
        {{- print .Values.global.namespaceOverride -}}
    {{- else -}}
        {{- print .Release.Namespace -}}
    {{- end }}
{{- end -}}
{{- define "gridgain.serviceMonitor.namespace" -}}
    {{- if .Values.metrics.serviceMonitor.namespace -}}
        {{- print .Values.metrics.serviceMonitor.namespace -}}
    {{- else -}}
        {{- include "gridgain.namespace" . -}}
    {{- end }}
{{- end -}}
{{- define "gridgain.prometheusRule.namespace" -}}
    {{- if .Values.metrics.prometheusRule.namespace -}}
        {{- print .Values.metrics.prometheusRule.namespace -}}
    {{- else -}}
        {{- include "gridgain.namespace" . -}}
    {{- end }}
{{- end -}}

{{/*
Returns the proper service account name depending if an explicit service account name is set
in the values file. If the name is not set it will default to either gridgain.fullname if serviceAccount.create
is true or default otherwise.
*/}}
{{- define "gridgain.serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{- default (include "gridgain.fullname" .) (print .Values.serviceAccount.name) -}}
    {{- else -}}
        {{- default "default" (print .Values.serviceAccount.name) -}}
    {{- end -}}
{{- end -}}

{{/*
Return the appropriate apiGroup for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiGroup" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy" -}}
{{- else -}}
{{- print "extensions" -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created
*/}}
{{- define "gridgain.createTlsSecret" -}}
{{- if and .Values.tls.enabled (not .Values.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing gridgain&reg; TLS certificates
*/}}
{{- define "gridgain.tlsSecretName" -}}
{{- $secretName := .Values.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-ca" (include "gridgain.fullname" .) -}}
{{- end -}}
{{- end -}}
