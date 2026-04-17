#!/bin/bash
set -e  # Exit on any error — helps catch failures early

apt-get update -y
apt-get install python3-pip python3-venv -y

mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# Write app.py inline — no SCP needed
cat > app.py << 'EOF'
from flask import Flask, request, jsonify
import joblib
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # IMPORTANT for S3 frontend

model = joblib.load("model.pkl")
vectorizer = joblib.load("vectorizer.pkl")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    text = data["text"]

    X = vectorizer.transform([text])
    pred = model.predict(X)[0]

    return jsonify({
        "prediction": str(pred)
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# Write requirements.txt inline
cat > requirements.txt << 'EOF'
flask
flask-cors
joblib
scikit-learn
nltk
pandas
EOF

# Use a venv to avoid Ubuntu PEP 668 restrictions
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run the app as ubuntu user, not root
chown -R ubuntu:ubuntu /home/ubuntu/app

nohup venv/bin/python app.py > app.log 2>&1 &