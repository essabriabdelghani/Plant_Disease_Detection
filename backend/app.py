
import streamlit as st
import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
import time

st.set_page_config(
    page_title="Smart Agri AI",
    page_icon="🌿",
    layout="wide",
    initial_sidebar_state="collapsed"
)

st.markdown("""
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
* { font-family: 'Inter', sans-serif; box-sizing: border-box; }
#MainMenu, footer, header, .stDeployButton { visibility: hidden; }
.main { background: #f4faf6; }
.block-container { padding: 0 !important; max-width: 100% !important; }

.hero {
    background: linear-gradient(135deg, #134e2a 0%, #1d7a45 60%, #27ae60 100%);
    padding: 56px 48px 48px;
    text-align: center;
    color: white;
}
.hero-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: rgba(255,255,255,0.15);
    border: 1px solid rgba(255,255,255,0.3);
    border-radius: 24px;
    padding: 6px 18px;
    font-size: 0.82rem;
    font-weight: 500;
    margin-bottom: 22px;
    letter-spacing: 0.3px;
}
.hero h1 {
    font-size: 2.8rem;
    font-weight: 800;
    margin: 0 0 12px;
    letter-spacing: -1.5px;
    line-height: 1.1;
}
.hero p {
    font-size: 1.05rem;
    opacity: 0.85;
    font-weight: 300;
    max-width: 560px;
    margin: 0 auto;
    line-height: 1.6;
}

.stats-row {
    background: white;
    display: flex;
    justify-content: center;
    gap: 0;
    border-bottom: 1px solid #e8f5ee;
    box-shadow: 0 2px 16px rgba(0,0,0,0.05);
}
.stat-box {
    text-align: center;
    padding: 20px 48px;
    border-right: 1px solid #e8f5ee;
}
.stat-box:last-child { border-right: none; }
.stat-num { font-size: 1.7rem; font-weight: 700; color: #1d7a45; line-height: 1; }
.stat-lbl { font-size: 0.75rem; color: #999; margin-top: 4px; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }

.lang-row {
    display: flex;
    justify-content: flex-end;
    padding: 12px 32px 0;
    gap: 8px;
}

.section-title {
    font-size: 0.7rem;
    font-weight: 700;
    color: #1d7a45;
    text-transform: uppercase;
    letter-spacing: 1.2px;
    margin-bottom: 10px;
}

.upload-card {
    background: white;
    border-radius: 20px;
    border: 1.5px dashed #27ae60;
    padding: 40px 24px;
    text-align: center;
    background: linear-gradient(135deg, #f0fbf5 0%, #e6f9ee 100%);
    transition: all 0.25s;
}
.upload-card:hover { border-color: #134e2a; background: linear-gradient(135deg, #e6f9ee, #d4f2e0); }
.upload-icon { font-size: 2.8rem; margin-bottom: 10px; }
.upload-title { font-size: 1.05rem; font-weight: 600; color: #134e2a; }
.upload-sub { font-size: 0.82rem; color: #999; margin-top: 5px; }

.result-box {
    border-radius: 18px;
    padding: 28px;
    text-align: center;
    margin-bottom: 16px;
}
.result-healthy { background: #edfaf3; border: 2px solid #27ae60; }
.result-diseased { background: #fff2f2; border: 2px solid #e74c3c; }
.result-emoji { font-size: 3.2rem; }
.result-label {
    font-size: 1.6rem;
    font-weight: 800;
    margin: 8px 0 4px;
    letter-spacing: -0.5px;
}
.healthy-label { color: #145a32; }
.diseased-label { color: #922b21; }
.result-class {
    font-size: 0.82rem;
    color: #777;
    background: rgba(0,0,0,0.05);
    border-radius: 8px;
    padding: 5px 12px;
    display: inline-block;
    margin: 6px 0 14px;
    font-family: monospace;
}
.conf-track {
    background: #e0e0e0;
    border-radius: 8px;
    height: 10px;
    overflow: hidden;
    margin: 4px 0 6px;
}
.conf-fill-h { height: 100%; background: linear-gradient(90deg, #27ae60, #58d68d); border-radius: 8px; }
.conf-fill-d { height: 100%; background: linear-gradient(90deg, #e74c3c, #f1948a); border-radius: 8px; }
.conf-label { font-size: 0.82rem; color: #888; display: flex; justify-content: space-between; }

.top3-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 9px 14px;
    background: #f8fdf9;
    border: 1px solid #d5eed9;
    border-radius: 10px;
    margin: 5px 0;
    font-size: 0.83rem;
}
.top3-name { color: #444; }
.top3-pct { font-weight: 700; color: #1d7a45; }

.info-block {
    background: white;
    border-left: 4px solid #27ae60;
    border-radius: 12px;
    padding: 18px 20px;
    margin: 12px 0;
    box-shadow: 0 2px 10px rgba(0,0,0,0.04);
}
.info-block h5 { color: #1d7a45; margin: 0 0 6px; font-size: 0.9rem; font-weight: 600; }
.info-block p { color: #555; margin: 0; font-size: 0.85rem; line-height: 1.6; }

.rec-row {
    display: flex;
    gap: 10px;
    align-items: flex-start;
    background: #f4fbf6;
    border-radius: 12px;
    padding: 14px 16px;
    margin: 6px 0;
    border: 1px solid #dff0e3;
}
.rec-icon { font-size: 1.4rem; flex-shrink: 0; margin-top: 1px; }
.rec-body { font-size: 0.84rem; color: #444; line-height: 1.5; }
.rec-body b { color: #134e2a; display: block; margin-bottom: 2px; font-size: 0.85rem; }

.placeholder-box {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 320px;
    color: #ccc;
    text-align: center;
    gap: 12px;
}
.placeholder-box .big-icon { font-size: 4rem; }
.placeholder-box .ph-title { font-size: 1rem; color: #aaa; font-weight: 500; }
.placeholder-box .ph-sub { font-size: 0.82rem; color: #ccc; }

.footer {
    text-align: center;
    padding: 32px;
    color: #bbb;
    font-size: 0.8rem;
    border-top: 1px solid #e8f5ee;
    margin-top: 32px;
    line-height: 1.8;
}
.footer span { color: #27ae60; font-weight: 500; }
</style>
""", unsafe_allow_html=True)

