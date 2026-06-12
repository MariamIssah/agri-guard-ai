"""
Train a farm-level RandomForest model from synthetic farm samples.
Run: python scripts/train_farm_model.py
"""
from pathlib import Path
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import joblib


def find_repo_root():
    path = Path.cwd()
    for _ in range(8):
        if (path / 'README.md').exists():
            return path
        path = path.parent
    raise FileNotFoundError('Could not locate repository root')


def main():
    repo = find_repo_root()
    farms_path = repo / 'data' / 'farm_samples_generated.csv'
    if not farms_path.exists():
        print('Synthetic farm samples not found. Run scripts/restructure_data.py first.')
        return

    farms = pd.read_csv(farms_path)
    region_le = LabelEncoder()
    crop_le = LabelEncoder()
    farms['region_encoded'] = region_le.fit_transform(farms['region'].astype(str))
    farms['crop_encoded'] = crop_le.fit_transform(farms['crop'].astype(str))

    feature_cols = ['region_encoded', 'crop_encoded', 'farm_size_acres_est']
    X = farms[feature_cols].fillna(0)
    y = farms['predicted_quantity']

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    model = RandomForestRegressor(n_estimators=100, min_samples_split=5, min_samples_leaf=2, max_features=0.5, max_depth=30, random_state=42, n_jobs=-1)
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    rmse = mean_squared_error(y_test, y_pred) ** 0.5
    mae = mean_absolute_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)

    models_dir = repo / 'models'
    models_dir.mkdir(exist_ok=True)
    joblib.dump(model, models_dir / 'farm_level_model.joblib')
    joblib.dump(region_le, models_dir / 'farm_region_encoder.joblib')
    joblib.dump(crop_le, models_dir / 'farm_crop_encoder.joblib')

    print('Farm-level model metrics:')
    print(f'  RMSE: {rmse:.2f}')
    print(f'  MAE: {mae:.2f}')
    print(f'  R2: {r2:.3f}')
    print('Saved model and encoders to models/')


if __name__ == '__main__':
    main()
