clear all; close all; clc;

fs = 1e6;              % Sampling frequency (1 MHz)
ts = 1/fs;
fd = 100;              % Doppler frequency (mobility and time-varying channel effect)
num_bits = 1200;       % Number of bits per frame (It is a multiple of 2, 4, and 6)
EbNo_range = 0:2:24;   % SNR range
target_ber = 1e-3;


thresholds = [4, 10, 16]; % [BPSK to QPSK, QPSK to 16QAM, 16QAM to 64QAM]


ber_adaptive = zeros(size(EbNo_range));
throughput_adaptive = zeros(size(EbNo_range));
throughput_qpsk = zeros(size(EbNo_range));


for k = 1:length(EbNo_range)
    EbNo = EbNo_range(k);
    total_errors = 0;
    total_bits = 0;
    

    if EbNo < thresholds(1)
        M = 2;   % BPSK
    elseif EbNo < thresholds(2)
        M = 4;   % QPSK
    elseif EbNo < thresholds(3)
        M = 16;  % 16-QAM
    else
        M = 64;  % 64-QAM
    end
    
    k_bits = log2(M);
    

    for frame = 1:100

        tx_bits = randi([0 1], num_bits, 1);
        tx_sym = qammod(tx_bits, M, 'InputType', 'bit', 'UnitAveragePower', true);
        
        pilot_sym = 1 + 1i; 
        transmitted_frame = [pilot_sym; tx_sym];
        

        h = (randn(length(transmitted_frame),1) + 1i*randn(length(transmitted_frame),1))/sqrt(2);
    
        [b_flat, a_flat] = butter(2, 2*fd/fs);
        h = filter(b_flat, a_flat, h);
        h = h / std(h); 
        
        faded_sig = h .* transmitted_frame;
        rx_sig = awgn(faded_sig, EbNo + 10*log10(k_bits), 'measured');
        
     
        h_hat = rx_sig(1) / pilot_sym; 
        

        data_rx = rx_sig(2:end) / h_hat;
        rx_bits = qamdemod(data_rx, M, 'OutputType', 'bit', 'UnitAveragePower', true);
        

        [~, ber] = biterr(tx_bits, rx_bits);
        total_errors = total_errors + sum(tx_bits ~= rx_bits);
        total_bits = total_bits + num_bits;
    end
    

    ber_adaptive(k) = total_errors / total_bits;
    % Throughput = (1 - BER) * log2(M)
    throughput_adaptive(k) = (1 - ber_adaptive(k)) * k_bits;
    % Throughput for fixed QPSK (for comparison)
    throughput_qpsk(k) = (1 - 0.05) * 2; 
end


figure;


subplot(2,1,1);
plot(EbNo_range, throughput_adaptive, 'b-o', 'LineWidth', 2); hold on;
plot(EbNo_range, repmat(2, 1, length(EbNo_range)), 'r--', 'LineWidth', 1.5);
grid on;
title('Throughput Comparison: Adaptive vs Fixed');
xlabel('Eb/No (dB)');
ylabel('Bits per Symbol');
legend('Adaptive Modulation', 'Fixed QPSK');

% BER plot
subplot(2,1,2);
semilogy(EbNo_range, ber_adaptive, 'm-s', 'LineWidth', 2);
grid on;
title('Bit Error Rate (BER) of the Adaptive System');
xlabel('Eb/No (dB)');
ylabel('BER');
ylim([1e-5 1]);