# --- SESSION STATE ---
if "lang" not in st.session_state:
    st.session_state.lang = "fr"

def t(fr, dr):
    return fr if st.session_state.lang == "fr" else dr

# --- DISEASE DATABASE ---
disease_db = {
    "Tomato_Early_blight": {
        "fr_desc": "Maladie fongique causée par Alternaria solani. Taches brunes concentriques sur les feuilles âgées.",
        "dr_desc": "مرض فطري يخلق بقعاً بنية دائرية على الأوراق القديمة.",
        "recs_fr": [("💧","Arrosage","À la base uniquement, évitez de mouiller le feuillage"),("🌿","Traitement","Fongicide cuivrique toutes les 7-10 jours"),("✂️","Taille","Retirez les feuilles infectées immédiatement")],
        "recs_dr": [("💧","السقي","اسقِ من الأسفل فقط"),("🌿","العلاج","مبيد فطري نحاسي كل 7-10 أيام"),("✂️","التقليم","أزل الأوراق المصابة فوراً")]
    },
    "Tomato_Late_blight": {
        "fr_desc": "Phytophthora infestans. Taches vert foncé à brunes avec duvet blanc sous les feuilles. Très contagieux.",
        "dr_desc": "فطر خطير يسبب بقعاً داكنة مع زغب أبيض. معدٍ جداً.",
        "recs_fr": [("💧","Arrosage","Réduire l'humidité, arroser le matin"),("🌿","Traitement","Fongicide systémique (Mancozeb) immédiatement"),("🔥","Urgence","Retirez et détruisez les plantes très infectées")],
        "recs_dr": [("💧","السقي","قلل الرطوبة، اسقِ صباحاً"),("🌿","العلاج","مبيد جهازي فوراً"),("🔥","طارئ","أزل وأتلف النباتات الشديدة الإصابة")]
    },
    "Potato___Early_blight": {
        "fr_desc": "Taches circulaires brunes sur feuilles de pomme de terre. Réduit significativement le rendement.",
        "dr_desc": "بقع دائرية بنية على أوراق البطاطس تقلل الإنتاج.",
        "recs_fr": [("💧","Arrosage","Irrigation régulière mais modérée"),("🌿","Traitement","Fongicide préventif dès les premiers symptômes"),("🌱","Prévention","Rotation des cultures chaque saison")],
        "recs_dr": [("💧","السقي","ري منتظم ومعتدل"),("🌿","العلاج","مبيد وقائي عند أول أعراض"),("🌱","الوقاية","دوران المحاصيل كل موسم")]
    },
    "healthy": {
        "fr_desc": "Votre plante est en parfaite santé ! Continuez vos bonnes pratiques agricoles.",
        "dr_desc": "نباتك بصحة ممتازة! واصل ممارساتك الزراعية الجيدة.",
        "recs_fr": [("✅","Arrosage","Maintenez un arrosage régulier et adapté"),("🌞","Ensoleillement","Assurez un bon ensoleillement quotidien"),("🌱","Fertilisation","Engrais équilibré toutes les 2-3 semaines")],
        "recs_dr": [("✅","السقي","حافظ على ري منتظم"),("🌞","الشمس","تأكد من تعرض جيد للشمس"),("🌱","التسميد","سماد متوازن كل 2-3 أسابيع")]
    }
}

