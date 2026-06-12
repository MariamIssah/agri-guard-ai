"""
Agri-Guard AI - Streamlit Web Interface MVP
Simple web UI for crop harvest quantity and location prediction
"""

import streamlit as st
import pandas as pd
from datetime import datetime

from agri_guard_model import get_farm_crops, get_farm_regions, predict_farm_quantity, load_farm_model

st.set_page_config(
    page_title="Agri-Guard AI - Farm Harvest Predictor",
    page_icon="🌾",
    layout="wide"
)

st.title("🌾 Agri-Guard AI: Farm Harvest Prediction")
st.markdown("Use farm region, crop type, and farm size to estimate expected harvest quantity.")

# Sidebar for navigation
st.sidebar.title("Navigation")
page = st.sidebar.radio("Select Page", ["Prediction", "Model Info", "About"])

try:
    load_farm_model()
except Exception as e:
    st.sidebar.error(f"Model load error: {e}")

if page == "Prediction":
    st.header("Predict Harvest Quantity")
    st.markdown("Select a region and crop, then enter the farm size to generate a model prediction.")

    crop_type = st.selectbox("Crop Type", get_farm_crops())
    region = st.selectbox("Farm Region", get_farm_regions())
    farm_size = st.number_input("Farm Size (acres)", value=2.0, min_value=0.1, step=0.1)
    submit = st.button("🔮 Predict Harvest Quantity", key="predict_btn", use_container_width=True)

    if submit:
        try:
            predicted_quantity = predict_farm_quantity(region, crop_type, farm_size)
            st.success("Prediction Complete!")

            result_col1, result_col2, result_col3 = st.columns(3)
            with result_col1:
                st.metric("Predicted Quantity", f"{predicted_quantity:,.1f} units")
            with result_col2:
                st.metric("Crop", crop_type)
            with result_col3:
                st.metric("Region", region)

            st.subheader("Input Summary")
            df_input = pd.DataFrame(
                {
                    "Feature": ["Crop Type", "Region", "Farm Size (acres)"],
                    "Value": [crop_type, region, farm_size],
                }
            )
            st.dataframe(df_input, use_container_width=True)

            st.subheader("Model Notes")
            st.write("This prediction uses the farm-level RandomForest model trained on region, crop, and farm size.")

        except Exception as exc:
            st.error(f"Prediction failed: {exc}")

elif page == "Model Info":
    st.header("Model Architecture & Performance")

    info_col1, info_col2 = st.columns(2)
    with info_col1:
        st.subheader("Model Details")
        st.write("**Type:** RandomForestRegressor")
        st.write("**Features:** region_encoded, crop_encoded, farm_size_acres_est")
        st.write("**Target:** Harvest Quantity")
        st.write("**Trained on:** farm_samples_generated.csv")

    with info_col2:
        st.subheader("Available Inputs")
        st.write("**Regions:**")
        st.write(", ".join(get_farm_regions()))
        st.write("**Crops:**")
        st.write(", ".join(get_farm_crops()))

    st.subheader("Data Engineering")
    st.write(
        "- Encoded farm region and crop labels"
        "\n- Used farm size as the main continuous predictor"
        "\n- Trained a RandomForestRegressor with optimized tree and split parameters"
    )

elif page == "About":
    st.header("About Agri-Guard AI")
    st.write(
        "Agri-Guard AI is an agricultural decision support prototype that estimates farm harvest quantities "
        "from historical and synthetic farm-level data."
    )
    st.write(
        "The current Streamlit app uses a farm-level RandomForest model with region, crop, and farm size inputs. "
        "The architecture is designed to be extended later with weather, soil, and production feature inputs."
    )

    st.subheader("Quick Links")
    col1, col2, col3 = st.columns(3)
    with col1:
        st.write("[📖 GitHub Repo](https://github.com/yourusername/agri-guard-ai)")
    with col2:
        st.write("[📊 Model Notebook](https://github.com/yourusername/agri-guard-ai/blob/main/notebooks/agri_guard_analysis.ipynb)")
    with col3:
        st.write("[🔌 API Docs](http://localhost:5000/apidocs)")

# Footer
st.markdown("---")
st.markdown(f"Agri-Guard AI MVP | Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
