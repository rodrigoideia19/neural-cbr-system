# Intelligent Hybrid Decision-Support System: CBR & Neural Networks

[![Language: MATLAB](https://img.shields.io/badge/Language-MATLAB-orange.svg)](https://www.mathworks.com/products/matlab.html)
[![Domain: Artificial Intelligence](https://img.shields.io/badge/Domain-Knowledge_&_Reasoning-blue.svg)](https://www.isec.pt)
[![Institution: ISEC](https://img.shields.io/badge/Institution-ISEC_Coimbra-red.svg)](https://www.isec.pt)

> [!NOTE]  
> **Academic Context:**  
> Developed for the **Knowledge and Reasoning (Conhecimento e Raciocínio - CR)** curricular unit in the **BSc in Computer Science (LEI)** at **ISEC - Instituto Superior de Engenharia de Coimbra** (Academic Year 2025/2026).

---

## 📌 Overview

This project implements a hybrid decision-support system designed for **fault diagnosis and health condition monitoring in asynchronous electric induction motors**. It explores and compares two distinct Artificial Intelligence paradigms:

1. **Case-Based Reasoning (CBR):** Implements the classic 4-phase Aamodt & Plaza cycle (*Retrieve, Reuse, Revise, Retain*) to exploit experiential domain knowledge.
2. **Artificial Neural Networks (ANN):** Implements multilayer Feedforward Neural Networks trained via backpropagation to classify motor operating states and anomalies.

---

## ⚙️ System Architecture

### 1. Case-Based Reasoning (CBR) Cycle
The CBR subsystem follows the cyclical lifecycle of experiential problem solving:
* **Retrieve (`retrieve.m`):** Computes similarity between a new motor telemetry query and stored historical cases using weighted multi-attribute distance metrics (Euclidean / Manhattan) over normalized parameters.
* **Reuse (`reuse.m`):** Adapts the retrieved diagnoses/solutions to formulate an actionable assessment for the current case.
* **Revise (`revise.m`):** Evaluates and validates the accuracy of the proposed solution.
* **Retain (`retain.m`):** Decides whether the newly solved query represents novel knowledge, conditionally incorporating it into the dynamic case base (`casosTreinoNormalizados`).

### 2. Feedforward Artificial Neural Networks
* Multilayer Perceptron architectures (`feedforward.m` & `feedforward_B.m`) trained on multi-sensor motor signals.
* Hyperparameter tuning across activation functions, hidden layer configurations, learning rates, and epochs.
* Comprehensive performance evaluation via confusion matrices, classification accuracy, sensitivity, and loss curves.

---

## 📊 Telemetry Dataset & Sensor Attributes

The system processes real-world asynchronous motor operating signals:
* **Thermal & Mechanical:** Temperature, Vibration, Rotation Speed, Torque.
* **Electrical:** Voltage, Current, Efficiency.
* **Environmental & Operational:** Pressure, Noise Level, Load Value, Maintenance Level, Operating Mode.

Data preprocessing and feature normalization scripts:
* `tratamento_dataset.m` — Cleans, handles outliers, and formats raw input vectors.
* `Normaliza_Test.m` — Normalizes incoming evaluation datasets against training bounds.

---

## 📁 Repository Structure

```text
├── cbr.m                        # Main CBR execution engine
├── cbr_teste.m                  # Batch evaluation and benchmarking for CBR
├── retrieve.m                   # Case retrieval phase & similarity scoring
├── reuse.m                      # Solution adaptation phase
├── revise.m                     # Solution verification & evaluation
├── retain.m                     # Case retention & dynamic memory update
├── feedforward.m                # Neural Network model configuration & training
├── feedforward_B.m              # Alternative topology & ablation experiments
├── tratamento_dataset.m         # Raw data preprocessing
├── Normaliza_Test.m             # Test set normalization
├── dataset_TP.csv               # Baseline motor telemetry dataset
├── dataset_TP_test.csv          # Unseen evaluation dataset
├── EstudoTP_CR.xlsx             # Complete experimental logs & metric comparisons
├── Relatório_Tp_CR.pdf          # Full 22-page technical report and findings
└── README.md                    # Project documentation
```

---

## 🚀 How to Run (MATLAB)

1. Open MATLAB and set the project folder as the Current Working Directory:
   ```matlab
   cd('path/to/neural-cbr-system')
   ```
2. **Run the CBR System:**
   ```matlab
   cbr
   ```
   Or execute the batch evaluation suite:
   ```matlab
   cbr_teste
   ```
3. **Train and Test the Neural Network:**
   ```matlab
   feedforward
   ```

---

## 👥 Authors

* **Rodrigo Salgueiro da Silva Ideia** — Student ID: `2024140892` ([GitHub](https://github.com/rodrigoideia19))
* **André Pessoa Tavares** — Student ID: `2023155012`

*BSc in Computer Science (LEI), Instituto Superior de Engenharia de Coimbra (ISEC)*  
*Supervised by: Prof.ª Anabela Borges Simões*
