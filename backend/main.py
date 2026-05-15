from flask import Flask, request, jsonify
from flask_cors import CORS
import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
import io


app = Flask(__name__)
CORS(app)

# ── LOAD MODEL ──
print("Loading model...")
def load_model():
    ckpt = torch.load("smart_agri_model.pth", map_location="cpu")
    classes = ckpt["classes"]
    m = models.efficientnet_b0(weights=None)
    m.classifier[1] = nn.Linear(m.classifier[1].in_features, len(classes))
    m.load_state_dict(ckpt["model_state_dict"])
    m.eval()
    return m, classes

model, classes = load_model()

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485,0.456,0.406],[0.229,0.224,0.225])
])

disease_info = {
    "Tomato_Early_blight": {
        "description": "Maladie fongique causée par Alternaria solani.",
        "recommendations": ["Arrosez à la base","Fongicide cuivrique 7-10 jours","Retirez feuilles infectées"],
        "severity": "moderate"
    },
    "Tomato_Late_blight": {
        "description": "Phytophthora infestans. Très contagieux.",
        "recommendations": ["Réduire humidité","Fongicide systémique immédiatement","Détruisez plantes infectées"],
        "severity": "high"
    },
    "Tomato_Bacterial_spot": {
        "description": "Bactérie Xanthomonas. Taches brunes avec halo jaune.",
        "recommendations": ["Évitez arrosage par aspersion","Traitement cuivre","Rotation des cultures"],
        "severity": "moderate"
    },
    "Potato___Early_blight": {
        "description": "Taches circulaires brunes sur pomme de terre.",
        "recommendations": ["Irrigation modérée","Fongicide préventif","Rotation des cultures"],
        "severity": "moderate"
    },
    "Potato___Late_blight": {
        "description": "Phytophthora infestans sur pomme de terre.",
        "recommendations": ["Fongicide immédiat","Éliminez tubercules infectés","Contrôlez humidité"],
        "severity": "high"
    },
    "healthy": {
        "description": "Plante en parfaite santé!",
        "recommendations": ["Arrosage régulier","Bon ensoleillement","Fertilisation équilibrée"],
        "severity": "none"
    }
}

def get_info(cls):
    for key in disease_info:
        if key.lower() in cls.lower():
            return disease_info[key]
    if "healthy" in cls.lower():
        return disease_info["healthy"]
    return {
        "description": "Maladie détectée. Consultez un agronome.",
        "recommendations": ["Consultez un spécialiste","Isolez les plantes","Réduisez arrosage"],
        "severity": "unknown"
    }

# ── ROUTES ──
@app.route("/")
def root():
    return jsonify({"message": "Smart Agriculture AI API", "status": "running"})

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    img = Image.open(io.BytesIO(file.read())).convert("RGB")

    tensor = transform(img).unsqueeze(0)
    with torch.inference_mode():
        out = model(tensor)
        probs = torch.softmax(out, dim=1)[0]
        top3 = probs.topk(3)

    predicted_class = classes[top3.indices[0].item()]
    confidence = float(top3.values[0].item())
    info = get_info(predicted_class)

    return jsonify({
        "predicted_class": predicted_class,
        "confidence": round(confidence * 100, 1),
        "is_healthy": "healthy" in predicted_class.lower(),
        "top3": [
            {"class": classes[i.item()], "confidence": round(float(p.item()) * 100, 1)}
            for p, i in zip(top3.values, top3.indices)
        ],
        "description": info["description"],
        "recommendations": info["recommendations"],
        "severity": info["severity"]
    })

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=8000)