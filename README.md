# Adaptive-Modulation-in-Time-Varying-Rayleigh-Fading-Channels
This repository contains a MATLAB implementation of an Adaptive Modulation system designed to optimize throughput while maintaining link quality in a wireless communication environment.
🚀 Overview

The system dynamically switches between different modulation schemes (BPSK, QPSK, 16-QAM, and 64-QAM) based on the instantaneous Signal-to-Noise Ratio (SNR). The primary goal is to maximize the spectral efficiency (Throughput) when the channel is good and ensure robustness when the channel degrades.
<img width="1918" height="1020" alt="image" src="https://github.com/user-attachments/assets/d61cbd2e-b6fa-4bcc-bf02-c6df5b752228" />
🛠 Key Features

  Time-Varying Channel: Simulates a realistic Rayleigh fading channel using a Jakes Doppler model (fd​=100 Hz) to reflect terminal mobility.

   Pilot-Based Estimation: Implements channel estimation using pilot symbols inserted at the start of each frame for coherent detection.

   Threshold-Based Switching: Uses predefined SNR thresholds to transition between modulation orders.

  Comparative Analysis: Provides a side-by-side comparison of Adaptive Throughput vs. Fixed Modulation (QPSK).

  Performance Metrics: Detailed plots for Bit Error Rate (BER) and Throughput (Bits per Symbol) across an SNR range of 0-24 dB.
📊 Results

The simulation demonstrates that:

  Throughput: The adaptive system achieves a "staircase" growth in spectral efficiency, significantly outperforming fixed schemes at high SNR.

   BER: The adaptive logic keeps the error rate within acceptable bounds by scaling down the modulation order during deep fades.
 💻 How to Run

  Clone the repository.

  Open AdaptiveModulationinFadingChannels.m in MATLAB.

  Run the script to generate the performance curves.   
