# Complete example

An end-to-end example that will provision the following:
- A new resource group if one is not passed in.
- A new VPC with 2 subnets and a new OpenShift cluster in the VPC with 1 workers pool.
- The IBM MQ operator in the default operator namespace.
- Installs IBM MQ Queue Manager using the IBM MQ operator.
