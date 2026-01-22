# Simple Microservice Example - Kubernetes Deployment

A microservice application example deployed on Kubernetes with NodeJS, Python, Redis, and MongoDB.

## Working Screenshot

See `himanshu_working.png` for deployment verification.

## Architecture

This application demonstrates a microservices architecture deployed on Kubernetes (Minikube):

- **Frontend**: NGINX serving static HTML/JS (with jQuery and Bulma CSS)
- **API Gateway**: Node.js service routing API requests
- **Quote Service**: Python Flask application for quote management
- **Databases**: MongoDB (persistent storage) and Redis (caching)

## Prerequisites

### Local Development
* Node.js
* Python 3
* pip3

### Kubernetes Deployment
* Docker
* Minikube
* kubectl

### Python Dependencies (QuoteService)
* flask
* pymongo
* redis

## Kubernetes Resources

The deployment includes the following Kubernetes resources:

**Deployments:**
- `apigateway-deployment.yml` - API Gateway service
- `mongo-deployment.yml` - MongoDB database
- `nginx-deployment.yml` - NGINX web server
- `quote-deployment.yml` - Quote service
- `redis-deployment.yml` - Redis cache

**Services:**
- `apigateway-service.yml` - ClusterIP service for API Gateway
- `mongo-service.yml` - ClusterIP service for MongoDB
- `nginx-service.yml` - NodePort/LoadBalancer service for web access
- `quote-service.yml` - ClusterIP service for Quote API
- `redis-service.yml` - ClusterIP service for Redis

**Storage:**
- `mongo-pvc.yml` - PersistentVolumeClaim for MongoDB data
- `redis-pvc.yml` - PersistentVolumeClaim for Redis data

**ConfigMaps:**
- MongoDB initialization script (created from `MongoDB/init-db.js`)
- NGINX configuration (created from `FrontendApplication/vhost.conf`)

## Deployment Instructions

### Option 1: Automated Deployment

Run the provided script:

```bash
chmod +x run_script.sh
./run_script.sh
```

This script will:
1. Start Minikube
2. Create PersistentVolumeClaims
3. Deploy Redis and MongoDB with ConfigMaps
4. Build Docker images using Minikube's Docker daemon
5. Deploy all microservices
6. Set up networking with Kubernetes Services

### Option 2: Manual Deployment

1. Start Minikube:
```bash
minikube start
```

2. Deploy storage and databases:
```bash
kubectl apply -f redis-pvc.yml
kubectl apply -f redis-deployment.yml
kubectl apply -f redis-service.yml

kubectl create configmap mongo-config --from-file=./MongoDB/init-db.js
kubectl apply -f mongo-pvc.yml
kubectl apply -f mongo-deployment.yml
kubectl apply -f mongo-service.yml
```

3. Build and deploy Quote Service:
```bash
eval $(minikube docker-env)
docker build -t quote ./QuoteService
kubectl apply -f quote-deployment.yml
kubectl apply -f quote-service.yml
```

4. Build and deploy API Gateway:
```bash
docker build -t apigateway ./ApiGateway
kubectl apply -f apigateway-deployment.yml
kubectl apply -f apigateway-service.yml
```

5. Build and deploy Frontend:
```bash
docker build -t nginx-frontend ./FrontendApplication
kubectl create configmap nginx-config --from-file=nginx.conf=./FrontendApplication/vhost.conf
kubectl apply -f nginx-deployment.yml
kubectl apply -f nginx-service.yml
eval $(minikube docker-env --unset)
```

### Accessing the Application

Get the service URL:
```bash
minikube service nginx-service --url
```

Then open the URL in your browser to access the application.

## Building the Frontend (Optional)

If you need to rebuild the frontend with a custom API Gateway URL:

1. Go to `FrontendApplication` directory
2. Run `npm install` or `yarn` to install packages
3. Set the API Gateway environment variable:
   - Linux/Mac: `export API_GATEWAY=http://YOUR_HOST`
   - Windows: `set API_GATEWAY=http://YOUR_HOST`
   - Note: No trailing slash, add port if not using standard ports
4. Run `npm run build` or `yarn build`
5. Check `dist/` folder for the built files

## Verifying Deployment

Check all pods are running:
```bash
kubectl get pods
```

Check all services:
```bash
kubectl get services
```

View logs for troubleshooting:
```bash
kubectl logs <pod-name>
```

## Application Components

### API Gateway (Node.js)
- Port: 3000
- Routes requests to Quote Service
- Environment variable: `QUOTES_API=http://quote-service`

### Quote Service (Python Flask)
- Connects to MongoDB and Redis
- Provides quote management API

### MongoDB
- Port: 27017
- Credentials: root/pass (configured in deployment YAML)
- Database: quote_db
- Persistent storage via PVC

### Redis
- Caching layer
- Persistent storage via PVC

### NGINX
- Port: 80
- Serves static frontend files
- Configured via ConfigMap

## Notes

- Images use `imagePullPolicy: Never` to use locally built images from Minikube's Docker daemon
- Default configuration uses `localhost` - modify for production deployments
- MongoDB and Redis data persists across pod restarts using PersistentVolumeClaims

![image](https://raw.githubusercontent.com/CSUChico-CSCI644/simple-microservice-example/main/working.png)
