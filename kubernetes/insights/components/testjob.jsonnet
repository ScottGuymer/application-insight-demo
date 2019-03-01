local env = std.extVar("__ksonnet/environments");
local k = import "k.libsonnet";


local job = {
  "apiVersion": "batch/v1",
  "kind": "Job",
  "metadata": {
    "name": "runtest"
  },
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "test",
            "image": "k6test",
            "imagePullPolicy": "Never"
          }
        ],
        "restartPolicy": "Never"
      }
    },
    "backoffLimit": 4
  }
};

local cronJob = {
  "apiVersion": "batch/v1beta1",
  "kind": "CronJob",
  "metadata": {
    "name": "runtest"
  },
  "spec": {
    "schedule": "*/6 * * * *",
    "jobTemplate": {
      "spec": {
        "template": {
          "spec": {
            "containers": [
              {
                "name": "test",
                "image": "k6test",
                "imagePullPolicy": "Never"
              }
            ],
            "restartPolicy": "OnFailure"
          }
        },
      },
    },
  }
};

k.core.v1.list.new([job, cronJob])