def get_info(cls):
    for key in disease_db:
        if key.lower() in cls.lower():
            return disease_db[key]
    if "healthy" in cls.lower():
        return disease_db["healthy"]
    return {
        "fr_desc": "Maladie détectée. Consultez un agronome.",
        "dr_desc": "تم اكتشاف مرض. استشر خبيراً زراعياً.",
        "recs_fr": [("🌿","Traitement","Consultez un spécialiste local"),("✂️","Isolation","Isolez les plantes malades"),("💧","Arrosage","Réduisez l'arrosage temporairement")],
        "recs_dr": [("🌿","العلاج","استشر متخصصاً محلياً"),("✂️","العزل","عزل النباتات المريضة"),("💧","السقي","قلل الري مؤقتاً")]
    }

# --- MODEL ---
@st.cache_resource
def load_model():
    ckpt = torch.load("smart_agri_model.pth", map_location="cpu")
    classes = ckpt["classes"]
    m = models.efficientnet_b0(weights=None)
    m.classifier[1] = nn.Linear(m.classifier[1].in_features, len(classes))
    m.load_state_dict(ckpt["model_state_dict"])
    m.eval()
    return m, classes

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485,0.456,0.406],[0.229,0.224,0.225])
])

# --- HERO ---
st.markdown(f"""
<div class="hero">
    <div class="hero-badge">🤖 EfficientNet-B0 &nbsp;·&nbsp; 99.4% Accuracy &nbsp;·&nbsp; PlantVillage</div>
    <h1>🌿 {t("Smart Agriculture AI", "مساعد الفلاحة الذكي")}</h1>
    <p>{t("Détectez instantanément les maladies de vos plantes grâce à l'intelligence artificielle", "اكتشف أمراض نباتاتك فوراً بالذكاء الاصطناعي")}</p>
</div>
<div class="stats-row">
    <div class="stat-box"><div class="stat-num">99.4%</div><div class="stat-lbl">{t("Précision","الدقة")}</div></div>
    <div class="stat-box"><div class="stat-num">15</div><div class="stat-lbl">{t("Maladies","أمراض")}</div></div>
    <div class="stat-box"><div class="stat-num">20K+</div><div class="stat-lbl">{t("Images","صور")}</div></div>
    <div class="stat-box"><div class="stat-num">&lt;3s</div><div class="stat-lbl">{t("Analyse","تحليل")}</div></div>
</div>
""", unsafe_allow_html=True)

# --- LANG SWITCH ---
c1, c2, c3 = st.columns([6,1,1])
with c2:
    if st.button("🇫🇷 FR", use_container_width=True):
        st.session_state.lang = "fr"; st.rerun()
with c3:
    if st.button("🇲🇦 DR", use_container_width=True):
        st.session_state.lang = "dar"; st.rerun()

st.markdown("<br>", unsafe_allow_html=True)

# --- MAIN COLUMNS ---
left, right = st.columns([1,1], gap="large")

