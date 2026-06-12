# Agri-Guard AI Deployment Guide

## Overview

This guide covers three deployment options for the Agri-Guard AI MVP:

1. **Flask API** with Swagger documentation
2. **Streamlit Web Interface**
3. **Static HTML UI** mockup

## Prerequisites

- Python 3.11+
- `pip` package manager
- Git
- Azure CLI (optional, for cloud deployment)

## Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/agri-guard-ai.git
cd agri-guard-ai
```

2. **Create a virtual environment**

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**

```bash
pip install -r requirements.txt
pip install flask flask-cors flasgger streamlit
```

---

## Option 1: Flask API with Swagger

### Local Development

**Start the Flask server:**

```bash
python app.py
```

The API will be available at `http://localhost:5000`

**Access Swagger UI:**

- Navigate to `http://localhost:5000/apidocs`
- View and test all endpoints with the interactive Swagger interface

### API Endpoints

#### 1. Health Check

```
GET /health
```

Response:

```json
{
  "status": "healthy",
  "service": "Agri-Guard AI API"
}
```

#### 2. Get Model Info

```
GET /api/v1/model/info
```

Response:

```json
{
  "name": "RandomForestRegressor",
  "n_trees": 100,
  "target": "MAIZE",
  "features": ["RICE", "CASSAVA", "YAM", ...],
  "test_rmse": "~25,000 units",
  "test_r2": "~0.68"
}
```

#### 3. Get Features

```
GET /api/v1/features
```

#### 4. Make Prediction (Main Endpoint)

```
POST /api/v1/predict
Content-Type: application/json

{
  "RICE": 4000,
  "CASSAVA": 100000,
  "YAM": 5000,
  "COCOYAM": 10000,
  "PLANTAIN": 15000,
  "MILLET": 0,
  "SORGHUM": 0
}
```

Response:

```json
{
  "predicted_MAIZE": 75000.50,
  "input_features": {...},
  "confidence": "baseline",
  "message": "Prediction generated from trained model"
}
```

### Testing with Postman

1. **Import Postman Collection**
   - Open Postman
   - Click `Import` → `File` → select `postman_collection.json`
   - Set `base_url` variable to `http://localhost:5000`

2. **Run Requests**
   - Use pre-configured requests to test all endpoints
   - Modify parameters and observe predictions

### Deployment to Azure

**Option A: Azure App Service**

```bash
# Create resource group
az group create --name agri-guard-rg --location eastus

# Create App Service plan
az appservice plan create --name agri-guard-plan \
  --resource-group agri-guard-rg --sku B1 --is-linux

# Create Flask app
az webapp create --resource-group agri-guard-rg \
  --plan agri-guard-plan --name agri-guard-api --runtime "PYTHON|3.11"

# Deploy code
az webapp deployment source config-zip --resource-group agri-guard-rg \
  --name agri-guard-api --src deployment.zip
```

**Option B: Azure Container Instances**

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

Build and push:

```bash
docker build -t agri-guard-api:latest .
docker tag agri-guard-api:latest yourregistry.azurecr.io/agri-guard-api:latest
docker push yourregistry.azurecr.io/agri-guard-api:latest

# Deploy
az container create --resource-group agri-guard-rg \
  --name agri-guard-api --image yourregistry.azurecr.io/agri-guard-api:latest \
  --cpu 1 --memory 1 --ports 5000
```

---

## Option 2: Streamlit Web Interface

### Local Development

**Start the Streamlit app:**

```bash
streamlit run streamlit_app.py
```

The web interface will open at `http://localhost:8501`

### Features

- **Prediction Tab**: Input crop values → Get MAIZE prediction
- **Model Info Tab**: View architecture, metrics, and features
- **About Tab**: Project overview and quick links

### Deployment to Azure

**Option A: Azure Container Apps**

```bash
# Create container app environment
az containerapp env create --name agri-guard-env \
  --resource-group agri-guard-rg --location eastus

# Create container app
az containerapp create --name agri-guard-web \
  --resource-group agri-guard-rg \
  --environment agri-guard-env \
  --image yourregistry.azurecr.io/agri-guard-web:latest \
  --target-port 8501 \
  --ingress external \
  --query properties.configuration.ingress.fqdn
```

**Option B: Streamlit Cloud** (Free, simple)

