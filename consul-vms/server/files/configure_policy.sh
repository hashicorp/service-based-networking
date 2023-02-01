#!/bin/bash -e
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


until curl -s -k https://localhost:8501/v1/status/leader | grep 8300; do
  echo "Waiting for Consul to start"
  sleep 1
done

# Creaste the ACL policy
consul acl policy create -name "users" \
  -description "This is the policy for the Users node and service" \
  -datacenter "dc1" \
  -rules @users_acl_policy.hcl

consul acl policy create -name "orders" \
  -description "This is the policy for the Orders node and service" \
  -datacenter "dc1" \
  -rules @orders_acl_policy.hcl


# Create the service to service intentions
consul config write orders_to_users_intentions.hcl