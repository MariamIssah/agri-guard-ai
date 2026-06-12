from pathlib import Path
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import RandomizedSearchCV, KFold
from sklearn.metrics import mean_squared_error, make_scorer, mean_absolute_error, r2_score
import joblib


def find_data_dir():
    path = Path.cwd()
    for _ in range(8):
        candidate = path / 'data' / 'agri_guard_csvs'
        if candidate.exists():
            return candidate
        path = path.parent
    raise FileNotFoundError('Could not locate data/agri_guard_csvs from cwd: ' + str(Path.cwd()))

DATA_DIR = find_data_dir()
REGIONS_PATH = DATA_DIR / 'REGIONS.csv'
MODELS_DIR = Path('models')
MODELS_DIR.mkdir(exist_ok=True)

print('Using data dir:', DATA_DIR)

regions = pd.read_csv(REGIONS_PATH, header=1)
# Basic cleaning similar to run_models
region_model = regions.copy()
valid_region = region_model['REGION'].astype(str).str.strip()
invalid_mask = (
    valid_region.isna()
    | valid_region.eq('')
    | valid_region.str.contains(r'PRODUCTION|TOTAL|REGION', case=False, na=False)
)
region_model = region_model[~invalid_mask].copy()
numeric_cols = [col for col in region_model.columns if col != 'REGION']
for col in numeric_cols:
    region_model[col] = pd.to_numeric(
        region_model[col].astype(str).str.replace(',', '', regex=False).str.strip(),
        errors='coerce'
    )
region_model = region_model.dropna(subset=['MAIZE']).fillna(0)
region_model = region_model.drop(columns=['REGION'])
X = region_model.drop(columns=['MAIZE'])
y = region_model['MAIZE']

# Define model and param distribution
rf = RandomForestRegressor(random_state=42)
param_dist = {
    'n_estimators': [50, 100, 200, 400],
    'max_depth': [None, 5, 10, 20, 30],
    'min_samples_split': [2, 5, 10],
    'min_samples_leaf': [1, 2, 4],
    'max_features': ['auto', 'sqrt', 0.5]
}

cv = KFold(n_splits=5, shuffle=True, random_state=42)

# scorer: use neg MSE and we will report RMSE
def rmse_scorer(y_true, y_pred, **kwargs):
    return mean_squared_error(y_true, y_pred) ** -0.5  # not used directly

scoring = 'neg_mean_squared_error'

search = RandomizedSearchCV(rf, param_distributions=param_dist, n_iter=20, cv=cv, scoring=scoring, n_jobs=-1, random_state=42, verbose=1)
print('Starting RandomizedSearchCV...')
search.fit(X, y)

best = search.best_estimator_
print('Best params:', search.best_params_)
# compute CV RMSE from cv_results
mean_cv_mse = search.best_score_
cv_rmse = ( -mean_cv_mse ) ** 0.5
print('Best CV RMSE (approx):', round(cv_rmse, 2))

# Save best model
joblib.dump(best, MODELS_DIR / 'region_rf_best.joblib')
print('Saved best model to', MODELS_DIR / 'region_rf_best.joblib')

# Also save search results summary
cvres = pd.DataFrame(search.cv_results_)
cvres.to_csv(MODELS_DIR / 'region_search_results.csv', index=False)
print('Saved search results to', MODELS_DIR / 'region_search_results.csv')
