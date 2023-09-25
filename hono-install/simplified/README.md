# Simplified Hono

## Deploy Steps

### 1.Deploy Infra
Use docker-compose

### 2.Create namespace

```shell
kubectl create ns hono
```

### 3. Deploy auth-service
```shell
kubectl apply -f hono-simplify-auth-service.yaml 
```

### 4. Deploy device-registry

Depends on:
* auth-service
* message-infra (kafka)
* database (mongodb)

```shell
kubectl apply -f hono-simplify-device-registry.yaml 
```

### 5. Deploy command-router

```shell
kubectl apply -f hono-simplify-service-command-router.yaml
```

### 6. Deploy http-adapter

```shell
kubectl apply -f hono-simplify-http-adapter.yaml
```

## Test
Reference: [Getting Started](https://eclipse.dev/hono/docs/getting-started/)

### 1.Creating a new Tenant
```shell
curl -i -X POST -H "content-type: application/json" --data-binary '{
  "ext": {
    "messaging-type": "kafka"
  }
}' http://akane.k8s.com:32046/device-registry/v1/tenants
```

response
```shell
HTTP/1.1 201 Created
Date: Mon, 25 Sep 2023 13:18:42 GMT
Content-Type: application/json; charset=utf-8
Content-Length: 45
Connection: keep-alive
etag: 32719a9e-742a-41a5-96f5-5d2e7bb52fdf
location: /v1/tenants/5fc3fd85-b68d-4a64-9a3e-f315fc3c5cbe

{"id":"5fc3fd85-b68d-4a64-9a3e-f315fc3c5cbe"}
```

### 2. Adding a Device to the Tenant

```shell
curl --location --request POST 'http://akane.k8s.com:32046/device-registry/v1/devices/5fc3fd85-b68d-4a64-9a3e-f315fc3c5cbe'
```

response

```json
{"id":"30044c0c-7952-4689-8be9-83241c8af15a"}
```

### 3. Setting a Password for the Device
```shell
curl -i -X PUT -H "content-type: application/json" --data-binary '[{
  "type": "hashed-password",
  "auth-id": "'30044c0c-7952-4689-8be9-83241c8af15a'",
  "secrets": [{
      "pwd-plain": "'aaa'"
  }]
}]' http://akane.k8s.com:32046/device-registry/v1/credentials/5fc3fd85-b68d-4a64-9a3e-f315fc3c5cbe/30044c0c-7952-4689-8be9-83241c8af15a
```

```shell
HTTP/1.1 204 No Content
Date: Mon, 25 Sep 2023 13:34:18 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
etag: 5e084069-7522-412c-a85a-1dc7665d34c6

```

### 4. Publishing Telemetry Data to the HTTP Adapter

```shell
curl -i -u 30044c0c-7952-4689-8be9-83241c8af15a@5fc3fd85-b68d-4a64-9a3e-f315fc3c5cbe:aaa  -H 'Content-Type: application/json' --data-binary '{
"x": 5,
"y": 10,
"z: 0
}' http://akane.k8s.com:32046/http-adapter/telemetry
```
response
```shell
HTTP/1.1 202 Accepted
Date: Mon, 25 Sep 2023 13:35:23 GMT
Content-Length: 0
Connection: keep-alive

```

### 5. Publishing Events to the HTTP Adapter
```shell
curl -i -u 30044c0c-7952-4689-8be9-83241c8af15a@5fc3fd85-b68d-4a64-9a3e-f315fc3c5cbe:aaa  -H 'Content-Type: application/json' --data-binary '{
"alarm": "fire"
}' http://akane.k8s.com:32046/http-adapter/event
```

response
```shell
HTTP/1.1 202 Accepted
Date: Mon, 25 Sep 2023 13:39:54 GMT
Content-Length: 0
Connection: keep-alive
```