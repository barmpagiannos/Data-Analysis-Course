# Data Analysis - Epilepsy and Transcranial Magnetic Stimulation (TMS)

This repository contains MATLAB code developed for the final assignment of the **"Data Analysis"** course (December 2024). The project investigates how Transcranial Magnetic Stimulation (TMS) affects the duration of epileptic discharges (EDduration) using real-world clinical data from EEG measurements.

## 📁 Files & Structure

The code is structured per assignment question. Each MATLAB file follows the naming convention:  
`GroupXXExeYYProgZZ.m` or `GroupXXExeYYFunZZ.m`, where:
- `XX` is the team number
- `YY` is the exercise number
- `ZZ` is the program or function index

Each file starts with a comment section listing the team members. Results, explanations, and conclusions are included as in-code comments (in English or Greeklish).

## 📊 Dataset Description

The dataset is stored in `TMS.xlsx` (from the course site) and includes 254 recordings of ED events. Each row represents one event with or without TMS. Columns include:

| Column       | Description                                                                 |
|--------------|------------------------------------------------------------------------------|
| `TMS`        | 1 if TMS was applied, 0 otherwise                                            |
| `EDduration` | Duration of the epileptic discharge (in seconds)                            |
| `preTMS`     | Time from ED start until TMS application (in seconds)                       |
| `postTMS`    | Time from TMS application until ED end (in seconds)                         |
| `Setup`      | Measurement condition (1–6)                                                 |
| `Stimuli`    | Number of pulses in the TMS stimulus                                        |
| `Intensity`  | Stimulation intensity (percentage of max)                                   |
| `Spike`      | Indicates stimulation phase (-1: rising, 0: peak, 1: falling)               |
| `Frequency`  | Frequency of stimulation pulses (Hz)                                        |
| `CoilCode`   | 1: figure-eight coil, 0: round coil                                         |

## 📌 Assignment Topics

Each topic corresponds to a different analytical or statistical investigation using the dataset:

1. **Distribution Fitting**  
   - Fit best parametric distributions for `EDduration` with and without TMS  
   - Compare empirical and fitted probability density functions

2. **Goodness-of-Fit with Resampling**  
   - Use resampling to test exponential distribution fitting for different coil shapes  
   - Compare results to classical chi-square tests

3. **Mean Duration Confidence Intervals (Setup-based)**  
   - Compare EDduration mean for each `Setup` against the global mean  
   - Use parametric or bootstrap methods depending on distribution normality

4. **Correlation Analysis (preTMS vs postTMS)**  
   - Parametric and permutation tests to detect correlation between pre- and post-TMS durations for each `Setup`

5. **Simple Linear Regression**  
   - EDduration as a function of `Setup`  
   - Model fitting and residual analysis (with/without TMS)

6. **Multiple Linear Regression**  
   - Model EDduration (with TMS) using all available predictors  
   - Compare full model vs. models selected via stepwise and LASSO regression

7. **Model Evaluation with Train/Test Split**  
   - Train and validate models using random training/test split  
   - Compare predictive performance of all three models (Full, Stepwise, LASSO)

8. **PCR and Variable Augmentation**  
   - Re-run multiple regression using `preTMS` as additional variable  
   - Add `postTMS` and evaluate all models again including Principal Component Regression (PCR)

## 📌 Technologies Used

- MATLAB R2023 or later
- Statistics and Machine Learning Toolbox
- Excel input file: `TMS.xlsx`

---
