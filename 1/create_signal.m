% Параметры сигнала
Fd = 48000; % задаем стандартную частоту дискретизации в Гц
f_tone = 400; % частота сигнала в Гц
Ts = 7.49; % длительность сигнала в секундах
Amp = 0.8; % амплитуда сигнала

% Генерация времени
Td = 0:1/Fd:Ts; % период дискретизации – обратный частоте

% Генерация меандра с заданной частотой
Signal = Amp * square(2 * pi * f_tone * Td);

% Синхронизация в обоих каналах
stereo_signal = [Signal; Signal];

output_signal = int16(32767*stereo_signal); %задание разрядности данных

% Сохранение аудиофайла
audiowrite('output_signal.wav', output_signal', Fd);
