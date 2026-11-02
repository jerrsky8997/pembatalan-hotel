from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import uvicorn

app = FastAPI()

# Muat model dan encoders baru
with open('model_nb_lengkap.pkl', 'rb') as f:
    model = pickle.load(f)
with open('encoders_lengkap.pkl', 'rb') as f:
    encoders = pickle.load(f)

# Format JSON dari Flutter sekarang lebih panjang
class InputData(BaseModel):
    hotel: str
    lead_time: int
    stays_in_week_nights: int
    adults: int
    market_segment: str
    is_repeated_guest: int
    previous_cancellations: int
    deposit_type: str
    total_of_special_requests: int

@app.post("/predict")
def predict_cancellation(data: InputData):
    try:
        # Ubah teks input Flutter ke angka pakai encoder yang sesuai
        hotel_enc = encoders['hotel'].transform([data.hotel])[0]
        market_enc = encoders['market_segment'].transform([data.market_segment])[0]
        deposit_enc = encoders['deposit_type'].transform([data.deposit_type])[0]
        
        # Susun data untuk diprediksi
        fitur = [[
            hotel_enc, data.lead_time, data.stays_in_week_nights, data.adults,
            market_enc, data.is_repeated_guest, data.previous_cancellations,
            deposit_enc, data.total_of_special_requests
        ]]
        
        prediksi = model.predict(fitur)
        hasil = "Resiko Batal Tinggi" if prediksi[0] == 1 else "Aman (Tamu akan datang)"
        return {"prediction": hasil}
    
    except Exception as e:
        return {"prediction": f"Error di server: {str(e)}"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)