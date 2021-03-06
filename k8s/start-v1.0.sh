#!/bin/bash
# Get namespace
namespace=$(grep 'name: ' 00-namespace.yaml | cut -f4 -d ' ')

# Apply all yaml files
kubectl create -f . --namespace $namespace --record
