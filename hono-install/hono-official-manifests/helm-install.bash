kubectl create namespace hono
helm repo add eclipse-iot https://eclipse.org/packages/charts
helm upgrade --install eclipse-hono eclipse-iot/hono -n hono  --wait
helm upgrade --install eclipse-hono eclipse-iot/hono -n hono --values ./values.yaml --wait

helm uninstall eclipse-hono -n hono


helm template eclipse-hono eclipse-iot/hono -n hono --values ./values.yaml >> hono.yaml