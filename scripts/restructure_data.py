"""
Restructure region CSVs into availability and synthetic farm samples.
Generates:
 - data/availability_by_region.csv
 - data/farm_samples_generated.csv

Run: python scripts/restructure_data.py
"""
from pathlib import Path
import pandas as pd
import numpy as np


def find_repo_root():
    path = Path.cwd()
    for _ in range(8):
        if (path / 'README.md').exists():
            return path
        path = path.parent
    raise FileNotFoundError('Could not locate repository root')


def main():
    repo = find_repo_root()
    data_dir = repo / 'data' / 'agri_guard_csvs'
    regions_path = data_dir / 'REGIONS.csv'

    if not regions_path.exists():
        print(f'Error: {regions_path} not found')
        return

    print('Loading regions CSV (header=1)')
    regions = pd.read_csv(regions_path, header=1)

    # Clean regions similar to notebook
    region_data = regions.copy()
    valid_region = region_data['REGION'].astype(str).str.strip()
    invalid_mask = (
        valid_region.isna()
        | valid_region.eq('')
        | valid_region.str.contains(r'PRODUCTION|TOTAL|REGION', case=False, na=False)
    )
    region_data = region_data[~invalid_mask].copy()

    crop_cols = [col for col in region_data.columns if col != 'REGION']
    for col in crop_cols:
        region_data[col] = pd.to_numeric(
            region_data[col].astype(str).str.replace(',', '', regex=False).str.strip(),
            errors='coerce'
        )
    region_data = region_data.fillna(0)

    # Build availability by region DataFrame
    avail_rows = []
    for _, row in region_data.iterrows():
        region_name = row['REGION'] if 'REGION' in row else 'Unknown'
        for crop in crop_cols:
            qty = float(row[crop]) if pd.notna(row[crop]) else 0.0
            if qty > 0:
                avail_rows.append({'region': region_name, 'crop': crop, 'quantity': qty})

    availability_df = pd.DataFrame(avail_rows)
    out_dir = repo / 'data'
    out_dir.mkdir(parents=True, exist_ok=True)
    avail_path = out_dir / 'availability_by_region.csv'
    availability_df.to_csv(avail_path, index=False)
    print(f'Wrote availability by region: {avail_path} ({len(availability_df)} rows)')

    # Create synthetic farm samples by splitting region quantity into N farms
    farm_rows = []
    DEFAULT_FARMS_PER_REGION = 5
    rng = np.random.default_rng(42)
    for _, row in region_data.iterrows():
        region_name = row['REGION'] if 'REGION' in row else 'Unknown'
        for crop in crop_cols:
            total_qty = float(row[crop]) if pd.notna(row[crop]) else 0.0
            if total_qty <= 0:
                continue
            n = DEFAULT_FARMS_PER_REGION
            # split with slight randomness so farms vary
            splits = rng.random(n)
            splits = splits / splits.sum()
            for i, share in enumerate(splits, start=1):
                farm_qty = float(total_qty * share)
                # rough farm size heuristic (units per acre) — configurable later
                farm_size = max(0.5, round(farm_qty / 1000.0, 2))
                farm_rows.append({
                    'region': region_name,
                    'farm_id': f"{region_name.replace(' ','_')}_farm_{i}",
                    'crop': crop,
                    'predicted_quantity': round(farm_qty, 2),
                    'farm_size_acres_est': farm_size,
                    'source': 'synthetic_split'
                })

    farm_df = pd.DataFrame(farm_rows)
    farms_path = out_dir / 'farm_samples_generated.csv'
    farm_df.to_csv(farms_path, index=False)
    print(f'Wrote synthetic farm samples: {farms_path} ({len(farm_df)} rows)')

    print('\nSummary:')
    print(f'  Regions loaded: {len(region_data)}')
    print(f'  Crop columns: {crop_cols}')
    print(f'  Availability rows: {len(availability_df)}')
    print(f'  Synthetic farm rows: {len(farm_df)}')


if __name__ == '__main__':
    main()
