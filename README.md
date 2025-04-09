# 🧠 Sleep Induction EEG Analysis

This project assesses brain activity during **sleep induction** using both **monochannel** and **multichannel EEG recordings**. Spectral analysis is performed to better understand the variations in brain frequency bands during this phenomenon.

## 🔍 Objective

To analyze how brainwave activity changes during sleep induction by:
- Using spectral features (e.g., spectral entropy, band power).
- Comparing monochannel and multichannel EEG data.

## 📂 Project Structure

- `Monochannel Analysis.m` – Analysis script for monochannel EEG data.
- `Multichannel Analysis.m` – Analysis script for multichannel EEG data.
- `data_monochannel.mat` – Monochannel EEG dataset.
- `data_multichannel.mat` – Multichannel EEG dataset.
- Other (`.m` and `.fig` files) – Filtering functions and files generated during script execution.

## 📊 Methods

Spectral analysis is used to evaluate the distribution of power across frequency bands (e.g., delta, theta, alpha, beta), with a focus on indicators such as **spectrograms and spectral entropy** to characterize the brain's transition into sleep.
