# PHARMACEUTICAL TABLET SHAPE DETECTION


## ⭐ Project Summary
This project implements a computer vision pipeline in MATLAB to detect **round (circular)** and **oval** pharmaceutical tablets from images.  
The goal is to analyze tablet shapes for quality control, detecting deviations in geometry that may indicate manufacturing defects.

The project provides two main processing scripts:
- `deteccio_rodones.m` → detects circular tablets  
- `deteccio_ovalades.m` → detects oval tablets  

Both scripts operate on real images contained in the `Fotos/` directory.

This project was developed as an academic exercise in image processing, focusing on segmentation, edge detection, morphological operations, and shape-based analysis.

---

## 🧩 Technologies & Skills Demonstrated

### **Computer Vision**
- Tablet segmentation  
- Edge and contour detection  
- Morphological cleaning  
- Mask generation  

### **Image Processing Techniques**
- Grayscale conversion  
- Thresholding  
- Regionprops-based shape analysis  
- Aspect ratio and roundness computation  
- Filtering noise and background artifacts  

### **MATLAB Programming**
- Image processing workflow structuring  
- Debug visualization  
- Automated batch processing  
- Clean modular design  

---

## 📁 Project Structure

```
VC-Pharmaceutical-Tablet-Detection/
│
├── deteccio_rodones.m      → Detects circular tablets
├── deteccio_ovalades.m     → Detects oval tablets
│
└── Fotos/                  → Input images (pharmaceutical tablets)
```

### Design Philosophy
- Each script is focused on one specific geometric class  
- Uses a consistent segmentation pipeline  
- Shape descriptors determine classification  
- All logic is MATLAB-native (no external libraries)  

---

## 🔍 Project Details

### **1. Segmentation Pipeline**
Common steps for both circular and oval detection:
1. Convert image to grayscale  
2. Normalize and remove lighting variation  
3. Threshold or apply edge detection  
4. Morphological cleaning (opening/closing)  
5. Mask extraction  
6. Regionprops to extract geometric features  

---

### **2. Circular Tablet Detection (`deteccio_rodones.m`)**
Circular tablets are detected based on:
- High circularity  
- Low eccentricity  
- Ratio between major/minor axes close to 1.0  

A typical metric:
```
circularity = 4π * area / perimeter²
```

---

### **3. Oval Tablet Detection (`deteccio_ovalades.m`)**
Oval tablets typically have:
- Higher eccentricity  
- An elongated shape  
- Axis ratio significantly greater than 1  

Classification thresholds are determined empirically from the image dataset.

---

### **4. Image Dataset (`Fotos/`)**
Contains real photographs of tablets with different shapes.  
These images are used as the source material for both scripts.

---

## ▶️ How to Run the Project

### 1. Open MATLAB and navigate to the project directory
```matlab
cd Farmacia
```

### 2. Run circular tablet detection
```matlab
deteccio_rodones
```

### 3. Run oval tablet detection
```matlab
deteccio_ovalades
```

Each script processes the images in `Fotos/` and outputs the detected shapes visually.

---

## ✔ Summary
This project demonstrates a practical computer vision pipeline for **shape-based detection of pharmaceutical tablets**, using MATLAB and classical image processing techniques.  
It showcases segmentation, contour extraction, shape metrics, and modular processing scripts suitable for quality-control tasks or academic demonstration.

