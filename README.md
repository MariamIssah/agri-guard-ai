# Agri-Guard AI

Capstone Project for the ML track initial product demonstration.

## Project Overview

Agri-Guard AI uses historical Ghana agricultural production data to build an early prototype for predicting crop production and supporting farm planning.

## Repository Contents

- `data/agri_guard_csvs/` - source CSV datasets for districts, regions, and year comparisons
- `notebooks/agri_guard_analysis.ipynb` - analysis notebook with data exploration, visualization, cleanup, modeling, and evaluation
- `requirements.txt` - project Python dependencies
- `README.md` - project summary and setup instructions

## Setup Instructions

1. Install Python 3.11+ or a compatible Python environment.
2. Install required packages:

```powershell
py -m pip install pandas matplotlib scikit-learn notebook
```

3. Open the notebook server from the repository root:

```powershell
py -m notebook
```

4. Open `notebooks/agri_guard_analysis.ipynb` in the browser.

## Notes

- The CSV files require cleanup because each file includes a title row above the real header row.
- The notebook loads the region dataset, cleans repeated header rows, and reshapes the data for modeling.
- The `COMPARISION.csv` filename is spelled with an `i` in this repository, and the notebook handles that file accordingly.

## Demo and Submission

- Use the notebook as the primary product demonstration.
- Capture screenshots from `notebooks/agri_guard_analysis.ipynb` to show charts and model results.
- Record a 5–10 minute demo video focusing on functionality and the analysis flow.
- Include the executed notebook artifact `agri_guard_analysis_executed.ipynb` in the repo if needed.

## Deployment Plan

- Current MVP: a Jupyter Notebook prototype demonstrating data cleaning, visualization, and ML modeling.
- Local setup: install dependencies via `requirements.txt` and run `py -m notebook` from the repo root.
- Future deployment: expose the model via a Flask or Streamlit web interface, then host on a cloud platform such as Azure, Heroku, or Render.
- The deployment path should include a simple prediction UI or API endpoint for generic crop harvest quantity and location availability.

## GitHub Repo Link

- Repository: https://github.com/<your-username>/agri-guard-ai

## Suggested Documentation Additions

- Add screenshots of the notebook charts and model output.
- Add a short video demo link or file reference.
- Add notes on how the notebook represents the product MVP and how it will evolve into a web/API solution.

## ML Track Requirements

This repository now includes the following ML track delivery items:

- `notebooks/agri_guard_analysis.ipynb` — data visualization, data engineering, modeling, and evaluation.
- `ML_Track_Delivery.md` — explicit ML track notes covering model architecture, initial performance metrics, and deployment options.
- `agri_guard_analysis_executed.ipynb` — executed notebook artifact for review.

## Next Steps

- Capture visuals from the notebook and save them in a `screenshots/` folder.
- Build a simple UI or swagger-style API mockup for the model.
- Add more explicit model architecture notes in the notebook.
