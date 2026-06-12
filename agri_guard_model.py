from pathlib import Path
import joblib

REPO_ROOT = Path(__file__).resolve().parent
MODELS_DIR = REPO_ROOT / 'models'
FARM_MODEL_PATH = MODELS_DIR / 'farm_level_model.joblib'
FARM_REGION_ENCODER_PATH = MODELS_DIR / 'farm_region_encoder.joblib'
FARM_CROP_ENCODER_PATH = MODELS_DIR / 'farm_crop_encoder.joblib'

_farm_model = None
_region_encoder = None
_crop_encoder = None
_region_map = None
_crop_map = None


def _normalize_label(value):
    return str(value or '').strip().upper()


def _build_label_map(classes):
    return {_normalize_label(c): c for c in classes}


def load_farm_model():
    global _farm_model, _region_encoder, _crop_encoder, _region_map, _crop_map
    if _farm_model is not None and _region_encoder is not None and _crop_encoder is not None:
        return _farm_model, _region_encoder, _crop_encoder

    if not FARM_MODEL_PATH.exists() or not FARM_REGION_ENCODER_PATH.exists() or not FARM_CROP_ENCODER_PATH.exists():
        raise FileNotFoundError('Missing model or encoder files in models/. Run scripts/train_farm_model.py first.')

    _farm_model = joblib.load(FARM_MODEL_PATH)
    _region_encoder = joblib.load(FARM_REGION_ENCODER_PATH)
    _crop_encoder = joblib.load(FARM_CROP_ENCODER_PATH)
    _region_map = _build_label_map(_region_encoder.classes_)
    _crop_map = _build_label_map(_crop_encoder.classes_)
    return _farm_model, _region_encoder, _crop_encoder


def get_farm_regions():
    _, region_encoder, _ = load_farm_model()
    normalized = sorted({_normalize_label(region) for region in region_encoder.classes_})
    return [region.title() for region in normalized]


def get_farm_crops():
    _, _, crop_encoder = load_farm_model()
    normalized = sorted({_normalize_label(crop) for crop in crop_encoder.classes_})
    return [crop.title() for crop in normalized]


def _resolve_region(region_value):
    _, _, _ = load_farm_model()
    normalized = _normalize_label(region_value)
    if normalized in _region_map:
        return _region_map[normalized]
    raise ValueError(f"Unknown region '{region_value}'. Valid regions: {', '.join(get_farm_regions())}")


def _resolve_crop(crop_value):
    _, _, _ = load_farm_model()
    normalized = _normalize_label(crop_value)
    if normalized in _crop_map:
        return _crop_map[normalized]
    raise ValueError(f"Unknown crop '{crop_value}'. Valid crops: {', '.join(get_farm_crops())}")


def predict_farm_quantity(region, crop, farm_size):
    model, _, _ = load_farm_model()
    region_label = _resolve_region(region)
    crop_label = _resolve_crop(crop)
    region_encoded = _region_encoder.transform([region_label])[0]
    crop_encoded = _crop_encoder.transform([crop_label])[0]
    X = [[region_encoded, crop_encoded, float(farm_size)]]
    prediction = model.predict(X)
    return float(prediction[0])
