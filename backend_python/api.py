from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import uvicorn
import os

app = FastAPI()

# Memuat model dan encoders yang sudah dilatih dari file .pkl
with open('model_nb_lengkap.pkl', 'rb') as f:
    model = pickle.load(f)
with open('encoders_lengkap.pkl', 'rb') as f:
    encoders = pickle.load(f)

# Mendefinisikan struktur data JSON yang akan diterima dari aplikasi Flutter
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

# Membuat endpoint API dengan metode POST
@app.post("/predict")
def predict_cancellation(data: InputData):
    try:
        # Mengubah data teks menjadi angka (encoding) menggunakan encoder yang sama saat training
        hotel_enc = encoders['hotel'].transform([data.hotel])[0]
        market_enc = encoders['market_segment'].transform([data.market_segment])[0]
        deposit_enc = encoders['deposit_type'].transform([data.deposit_type])[0]
        
        # Menyusun data secara berurutan untuk dimasukkan ke dalam model
        fitur = [[
            hotel_enc, 
            data.lead_time, 
            data.stays_in_week_nights, 
            data.adults,
            market_enc, 
            data.is_repeated_guest, 
            data.previous_cancellations,
            deposit_enc, 
            data.total_of_special_requests
        ]]
        
        # Melakukan prediksi
        prediksi = model.predict(fitur)
        
        # Menentukan hasil akhir (1 = Kemungkinan Batal, 0 = Kemungkinan Tidak Batal)
        hasil = "Resiko Batal Tinggi" if prediksi[0] == 1 else "Aman (Tamu akan datang)"
        
        return {"prediction": hasil}
    
    except Exception as e:
        # Mengembalikan pesan error jika terjadi kesalahan format atau input
        return {"prediction": f"Error di server: {str(e)}"}

# Konfigurasi untuk menjalankan server secara lokal (jika diperlukan)
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)