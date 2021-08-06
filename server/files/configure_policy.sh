#!/bin/bash -e
until curl -s -k https://localhost:8501/v1/status/leader | grep 8300; do
  echo "Waiting for Consul to start"
  sleep 1
done


consul acl policy create -name "users" \
  -description "This is the policy for the Users node and service" \
  -datacenter "dc1" \
  -rules @users_acl_policy.hcl
