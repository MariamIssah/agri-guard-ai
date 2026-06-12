"""
Agri-Guard AI - Flask API for farm-level harvest prediction
MVP deployment endpoint with Swagger documentation
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from flasgger import Swagger

from agri_guard_model import load_farm_model, get_farm_crops, get_farm_regions, predict_farm_quantity

app = Flask(__name__)
CORS(app)
swagger = Swagger(app)

try:
    load_farm_model()
except Exception:
    pass

model_info = {
    'name': 'RandomForestRegressor',
    'features': ['region', 'crop_type', 'farm_size_acres_est'],
    'target': 'Harvest Quantity',
    'description': 'Farm-level model trained on encoded region and crop labels.',
    'test_rmse': 'See notebook for exact metrics',
    'test_r2': 'See notebook for exact metrics'
}

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'service': 'Agri-Guard AI API'}), 200

@app.route('/api/v1/predict', methods=['POST'])
def predict():
    """
    Predict harvest quantity for a farm given region, crop, and size.
    ---
    parameters:
      - name: body
        in: body
        required: true
        schema:
          type: object
          properties:
            crop_type:
              type: string
              description: Crop type for prediction
            region:
              type: string
              description: Farm region for prediction
            farm_size:
              type: number
              description: Farm size in acres
          required:
            - crop_type
            - region
            - farm_size
    responses:
      200:
        description: Successful prediction
        schema:
          type: object
          properties:
            predicted_quantity:
              type: number
            crop_type:
              type: string
            region:
              type: string
            farm_size:
              type: number
            message:
              type: string
      400:
        description: Invalid input
    """
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No JSON payload provided'}), 400

        required_fields = ['crop_type', 'region', 'farm_size']
        missing = [f for f in required_fields if f not in data]
        if missing:
            return jsonify({'error': f'Missing required fields: {missing}'}), 400

        crop_type = str(data.get('crop_type', '')).strip()
        region = str(data.get('region', '')).strip()
        farm_size = float(data.get('farm_size', 0))

        predicted_quantity = predict_farm_quantity(region, crop_type, farm_size)

        return jsonify({
            'predicted_quantity': round(predicted_quantity, 2),
            'crop_type': crop_type,
            'region': region,
            'farm_size': farm_size,
            'message': 'Prediction generated from farm-level model'
        }), 200

    except ValueError as err:
        return jsonify({'error': str(err)}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/model/info', methods=['GET'])
def model_info_endpoint():
    """
    Get model architecture and performance information
    ---
    responses:
      200:
        description: Model information
        schema:
          type: object
    """
    return jsonify(model_info), 200

@app.route('/api/v1/regions', methods=['GET'])
def list_regions():
    """Get the list of valid farm regions for prediction"""
    return jsonify({'regions': get_farm_regions()}), 200

@app.route('/api/v1/crops', methods=['GET'])
def list_crops():
    """Get the list of valid crop types for prediction"""
    return jsonify({'crops': get_farm_crops()}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
