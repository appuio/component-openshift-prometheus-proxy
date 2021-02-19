local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local template = import 'template.jsonnet';

local inv = kap.inventory();
local params = inv.parameters.openshift_prometheus_proxy;

local namespace = kube.Namespace(params.namespace);

local networkpolicy =
  kube.NetworkPolicy('allow-from-labelled-ns') {
    spec+: {
      ingress: [
        {
          from: [
            {
              namespaceSelector: {
                matchLabels: {
                  'appuio.ch/prometheus-proxy': 'allowed',
                },
              },
            },
          ],
        },
      ],
    },
  };

local netns =
  kube._Object(
    'network.openshift.io/v1',
    'NetNamespace',
    params.namespace
  ) {
    netid: 0,
    netname: params.namespace,
  };

local network_access =
  if params.access.use_networkpolicy then
    networkpolicy
  else
    netns;

local user_access =
  kube.RoleBinding('proxy-access') {
    metadata+: {
      namespace: params.namespace,
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'Role',
      name: 'access-openshift-prometheus-proxy',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        namespace: s.namespace,
        name: s.name,
      }
      for s in params.access.service_account_refs
    ],
  };


{
  '00_namespace': namespace,
  network_access: network_access,
  [if std.length(params.access.service_account_refs) > 0 then 'user_access']: user_access,
  proxy_rbac: template.rbac,
}
+ template.manifests
