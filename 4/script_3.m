% Параметры
Fs = 44100; % Частота дискретизации
T = 10; % Длительность сигнала в секундах
t = 0:1/Fs:T-1/Fs; % Временной вектор

% Генерация гауссовского белого шума
noise = randn(size(t));

% Добавление синусоидальных осцилляций 
f1 = 1000; % Частота первого осциллятора
f2 = 5000; % Частота второго осциллятора
oscillation1 = sin(2*pi*f1*t);
oscillation2 = sin(2*pi*f2*t);

% Добавление фильтров
% Фильтр нижних частот
lpf_cutoff = 1000;
lpf_order = 4; % Порядок фильтра верхних частот
lpf = designfilt('lowpassfir', 'FilterOrder', lpf_order, 'CutoffFrequency', lpf_cutoff, 'SampleRate', Fs);

% Фильтр верхних частот
hpf_cutoff = 2000;% Частота среза фильтра верхних частот в Гц
hpf_order = 4; % Порядок фильтра верхних частот
hpf = designfilt('highpassfir', 'FilterOrder', hpf_order, 'CutoffFrequency', hpf_cutoff, 'SampleRate', Fs);

% применение фильтров
filtered_noise = filtfilt(lpf, noise);
filtered_noise = filtfilt(hpf, filtered_noise);

% Объединение звуков
signal = filtered_noise + 0.5*oscillation1 + 0.2*oscillation2;

% Нормалмзация сигнала
signal = signal / max(abs(signal));

% Сохранение
filename = 'сигнал.wav';
audiowrite(filename, signal, Fs);
