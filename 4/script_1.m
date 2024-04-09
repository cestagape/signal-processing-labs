clc, clear, close all
Fd = 44100; % задаем стандартную частоту дискретизации в Гц
Td = 1./Fd; % период дискретизации – обратный частоте
Ts = 10; % задаем длительность формируемого сигнала в секундах
N = Fd*Ts; %количество дискретных отсчетов
x1 = randn(N,2); % создаем первый источник белого шума
% параметры основного шума - граничные частоты в Гц:
f1_low = 100; f1_up = 345;
% от этих параметров очень сильно зависит характер звука!!
% применяем полосовой фильтр для создания первого аудиосигнала:
y1 = bandpass(x1, [f1_low, f1_up], Fd);
x2 = randn(N,2); % создаем второй источник белого шума
% параметр низкочастотного процесса, для последующего
% использования при изменении интенсивности звука, в Гц
f2_low = 0.05; % в среднем период колебаний составит 20 сек
% в качестве второго формирующего фильтра задаем ФНЧ:
[b a] = butter(2, 2*f2_low./Fd, 'low');
% создаем второй процесс:
y2 = filter(b, a, x2);
% *********************************************************
% изменяем интенсивность первого процесса, используя второй:
y12 = y1 .* y2;
% *********************************************************
% нормировка по амплитуде:
Am = 8192; % константа, задающая максимум громкости
% (Am не должна превышать 32767)
maxy12 = max(y12(:,:)); miny12 = min(y12(:,:));
norm1 = abs(miny12(1)); norm2 = abs(miny12(2));
if (maxy12(1)>abs(miny12(1))) norm1 = maxy12(1); end
if (maxy12(2)>abs(miny12(2))) norm2 = maxy12(2); end
y(:,1) = Am.*(y12(:,1) ./ norm1);
y(:,2) = Am.*(y12(:,2) ./ norm2);
output_signal = int16(y);
% записываем новый аудиофайл:
audiowrite('output_audio.wav', output_signal, Fd);
% построение графиков сигналов
start=1; stop=N;
figure(1)
subplot(2,1,1); plot(y(start:stop,1));
subplot(2,1,2); plot(y(start:stop,2));
