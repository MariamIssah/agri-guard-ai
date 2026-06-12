from pathlib import Path
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import GridSearchCV, KFold
from sklearn.metrics import mean_squared_error
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

rf = RandomForestRegressor(random_state=42)
param_grid = {
    'n_estimators': [100, 200],
    'max_depth': [20, 30],
    'min_samples_split': [2, 5],
    'min_samples_leaf': [1, 2],
    'max_features': [0.45, 0.5, 0.55, 'sqrt']
}

cv = KFold(n_splits=5, shuffle=True, random_state=42)
search = GridSearchCV(
    rf,
    param_grid=param_grid,
    scoring='neg_mean_squared_error',
    cv=cv,
    n_jobs=-1,
    verbose=2,
    error_score='raise'
)

print('Starting focused GridSearchCV...')
search.fit(X, y)

best = search.best_estimator_
print('Refined best params:', search.best_params_)
mean_cv_mse = search.best_score_
cv_rmse = (-mean_cv_mse) ** 0.5
print('Refined best CV RMSE (approx):', round(cv_rmse, 2))

joblib.dump(best, MODELS_DIR / 'region_rf_best_refined.joblib')
print('Saved refined best model to', MODELS_DIR / 'region_rf_best_refined.joblib')

cvres = pd.DataFrame(search.cv_results_)
cvres.to_csv(MODELS_DIR / 'region_grid_search_results.csv', index=False)
print('Saved refined search results to', MODELS_DIR / 'region_grid_search_results.csv')
