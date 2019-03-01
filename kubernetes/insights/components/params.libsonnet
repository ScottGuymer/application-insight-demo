{
  global: {
    // User-defined global parameters; accessible to all component and environments, Ex:
    // replicas: 4,
  },
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    dotnetcore: {
      containerPort: 80,
      image: "dotnetcore",
      name: "dotnetcore",
      replicas: 1,
      servicePort: 80,
      type: "LoadBalancer",
    },
    jaeger: {
      containerPort: 80,
      image: "jaegertracing/all-in-one:latest",
      name: "jaeger",
      replicas: 1
    },
    python: {
      containerPort: 5000,
      image: "python",
      name: "python",
      replicas: 1,
      servicePort: 80,
      type: "LoadBalancer",
    },
    nodejs: {
      containerPort: 3000,
      image: "node",
      name: "nodejs",
      replicas: 1,
      servicePort: 80,
      type: "LoadBalancer",
    },
    java: {
      containerPort: 8080,
      image: "java",
      name: "java",
      replicas: 1,
      servicePort: 80,
      type: "LoadBalancer",
    },
  },
}
