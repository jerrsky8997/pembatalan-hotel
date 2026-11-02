import pandas as pd
from sklearn.naive_bayes import GaussianNB
from sklearn.preprocessing import LabelEncoder
import pickle

print("Memulai proses training...")
print("Membaca dataset hotels.csv...")
# Membaca dataset
df = pd.read_csv('hotels.csv')

# 9 Fitur yang akan digunakan sebagai bahan prediksi (X)
features = [
    'hotel', 
    'lead_time', 
    'stays_in_week_nights', 
    'adults', 
    'market_segment', 
    'is_repeated_guest', 
    'previous_cancellations', 
    'deposit_type', 
    'total_of_special_requests'
]

print("Memilih fitur dan membersihkan data...")
# Mengambil kolom fitur (X) dan target pembatalan (y)
X = df[features].copy()
y = df['is_canceled']

# Membersihkan baris yang mungkin memiliki data kosong (NaN) pada fitur yang dipilih
X = X.dropna()
y = y.loc[X.index]

# Daftar kolom yang berisi teks dan perlu diubah menjadi angka
categorical_cols = ['hotel', 'market_segment', 'deposit_type']
encoders = {}

print("Mengubah data teks menjadi angka (Encoding)...")
for col in categorical_cols:
    le = LabelEncoder()
    # Mengubah tipe data menjadi string untuk menghindari error, lalu di-encode
    X[col] = le.fit_transform(X[col].astype(str))
    # Menyimpan encoder ke dalam dictionary agar bisa dipakai di API nanti
    encoders[col] = le

print("Melatih model Naive Bayes...")
# Inisialisasi dan melatih model Naive Bayes
model = GaussianNB()
model.fit(X, y)

print("Menyimpan model dan encoders ke file .pkl...")
# Menyimpan model yang sudah dilatih
with open('model_nb_lengkap.pkl', 'wb') as f:
    pickle.dump(model, f)

# Menyimpan kumpulan label encoder
with open('encoders_lengkap.pkl', 'wb') as f:
    pickle.dump(encoders, f)

print("Selesai! File model_nb_lengkap.pkl dan encoders_lengkap.pkl berhasil dibuat.")