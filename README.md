# reserve-excess-capacity
Gardener extension to deploy reserve excess capacity pods in node pools.

## helm chart

The [chart](charts/reserve-excess-capacity) deploys a reserve excess capacity `Deployment` per node pool.
Reserve excess capacity `deployments` can be deployed for more than one node pool using the following structure in the [values](charts/reserve-excess-capacity/values.yaml).

```yaml
pools:
  <pool-name>:
    podLabels: #optional
      ...
    replicaCount: 1
    resources:
      requests:
        cpu: ...
        memory: ...
```

One reserve excess capacity [`Deployment`](charts/reserve-excess-capacity/templates/deployment.yaml) will generated per node pool in the following way.
- `replicaCount` will be used in `spec.replicas`
- `resources.requests` will be used in `spec.template.container[0].resources.requests`
- `podLabels` (if supplied) will be used in the `spec.selector` and `spec.template.metadata.labels`

### Note

Please note that the chart [above](#helm-chart) doesn't add any affinity or tolerations in the `spec.template` of the generated reserve excess capacity `deployments`.
That must be done separately using [gardener/kupid](https://github.com/gardener/kupid) and [gardener/cluster-pod-scheduling-policy](https://github.com/gardener/cluster-pod-scheduling-policy)

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
            podLabels: #optional
              ...
          replicaCount: 1
          resources:
            requests:
              cpu: ...
              memory: ...

```