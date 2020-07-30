# reserve-excess-capacity
Gardener extension to deploy reserve excess capacity pods in node pools.

## helm chart

The [chart](charts/reserve-excess-capacity) deploys a reserve excess capacity `Deployment` per node pool.
Reserve excess capacity `deployments` can be deployed for more than one node pool using the following structure in the [values](charts/reserve-excess-capacity/values.yaml).

```yaml
pools:
  <pool-name>:
    nodeLabels: #optional
      ...
    replicaCount: 1
    resources:
      requests:
        cpu: ...
        memory: ...
```

One reserve excess capacity [`Deployment`](charts/reserve-excess-capacity/templates/deployment.yaml) will generated per node pool in the following way.
- `replicaCount` will be used in `spec.replicas`
- `resources.requests` will be used in `spec.template.spec.container[0].resources.requests`
- `nodeLabels` (if supplied) will be used as `key` and `values` in `spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[*]` respectively (with `operator: In`) and as `key` and `value` in `spec.template.spec.tolerations[*]` respectively (with `operator: Equal` and `effect: NoExecute`). 

## `ControllerRegistration`

The gardener [`ControllerRegistration`](example/controller-registration.yaml) is generated based on the helm chart [above](#helm-chart).

The node pools can be customized by specifying a structure similar to the one [above](#helm-chart) under the path `spec.deployment.providerConfig.values`.

I.e.
```yaml
apiVersion: core.gardener.cloud/v1beta1
kind: ControllerRegistration
metadata:
  name: reserve-excess-capacity
spec:
  deployment:
    ...
    providerConfig:
      values:
        ...
        pools:
          <pool-name>:
            nodeLabels: #optional
              ...
          replicaCount: 1
          resources:
            requests:
              cpu: ...
              memory: ...

```