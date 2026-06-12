# Agri-Guard AI

Capstone project repository for the ML Track initial product demonstration.

## Description

Agri-Guard AI is an AI-driven agricultural intelligence platform with two connected systems:

1. **Farmer Advisory and Crop Record System** — collects and manages farm and crop activity data from registered farmers.
2. **Crop Availability Prediction System** — predicts expected harvest quantities, harvest periods, and regional produce availability for buyers.

The platform is designed to help buyers discover where crops are being grown, view predicted quantities by region or location, and drill down to farmer-level production details. It also helps farmers record crop activities, receive advisory guidance, and generate structured agricultural datasets for machine learning.

The project includes:

- A Jupyter Notebook prototype for data cleaning, visualization, and model development.
- A Flask API backend with Swagger documentation.
- A Streamlit UI for interactive prediction.
- A Flutter mobile app shell under `agriguard_ai/`.

## GitHub Repository

- Repository URL: https://github.com/MariamIssah/agri-guard-ai.git

## Submission Package Contents

- `README.md` - this submission guide and usage instructions.
- `DEPLOYMENT_GUIDE.md` - deployment options for Flask, Streamlit, and containerized hosting.
- `ML_Track_Delivery.md` - ML track delivery notes and checklist.
- `openapi.yaml` - API specification for prediction endpoints.
- `postman_collection.json` - Postman collection for API testing.
- `notebooks/agri_guard_analysis.ipynb` - analysis notebook.
- `agri_guard_analysis_executed.ipynb` - executed notebook artifact.
- `app.py` - Flask API server.
- `streamlit_app.py` - Streamlit web interface.
- `agri_guard_model.py` - model loading and prediction utilities.
- `models/` - trained model and encoder artifacts.
- `agriguard_ai/` - Flutter app project skeleton.
- `screenshots/` - placeholder directory for app screenshots.
- `DESIGNS.md` - design and UI/circuit placeholder notes.
- `VIDEO_DEMO_LINK.txt` - demo recording reference.

## Environment Setup

1. Clone the repository:

```powershell
git clone https://github.com/MariamIssah/agri-guard-ai.git
cd agri-guard-ai
```

2. Create and activate a virtual environment:

```powershell
python -m venv venv
venv\Scripts\activate
```

3. Install Python dependencies:

```powershell
pip install -r requirements.txt
```

## Run the Notebook Prototype

1. Start Jupyter Notebook:

```powershell
py -m notebook
```

2. Open `notebooks/agri_guard_analysis.ipynb`.

## Run the Flask API

1. Start the service:

```powershell
python app.py
```

2. Open Swagger UI:

- `http://localhost:5000/apidocs`

3. Use the `POST /api/v1/predict` endpoint or import `postman_collection.json`.

## Run the Streamlit App

```powershell
streamlit run streamlit_app.py
```

Open the browser at `http://localhost:8501`.

## Designs and Screenshots

This submission includes:

- `DESIGNS.md` - design notes and placeholders for flutter app, screen flows, and circuit diagrams.
- `screenshots/` - add UI screenshots and notebook output images here before final submission.
- `VIDEO_DEMO_LINK.txt` - demo video link: https://youtu.be/PQyY4fddw3k

## Deployment Plan

### Local MVP

- Notebook prototype: `notebooks/agri_guard_analysis.ipynb`
- Flask API: `app.py` with `/api/v1/predict`, `/api/v1/model/info`, `/api/v1/regions`, `/api/v1/crops`
- Streamlit UI: `streamlit_app.py`

### Cloud Deployment

Option A: Azure App Service

- Create a resource group and App Service plan.
- Deploy Flask API via ZIP or Git repository.
- Expose the app through App Service and use App URL for demo.

Option B: Streamlit deployment

- Deploy `streamlit_app.py` via Streamlit Cloud, Azure Container Apps, or Docker.

### Future Enhancements

- Add weather, soil, and farm management inputs.
- Extend the mobile app under `agriguard_ai/` to call the Flask prediction API.
- Add a production-grade model serving pipeline with monitoring.

## Demo Instructions

Record a 5-10 minute video demonstrating:

1. Project setup and environment activation.
2. Opening the notebook and reviewing data cleaning/models.
3. Running the Streamlit prediction UI or Flask API.
4. Showing the prediction workflow and output.
5. Summarizing the deployment plan and next steps.

## Notes

- If any model artifacts are missing, run the training script under `scripts/`.
- For mobile integration, the Flutter app shell is available under `agriguard_ai/`.
- Add screenshot and video assets to the `screenshots/` folder and `VIDEO_DEMO_LINK.txt`.
