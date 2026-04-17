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