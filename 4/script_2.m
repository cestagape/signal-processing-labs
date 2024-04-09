clc, clear, close all
Fd = 44100; % задаем стандартную частоту дискретизации в Гц
Td = 1./Fd; % период дискретизации – обратный частоте
Ts = 10; % задаем длительность формируемого сигнала в секундах
N = Fd*Ts; %количество дискретных отсчетов
x = rand(N,2)*2 - 0.5; % создаем источник белого шума
eps1 = 0.01; % параметр, отвечающий за полосу каждого форм. фильтра
dn1 = 1-eps1; up1 = 1+eps1;
f1 = 10000; % центральная частота первого ФФ
% применяем первый фф (в данном случае - полосовой):
y1 = bandpass(x, [dn1*f1, up1*f1], Fd);
% применяем второй ФФ:
eps2 = 0.1; % меняем полосу форм. фильтра
dn2 = 1-eps2; up2 = 1+eps2;
f2 = 7*f1; % меняем частоту настройки
% применяем три полосовых фильтра:
y2 = bandpass(x, [dn2*f2, up2*f2], Fd);
y12 = zeros(N,2);
% смешиваем процессы, меняя их интенсивности во времени:
% *********************************************************
for k=1:N
 % для смешивания применим сигмоидную функцию,
 % она меняется от почти 0 в начале до почти 1 в конце:
 alfa = 1/(1 + exp(-10*(2*(k-N/2)/N)));
 % собственно смешивание с переменными коэфф-ми:
 y12(k,:)= y1(k,:) * (1- alfa) + y2(k,:) * alfa;
 % и дополнительно периодическое изменение громкости:
 y12(k,:) = y12(k,:) * (0.5*(1-cos(2*pi*k*2/Fd)))^2;

end
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