with left:
    st.markdown(f'<div class="section-title">📸 {t("Analyse d'image","تحليل الصورة")}</div>', unsafe_allow_html=True)
    st.markdown(f"""
    <div class="upload-card">
        <div class="upload-icon">🌱</div>
        <div class="upload-title">{t("Glissez votre image ici","اسحب صورتك هنا")}</div>
        <div class="upload-sub">{t("JPG · PNG · Feuille de plante","JPG · PNG · ورقة نبات")}</div>
    </div>
    """, unsafe_allow_html=True)

    uploaded = st.file_uploader(
        t("Choisir une image","اختر صورة"),
        type=["jpg","jpeg","png"],
        label_visibility="collapsed"
    )

    if uploaded:
        img = Image.open(uploaded).convert("RGB")
        st.image(img, use_container_width=True, caption=t("Image chargée","الصورة المحملة"))

with right:
    st.markdown(f'<div class="section-title">🔬 {t("Résultat du diagnostic","نتيجة التشخيص")}</div>', unsafe_allow_html=True)

    if uploaded:
        with st.spinner(t("Analyse en cours...","جاري التحليل...")):
            time.sleep(1.2)
            model, classes = load_model()
            tensor = transform(img).unsqueeze(0)
            with torch.no_grad():
                out = model(tensor)
                probs = torch.softmax(out, dim=1)[0]
                conf, pred = probs.max(0)
                cls_name = classes[pred.item()]
                conf_pct = int(conf.item() * 100)

        healthy = "healthy" in cls_name.lower()
        emoji = "✅" if healthy else "⚠️"
        label = t("Plante Saine","نبات سليم") if healthy else t("Maladie Détectée","تم اكتشاف مرض")
        box_cls = "result-healthy" if healthy else "result-diseased"
        lbl_cls = "healthy-label" if healthy else "diseased-label"
        fill_cls = "conf-fill-h" if healthy else "conf-fill-d"

        st.markdown(f"""
        <div class="result-box {box_cls}">
            <div class="result-emoji">{emoji}</div>
            <div class="result-label {lbl_cls}">{label}</div>
            <div class="result-class">{cls_name}</div>
            <div class="conf-track">
                <div class="{fill_cls}" style="width:{conf_pct}%"></div>
            </div>
            <div class="conf-label">
                <span>{t("Confiance","الثقة")}</span>
                <span style="font-weight:700;color:#333">{conf_pct}%</span>
            </div>
        </div>
        """, unsafe_allow_html=True)

        # TOP 3
        st.markdown(f'<div class="section-title" style="margin-top:16px">📊 {t("Top 3 prédictions","أفضل 3 توقعات")}</div>', unsafe_allow_html=True)
        top3 = probs.topk(3)
        for p, i in zip(top3.values, top3.indices):
            st.markdown(f"""
            <div class="top3-item">
                <span class="top3-name">{classes[i.item()]}</span>
                <span class="top3-pct">{int(p.item()*100)}%</span>
            </div>""", unsafe_allow_html=True)

        # INFO
        info = get_info(cls_name)
        desc = info["fr_desc"] if st.session_state.lang == "fr" else info["dr_desc"]
        recs = info["recs_fr"] if st.session_state.lang == "fr" else info["recs_dr"]

        st.markdown(f'<div class="section-title" style="margin-top:16px">📋 {t("Description","الوصف")}</div>', unsafe_allow_html=True)
        st.markdown(f'<div class="info-block"><p>{desc}</p></div>', unsafe_allow_html=True)

        st.markdown(f'<div class="section-title" style="margin-top:16px">🌱 {t("Recommandations","التوصيات")}</div>', unsafe_allow_html=True)
        for ic, ti, tx in recs:
            st.markdown(f"""
            <div class="rec-row">
                <div class="rec-icon">{ic}</div>
                <div class="rec-body"><b>{ti}</b>{tx}</div>
            </div>""", unsafe_allow_html=True)
    else:
        st.markdown(f"""
        <div class="placeholder-box">
            <div class="big-icon">🔬</div>
            <div class="ph-title">{t("En attente d'une image","في انتظار صورة")}</div>
            <div class="ph-sub">{t("Le diagnostic apparaîtra ici","سيظهر التشخيص هنا")}</div>
        </div>""", unsafe_allow_html=True)

# FOOTER
st.markdown(f"""
<div class="footer">
    🌿 <span>Smart Agriculture AI</span> · {t("Développé avec PyTorch & Streamlit","تم التطوير بـ PyTorch و Streamlit")}<br>
    <span>99.4% accuracy</span> · EfficientNet-B0 · PlantVillage Dataset · 2024
</div>""", unsafe_allow_html=True)
