Hyperparameter search results — Region RandomForest

- Best params: {"n_estimators": 100, "min_samples_split": 5, "min_samples_leaf": 2, "max_features": 0.5, "max_depth": 30}
- Best CV RMSE (approx): 78536.95
- Saved model: models/region_rf_best.joblib
- Saved search results CSV: models/region_search_results.csv

Notes:

- Some candidate parameter sets failed due to incompatible `max_features='auto'` with the sklearn version; the search still returned a usable best model.
- Next: run a focused GridSearch around the best params, evaluate on held-out test split, and update the notebook with the final test metrics and plots.
