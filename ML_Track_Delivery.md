# ML Track Delivery Notes

## Data Visualization and Data Engineering

- The primary prototype is implemented in `notebooks/agri_guard_analysis.ipynb`.
- The notebook loads `DISTRICTS.csv`, `REGIONS.csv`, and `COMPARISON.csv` from `data/agri_guard_csvs/`.
- Data cleaning steps include:
  - removing title rows above the real headers,
  - filtering repeated header/footer rows,
  - dropping totals and blank rows,
  - converting crop production values to numeric,
  - replacing missing values with `0` where appropriate.
- Visualizations are included for crop totals and model prediction evaluation.

## Model Architecture

- Model type: `RandomForestRegressor`.
- Hyperparameters: `n_estimators=100`, `random_state=42`.
- Input features: crop production columns such as `RICE`, `CASSAVA`, `YAM`, `COCOYAM`, `PLANTAIN`, and other cleaned crop columns.
- Target variable: `MAIZE` production.
- The model is trained and evaluated at both the region level and district level.
- The notebook contains a dedicated summary section describing architecture and deployment notes.

## Initial Performance Metrics

- Metrics reported in the notebook:
  - Root Mean Squared Error (RMSE)
  - Coefficient of Determination (R²)
- These metrics are computed on the held-out test set for the district model.
- The notebook also shows prediction error distribution and top error cases.

## Deployment Option (MVP)

- Current MVP: the Jupyter Notebook prototype serves as the initial software demo.
- Future MVP options:
  - Web interface using Flask or Streamlit
  - API UI using Swagger or Postman for model prediction endpoints
  - Simple web app interface for `MAIZE` prediction input and output
- Deployment path:
  1. Convert notebook logic into a Python service module.
  2. Wrap the model in a lightweight Flask or Streamlit app.
  3. Deploy to cloud platforms such as Azure App Service, Heroku, or Render.
  4. Add API documentation and Postman collection for the prediction endpoint.

## Submission Checklist

- [x] Updated `README.md` with setup and demo instructions.
- [x] Notebook prototype: `notebooks/agri_guard_analysis.ipynb`.
- [x] Executed notebook artifact: `agri_guard_analysis_executed.ipynb`.
- [x] Python dependency list: `requirements.txt`.
- [ ] Screenshots of charts and output (recommended add to `screenshots/`).
- [ ] Video demo link or file reference.
- [ ] Optional: API mockup or simple UI snapshot.

## Next Steps for Complete ML Track Submission

- Add notebook screenshots to a new `screenshots/` folder.
- Record a short demo video focused on functionality.
- Build a minimal web or API frontend for the model.
- Add a `postman_collection.json` or Swagger-style UI if the API path is implemented.
