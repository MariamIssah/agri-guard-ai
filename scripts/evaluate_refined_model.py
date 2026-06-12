from pathlib import Path
import pandas as pd
from sklearn.model_selection import train_test_split, KFold, cross_val_score
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score, make_scorer
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
MODEL_PATH = Path('models') / 'region_rf_best_refined.joblib'

print('Using data dir:', DATA_DIR)
print('Loading model:', MODEL_PATH)

model = joblib.load(MODEL_PATH)

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

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

y_pred = model.predict(X_test)
rmse = mean_squared_error(y_test, y_pred) ** 0.5
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print('\nRefined model held-out test metrics:')
print('Test RMSE:', round(rmse, 2))
print('Test MAE:', round(mae, 2))
print('Test R2:', round(r2, 3))

cv = KFold(n_splits=5, shuffle=True, random_state=42)
rmse_scorer = make_scorer(lambda y_true, y_pred, **kwargs: mean_squared_error(y_true, y_pred) ** 0.5, greater_is_better=False)
mae_scorer = make_scorer(mean_absolute_error, greater_is_better=False)

cv_rmse = cross_val_score(model, X, y, cv=cv, scoring=rmse_scorer)
cv_mae = cross_val_score(model, X, y, cv=cv, scoring=mae_scorer)

print('\nRefined model cross-validated metrics:')
print('CV RMSE:', round(-cv_rmse.mean(), 2), '+/-', round(cv_rmse.std(), 2))
print('CV MAE:', round(-cv_mae.mean(), 2), '+/-', round(cv_mae.std(), 2))
