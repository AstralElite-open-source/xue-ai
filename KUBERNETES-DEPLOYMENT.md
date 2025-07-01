# Xue AI - Kubernetes Deployment Guide

## Overview
This document provides complete instructions for deploying the Xue AI application to Kubernetes using Docker containers.

## Prerequisites
- Docker Desktop with Kubernetes enabled
- kubectl configured and connected to your cluster
- Docker image `xue:latest` built locally

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │   Deployment    │  │    Services     │  │   External   │ │
│  │                 │  │                 │  │    Access    │ │
│  │  xue-ai         │  │ LoadBalancer    │  │              │ │
│  │  5 replicas     │──│ NodePort        │──│ localhost:80 │ │
│  │                 │  │ Port Forward    │  │ localhost:... │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Configuration Files

### 1. Deployment Configuration (`x.yml`)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: xue-ai
spec:
  replicas: 5
  selector:
    matchLabels:
      app: xue-ai
  template:
    metadata:
      labels:
        app: xue-ai
    spec:
      containers:
      - name: xue-ai
        image: xue:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 8080
        env:
        - name: GOOGLE_API_KEY
          value: "your-google-api-key-here"
        - name: FLASK_ENV
          value: "production"
```

### 2. LoadBalancer Service (`k8s-service.yml`)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: xue-ai-service
spec:
  selector:
    app: xue-ai
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

### 3. NodePort Service (`k8s-nodeport.yml`)
```yaml
apiVersion: v1
kind: Service
metadata:
  name: xue-ai-nodeport
spec:
  type: NodePort
  selector:
    app: xue-ai
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30080
```

## Deployment Steps

### Step 1: Prepare Docker Image
```bash
# Build the Docker image
docker build -t xue:latest .

# Verify the image exists
docker images | grep xue
```

### Step 2: Deploy to Kubernetes
```bash
# Apply the deployment
kubectl apply -f x.yml

# Apply the LoadBalancer service
kubectl apply -f k8s-service.yml

# Apply the NodePort service (optional)
kubectl apply -f k8s-nodeport.yml
```

### Step 3: Verify Deployment
```bash
# Check deployment status
kubectl get deployments

# Check pod status
kubectl get pods

# Check services
kubectl get services

# Get comprehensive overview
kubectl get all
```

## Access Methods

### 1. LoadBalancer Service
- **URL**: http://localhost
- **Port**: 80
- **Internal Port**: Maps to container port 8080

### 2. NodePort Service
- **URL**: http://localhost:30080
- **Port**: 30080
- **Type**: Direct cluster access

### 3. Port Forwarding
```bash
# Forward local port 8080 to service port 80
kubectl port-forward service/xue-ai-service 8080:80
```
- **URL**: http://localhost:8080
- **Use Case**: Development and debugging

### 4. LoadBalancer NodePort
- **URL**: http://localhost:32215
- **Port**: Auto-assigned by Kubernetes
- **Type**: LoadBalancer's NodePort mapping

## Monitoring and Management

### Check Application Health
```bash
# View pod logs
kubectl logs -l app=xue-ai

# Check specific pod logs
kubectl logs xue-ai-56685dd6bd-xxxxx

# Monitor pod status
kubectl get pods -w
```

### Scaling
```bash
# Scale up/down replicas
kubectl scale deployment xue-ai --replicas=3

# Auto-scaling (optional)
kubectl autoscale deployment xue-ai --min=2 --max=10 --cpu-percent=80
```

### Updates
```bash
# Update deployment (after rebuilding image)
kubectl rollout restart deployment/xue-ai

# Check rollout status
kubectl rollout status deployment/xue-ai

# View rollout history
kubectl rollout history deployment/xue-ai
```

## Troubleshooting

### Common Issues

#### 1. ImagePullBackOff Error
```bash
# Check pod events
kubectl describe pod xue-ai-xxxxx

# Solution: Ensure imagePullPolicy is set to 'Never' for local images
```

#### 2. Service Not Accessible
```bash
# Check service endpoints
kubectl get endpoints

# Check if pods are running
kubectl get pods -l app=xue-ai

# Test internal connectivity
kubectl exec -it xue-ai-xxxxx -- curl localhost:8080
```

#### 3. Application Startup Errors
```bash
# Check application logs
kubectl logs xue-ai-xxxxx

# Common fix: Ensure environment variables are set correctly
```

### Health Checks
```bash
# Test LoadBalancer
curl -I http://localhost

# Test NodePort
curl -I http://localhost:30080

# Test port forwarding
curl -I http://localhost:8080
```

## Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `GOOGLE_API_KEY` | Google Gemini API key | - | Yes |
| `FLASK_ENV` | Flask environment | production | Yes |
| `PORT` | Application port | 8080 | No |
| `HOST` | Bind address | 0.0.0.0 | No |

## Security Considerations

1. **API Keys**: Store sensitive data in Kubernetes secrets
2. **Network Policies**: Implement network segmentation
3. **RBAC**: Configure role-based access control
4. **Image Security**: Scan images for vulnerabilities

### Using Kubernetes Secrets (Recommended)
```bash
# Create secret for API key
kubectl create secret generic xue-ai-secrets \
  --from-literal=GOOGLE_API_KEY=your-actual-api-key

# Update deployment to use secret
# Add to container spec:
# envFrom:
# - secretRef:
#     name: xue-ai-secrets
```

## Performance Optimization

### Resource Limits
```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Readiness and Liveness Probes
```yaml
readinessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 60
  periodSeconds: 30
```

## Cleanup

### Remove All Resources
```bash
# Delete deployment
kubectl delete -f x.yml

# Delete services
kubectl delete -f k8s-service.yml
kubectl delete -f k8s-nodeport.yml

# Or delete by labels
kubectl delete all -l app=xue-ai
```

## Success Verification

Your deployment is successful when:
- ✅ All 5 pods are in `Running` status
- ✅ Services show external access points
- ✅ Application responds to HTTP requests
- ✅ Port forwarding shows active connections

## Support

For issues or questions:
1. Check pod logs: `kubectl logs -l app=xue-ai`
2. Verify service configuration: `kubectl get services`
3. Check deployment status: `kubectl get deployments`
4. Review this documentation for troubleshooting steps

---

**Deployment Date**: $(date)
**Kubernetes Version**: $(kubectl version --short)
**Application**: Xue AI Chat Application
**Image**: xue:latest 