1. Push code to GitHub
2. Go to https://streamlit.io/cloud
3. Connect GitHub repo and deploy with one click

### Configuration for Streamlit

Create `.streamlit/config.toml`:

```toml
[server]
headless = true
port = 8501

[browser]
gatherUsageStats = false
```

---

## Option 3: Static HTML UI Mockup

### Local Testing

Simply open `index.html` in your browser:

```bash
# On Windows
start index.html

# On macOS
open index.html

# On Linux
xdg-open index.html
```

Or run a local server:

```bash
python -m http.server 8080
# Navigate to http://localhost:8080
```

### Deployment to Azure

**Option A: Azure Static Web Apps**

```bash
# Create static web app
az staticwebapp create --name agri-guard-ui \
  --resource-group agri-guard-rg \
  --source https://github.com/yourusername/agri-guard-ai \
  --branch main \
  --location eastus
```

**Option B: Azure Blob Storage + CDN**

```bash
# Create storage account
az storage account create --name agriguardui \
  --resource-group agri-guard-rg --location eastus

# Enable static website hosting
az storage blob service-properties update \
  --account-name agriguardui \
  --static-website \
  --index-document index.html

# Upload files
az storage blob upload-batch -s . -d '$web' \
  --account-name agriguardui
```

---

## API Documentation Files

### OpenAPI/Swagger Spec

- **File**: `openapi.yaml`
- **Usage**:
  - Import in Swagger Editor: https://editor.swagger.io/
  - Generate API clients
  - API documentation site

### Postman Collection

- **File**: `postman_collection.json`
- **Usage**:
  - Import in Postman
  - Test all endpoints
  - Share with team

---

## Running All Three Simultaneously

Terminal 1 (Flask API):

```bash
python app.py
# API at http://localhost:5000
# Swagger at http://localhost:5000/apidocs
```

Terminal 2 (Streamlit):

```bash
streamlit run streamlit_app.py
# Web at http://localhost:8501
```

Terminal 3 (Static HTML):

```bash
python -m http.server 8080
# HTML at http://localhost:8080
```

---

## Production Checklist

- [ ] Replace mock predictions with actual trained model
- [ ] Add authentication (API key, OAuth)
- [ ] Enable HTTPS/TLS
- [ ] Set up logging and monitoring
- [ ] Configure CORS for allowed origins
- [ ] Add rate limiting
- [ ] Set up CI/CD pipeline
- [ ] Configure environment variables
- [ ] Set up database for predictions log
- [ ] Add API versioning strategy
- [ ] Document deployment architecture
- [ ] Plan scaling strategy

---

## Environment Variables

Create `.env` file:

```
FLASK_ENV=production
FLASK_DEBUG=False
API_KEY=your-api-key-here
AZURE_SUBSCRIPTION_ID=your-subscription-id
DATABASE_URL=postgresql://user:password@host/db
```

Load in Python:

```python
from dotenv import load_dotenv
import os

load_dotenv()
api_key = os.getenv('API_KEY')
```

---

## Monitoring and Logging

### Application Insights Integration

```python
from opencensus.ext.flask.flask_middleware import FlaskMiddleware
from opencensus.ext.azure.trace_exporter import AzureExporter

middleware = FlaskMiddleware(
    app,
    exporter=AzureExporter(connection_string="InstrumentationKey=...")
)
```

---

## Performance Tips

1. **Caching**: Use Redis for prediction caching
2. **Async**: Use async handlers for long-running predictions
3. **Load Balancing**: Deploy multiple instances behind a load balancer
4. **CDN**: Serve static files from CDN
5. **Database Indexing**: Index frequently queried fields

---

## Next Steps

1. Train the actual model and save to disk
2. Create database schema for logging predictions
3. Set up CI/CD pipeline (GitHub Actions, Azure Pipelines)
4. Configure monitoring and alerting
5. Plan multi-region deployment
6. Implement caching layer
7. Add advanced features (batch predictions, model versioning)

---

## Support & Resources

- [Flask Documentation](https://flask.palletsprojects.com/)
- [Streamlit Documentation](https://docs.streamlit.io/)
- [OpenAPI/Swagger Spec](https://swagger.io/specification/)
- [Azure Deployment Guide](https://learn.microsoft.com/en-us/azure/)
- [Postman Learning Center](https://learning.postman.com/)
