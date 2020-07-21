{{- define "name" -}}
reserve-excess-capacity-{{ . }}
{{- end -}}

{{- define "label-name" -}}
app.kubernetes.io/name: {{ include "name" . }}
{{- end -}}

{{- define "label-release" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{-  define "image" -}}
  {{- if hasPrefix "sha256:" .Values.image.tag }}
  {{- printf "%s@%s" .Values.image.repository .Values.image.tag }}
  {{- else }}
  {{- printf "%s:%s" .Values.image.repository .Values.image.tag }}
  {{- end }}
{{- end }}

{{- define "deploymentversion" -}}
apps/v1
{{- end -}}

{{- define "shallow-map" -}}
{{ range $key, $value := . -}}
{{ $key }}: {{ $value }}
{{ end -}}
{{- end -}}

{{- define "priority-class-name" -}}
{{- if .priorityClassName -}}
{{ .priorityClassName }}
{{- else -}}
gardener-reserve-excess-capacity
{{- end -}}
{{- end -}}