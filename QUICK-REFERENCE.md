# Xue AI - Quick Reference Guide

## 🚀 Quick Start Commands

### Deploy Everything
```bash
kubectl apply -f x.yml
kubectl apply -f k8s-service.yml
kubectl apply -f k8s-nodeport.yml
```

### Check Status
```bash
kubectl get all                    # Overview
kubectl get pods                   # Pod status
kubectl get services              # Service status
```

### Access URLs
- **Primary**: http://localhost
- **NodePort**: http://localhost:30080  
- **Port Forward**: http://localhost:8080
- **LoadBalancer NodePort**: http://localhost:32215

## 🔧 Common Operations

### View Logs
```bash
kubectl logs -l app=xue-ai                    # All pods
kubectl logs xue-ai-56685dd6bd-xxxxx          # Specific pod
kubectl logs -f xue-ai-56685dd6bd-xxxxx       # Follow logs
```

### Scale Application
```bash
kubectl scale deployment xue-ai --replicas=3  # Scale to 3 pods
kubectl scale deployment xue-ai --replicas=5  # Scale to 5 pods
```

### Port Forwarding
```bash
kubectl port-forward service/xue-ai-service 8080:80  # Local access
```

### Restart Deployment
```bash
kubectl rollout restart deployment/xue-ai     # Rolling restart
kubectl rollout status deployment/xue-ai      # Check restart status
```

## 🔍 Troubleshooting

### Pod Issues
```bash
kubectl describe pod xue-ai-xxxxx             # Detailed pod info
kubectl get events --sort-by=.metadata.creationTimestamp  # Recent events
```

### Service Issues
```bash
kubectl get endpoints                         # Check service endpoints
kubectl describe service xue-ai-service       # Service details
```

### Test Connectivity
```bash
curl -I http://localhost                      # Test LoadBalancer
curl -I http://localhost:30080               # Test NodePort
kubectl exec -it xue-ai-xxxxx -- curl localhost:8080  # Internal test
```

## 🧹 Cleanup

### Delete All Resources
```bash
kubectl delete -f x.yml
kubectl delete -f k8s-service.yml  
kubectl delete -f k8s-nodeport.yml
```

### Quick Delete by Label
```bash
kubectl delete all -l app=xue-ai
```

## ⚙️ Configuration Files

- `x.yml` - Main deployment (5 replicas)
- `k8s-service.yml` - LoadBalancer service  
- `k8s-nodeport.yml` - NodePort service
- `Dockerfile` - Container definition

## 🔐 Security

### Using Secrets (Recommended)
```bash
# Create secret
kubectl create secret generic xue-ai-secrets \
  --from-literal=GOOGLE_API_KEY=your-key

# Apply secret (update x.yml to reference secret)
kubectl apply -f x.yml
```

## 📊 Current Deployment Status

```
✅ Deployment: xue-ai (5/5 replicas)
✅ LoadBalancer: xue-ai-service (port 80)
✅ NodePort: xue-ai-nodeport (port 30080)
✅ Image: xue:latest (local)
✅ External Access: Multiple methods available
``` 