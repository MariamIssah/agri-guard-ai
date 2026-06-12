from pathlib import Path
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, KFold, cross_val_score
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error, make_scorer


def find_data_dir():
    path = Path.cwd()
    for _ in range(8):
        candidate = path / 'data' / 'agri_guard_csvs'
        if candidate.exists():
            return candidate
        path = path.parent
    raise FileNotFoundError('Could not locate data/agri_guard_csvs from cwd: ' + str(Path.cwd()))


DATA_DIR = find_data_dir()
DISTRICTS_PATH = DATA_DIR / 'DISTRICTS.csv'
REGIONS_PATH = DATA_DIR / 'REGIONS.csv'
COMPARISON_PATH = DATA_DIR / 'COMPARISION.csv'

print('Using data dir:', DATA_DIR)

# Load
regions = pd.read_csv(REGIONS_PATH, header=1)
districts = pd.read_csv(DISTRICTS_PATH, header=1)

# Prepare region model (clean similarly to notebook)
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

region_model = region_model.dropna(subset=['MAIZE'])
region_model = region_model.fillna(0)

region_names = region_model['REGION'].copy()
region_model = region_model.drop(columns=['REGION'])

X = region_model.drop(columns=['MAIZE'])
y = region_model['MAIZE']

# Train/test split + RandomForest for region
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
region_model_rf = RandomForestRegressor(n_estimators=200, random_state=42)
region_model_rf.fit(X_train, y_train)

y_pred = region_model_rf.predict(X_test)
rmse = mean_squared_error(y_test, y_pred) ** 0.5
r2 = r2_score(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)

print('\n== Region model (RandomForest) test metrics ==')
print('Test RMSE:', round(rmse, 2))
print('Test R2:', round(r2, 3))
print('Test MAE:', round(mae, 2))

# Cross-validation using safe scorer
def rmse_func(y_true, y_pred, **kwargs):
    return mean_squared_error(y_true, y_pred) ** 0.5

cv = KFold(n_splits=5, shuffle=True, random_state=42)
rmse_scorer = make_scorer(rmse_func, greater_is_better=False)
mae_scorer = make_scorer(mean_absolute_error, greater_is_better=False)

cv_rmse = cross_val_score(region_model_rf, X, y, cv=cv, scoring=rmse_scorer)
cv_mae = cross_val_score(region_model_rf, X, y, cv=cv, scoring=mae_scorer)

print('Cross-validated RMSE:', round(-cv_rmse.mean(), 2), '+/-', round(cv_rmse.std(), 2))
print('Cross-validated MAE:', round(-cv_mae.mean(), 2), '+/-', round(cv_mae.std(), 2))

# Feature importances
if hasattr(region_model_rf, 'feature_importances_'):
    fi = pd.Series(region_model_rf.feature_importances_, index=X.columns).sort_values(ascending=False)
    print('\nTop region features:')
    print(fi.head(10).to_string())

# District model
print('\n== District model (RandomForest) ==')
district_model = districts.copy()
valid_district = district_model['DISTRICTS'].astype(str).str.strip()
invalid_mask = (
    valid_district.isna()
    | valid_district.eq('')
    | valid_district.str.contains(r'PRODUCTION|TOTAL|AVERAGE|DISTRICTS', case=False, na=False)
)
district_model = district_model[~invalid_mask].copy()

# Drop unnamed trailing columns
district_model = district_model.drop(columns=[col for col in district_model.columns if col.startswith('Unnamed')])

numeric_cols = [col for col in district_model.columns if col != 'DISTRICTS']
for col in numeric_cols:
    district_model[col] = pd.to_numeric(
        district_model[col].astype(str).str.replace(',', '', regex=False).str.strip().replace({'-': None, '': None, 'nan': None}),
        errors='coerce'
    )

district_model = district_model.dropna(subset=['MAIZE'])
empty_numeric_cols = [col for col in district_model.columns if col != 'DISTRICTS' and col != 'MAIZE' and district_model[col].isna().all()]
if empty_numeric_cols:
    district_model = district_model.drop(columns=empty_numeric_cols)

# Fill missing with 0
district_model = district_model.fillna(0)

district_names = district_model['DISTRICTS'].copy()
district_model = district_model.drop(columns=['DISTRICTS'])

X = district_model.drop(columns=['MAIZE'])
y = district_model['MAIZE']
for col in X.columns:
    X[col] = pd.to_numeric(X[col], errors='coerce').fillna(0)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
dist_rf = RandomForestRegressor(random_state=42, n_estimators=200)
dist_rf.fit(X_train, y_train)

y_pred = dist_rf.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
rmse = mse ** 0.5
r2 = r2_score(y_test, y_pred)

print('District test RMSE:', round(rmse, 2))
print('District test R2:', round(r2, 3))

if hasattr(dist_rf, 'feature_importances_'):
    fi = pd.Series(dist_rf.feature_importances_, index=X.columns).sort_values(ascending=False)
    print('\nTop district features:')
    print(fi.head(10).to_string())
