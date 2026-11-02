import pandas as pd
from sklearn.naive_bayes import GaussianNB
from sklearn.preprocessing import LabelEncoder
import pickle

print("Membaca dataset dan memproses fitur baru...")
df = pd.read_csv('hotels.csv')

# 9 Fitur pilihan kita
features = [
    'hotel', 'lead_time', 'stays_in_week_nights', 'adults', 
    'market_segment', 'is_repeated_guest', 'previous_cancellations', 
    'deposit_type', 'total_of_special_requests'
]

X = df[features].copy()
y = df['is_canceled']

# Karena ada 3 kolom teks, kita buat encoder untuk masing-masing
categorical_cols = ['hotel', 'market_segment', 'deposit_type']
encoders = {}

for col in categorical_cols:
    le = LabelEncoder()
    # Pastikan data diubah ke string untuk menghindari error
    X[col] = le.fit_transform(X[col].astype(str))
    encoders[col] = le

# Latih model Naive Bayes
model = GaussianNB()
model.fit(X, y)

# Simpan model dan KUMPULAN encoder ke file .pkl
with open('model_nb_lengkap.pkl', 'wb') as f:
    pickle.dump(model, f)
with open('encoders_lengkap.pkl', 'wb') as f:
    pickle.dump(encoders, f)

print("Model lengkap berhasil dilatih!")