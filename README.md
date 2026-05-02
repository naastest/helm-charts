# naastest/helm-charts

Shared Helm charts for NaaS teams. All charts ship with security defaults that
pass the NaaS Kyverno baseline policies out of the box.

## Charts

| Chart | Version | Description |
|-------|---------|-------------|
| [service](charts/service/) | 0.1.0 | Deployment + Service. Optional HPA, PDB, Ingress. |

## Usage in ArgoCD

Teams put a values file in `apps/helm/dev/` in their team repo. The
`tenant-apps-helm-dev` ApplicationSet in `naas-platform` picks it up and
creates a Helm Application pointing at this chart.

### Minimal values file

```yaml
# apps/helm/dev/checkout-service.yaml
image: "nginxinc/nginx-unprivileged:1.27.4"
containerPort: 8080
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    cpu: 200m
    memory: 256Mi
```

### Full values file

```yaml
image: "myorg/my-api:1.2.3"
containerPort: 8080
replicaCount: 2

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

hpa:
  enabled: true
  minReplicas: 2
  maxReplicas: 8
  targetCPUUtilizationPercentage: 70

pdb:
  enabled: true
  minAvailable: 1

ingress:
  enabled: true
  host: my-api.naas.local

env:
  LOG_LEVEL: info
  PORT: "8080"
```

## Security contract

| NaaS Kyverno policy | Enforced default |
|---------------------|------------------|
| `no-root-containers` | `securityContext.runAsNonRoot: true` |
| `disallow-privilege-escalation` | `securityContext.allowPrivilegeEscalation: false` |
| `require-resource-limits` | `resources.requests` + `resources.limits` always set |
| `restrict-hostpath` | no hostPath volumes rendered |

Setting `runAsNonRoot: false` or `allowPrivilegeEscalation: true` will cause
Kyverno to reject the pod at admission.
