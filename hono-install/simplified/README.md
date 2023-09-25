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