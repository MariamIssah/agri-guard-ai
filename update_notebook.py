import json
from pathlib import Path

p = Path('notebooks/agri_guard_analysis.ipynb')
nb = json.loads(p.read_text(encoding='utf-8'))

summary_md = {
    'cell_type': 'markdown',
    'metadata': {},
    'source': [
        '## 4a. Data Engineering and Feature Insight\n',
        '\n',
        'The data cleaning process includes:\n',
        '- removing title rows, repeated header rows, and footer totals,\n',
        '- converting text crop values to numeric values,\n',
        '- replacing missing crop values with 0 for modeling,\n',
        '- dropping empty columns after cleanup.\n',
        '\n',
        'This section also includes correlation and distribution visuals for the key crop features used in modeling.\n'
    ]
}

summary_code = {
    'cell_type': 'code',
    'execution_count': None,
    'metadata': {},
    'outputs': [],
    'source': [
        'import seaborn as sns\n',
        'import numpy as np\n',
        '\n',
        '# Use the cleaned region data for correlation visuals\n',
        'clean_regions = plot_regions.copy()\n',
        'corr_data = clean_regions[crop_columns].astype(float)\n',
        '\n',
        'plt.figure(figsize=(12, 10))\n',
        'sns.heatmap(corr_data.corr(), annot=True, fmt=".2f", cmap="coolwarm", cbar=True)\n',
        'plt.title("Crop Production Correlation Matrix")\n',
        'plt.tight_layout()\n',
        'plt.show()\n',
        '\n',
        'plt.figure(figsize=(14, 6))\n',
        'corr_with_maize = corr_data.corr()["MAIZE"].sort_values(ascending=False)\n',
        'corr_with_maize = corr_with_maize.drop("MAIZE")\n',
        'corr_with_maize.plot(kind="bar", color="tab:blue")\n',
        'plt.title("Correlation of Crop Features with MAIZE Production")\n',
        'plt.xlabel("Feature")\n',
        'plt.ylabel("Pearson correlation")\n',
        'plt.xticks(rotation=45, ha="right")\n',
        'plt.tight_layout()\n',
        'plt.show()\n'
    ]
}

arch_md = {
    'cell_type': 'markdown',
    'metadata': {},
    'source': [
        '## 5b. Model Architecture\n',
        '\n',
        'The project uses two regression approaches:\n',
        '\n',
        '- **Region-level model:** `LinearRegression` from scikit-learn. This is a linear regression model that learns a weighted sum of crop feature values to predict `MAIZE`. It uses ordinary least squares with no hidden layers or activation functions.\n',
        '- **District-level model:** `RandomForestRegressor` from scikit-learn. This ensemble of 100 decision trees averages predictions to reduce variance and improve generalization. Each tree is built with bootstrap sampling and MSE-based split selection.\n',
        '\n',
        'Training details:\n',
        '- features: crop production values such as `RICE`, `CASSAVA`, `YAM`, `COCOYAM`, `PLANTAIN`, and other cleaned crop columns.\n',
        '- target: `MAIZE` production.\n',
        '- optimization: ordinary least squares for linear regression; bootstrap tree averaging for the random forest.\n',
        '- evaluation: RMSE, MAE, and R² on held-out test sets, plus cross-validation for the region model.\n'
    ]
}

deploy_md = {
    'cell_type': 'markdown',
    'metadata': {},
    'source': [
        '## 9. Deployment Considerations\n',
        '\n',
        'This prototype is currently implemented as a notebook-based MVP. The next step is to convert it to a lightweight web or API interface.\n',
        '\n',
        '- Build a web form or UI where users enter crop production values and receive a predicted `MAIZE` output.\n',
        '- Create an API endpoint such as `/predict` that accepts JSON input and returns a prediction response.\n',
        '- Use Flask or Streamlit to create the MVP interface, and host it on Azure App Service, Heroku, or Render.\n',
        '\n',
        'Example API contract:\n',
        '- POST `/predict`\n',
        '  - request body: `{"RICE": 4300, "CASSAVA": 122000, "YAM": 2800, ...}`\n',
        '  - response: `{"predicted_MAIZE": 97850.3}`\n',
        '\n',
        'UI mockup idea:\n',
        '- input sliders or numeric fields for each crop,\n',
        '- a "Predict MAIZE" button,\n',
        '- a result card showing `predicted_MAIZE`,\n',
        '- and a summary panel showing RMSE / R².\n'
    ]
}

# Insert new cells
nb['cells'].insert(11, summary_md)
nb['cells'].insert(12, summary_code)
nb['cells'].insert(15, arch_md)
nb['cells'][19] = deploy_md

# Update region model metrics
code14 = nb['cells'][14]
if 'mean_absolute_error' not in ''.join(code14['source']):
    for i, line in enumerate(code14['source']):
        if 'from sklearn.metrics import mean_squared_error, r2_score' in line:
            code14['source'][i] = 'from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error\n'
    for i, line in enumerate(code14['source']):
        if line.strip() == 'rmse = mse ** 0.5':
            code14['source'].insert(i+1, 'mae = mean_absolute_error(y_test, y_pred)\n')
            code14['source'].insert(i+2, "print('Test MAE:', round(mae, 2))\n")
            break

# Update district model metrics
code16 = nb['cells'][16]
if 'mean_absolute_error' not in ''.join(code16['source']):
    for i, line in enumerate(code16['source']):
        if 'from sklearn.metrics import mean_squared_error, r2_score' in line:
            code16['source'][i] = 'from sklearn.metrics import mean_squared_error, r2_score, mean_absolute_error\n'
    for i, line in enumerate(code16['source']):
        if line.strip() == 'r2 = r2_score(y_test, y_pred)':
            code16['source'].insert(i+1, 'mae = mean_absolute_error(y_test, y_pred)\n')
            code16['source'].insert(i+2, "print('District test MAE:', round(mae, 2))\n")
            break

p.write_text(json.dumps(nb, indent=1), encoding='utf-8')
print('updated notebook cells')
