clc, clear, close all %очистка памяти
Fd = 48000;
[input_signal,Fd] = audioread('OS_DPN_125_Dm_Shanghai_Melody.wav');
N = length(input_signal);%Получить длину данных аудиофайла
t = 1:1:N;
% строим график сигнала целиком, для одного из каналов (левого)
plot(t./Fd,input_signal(:,1))
xlabel('Time'), ylabel('Audio Signal')
% строим график фрагмента сигнала
% длительностью 0.2секунды в окрестности второй секунды дорожки
% для обоих каналов раздельно
time_center = 2*Fd;
start = time_center - 0.1*Fd;
stop = time_center + 0.1*Fd;
figure(2)
subplot(2,1,1); plot(input_signal((start:stop),1));
subplot(2,1,2); plot(input_signal((start:stop),2));
%вычисляем спектр сигнала в обоих каналах:
Spectr_input(:,1)=fft(input_signal(:,1)); % левый канал
Spectr_input(:,2)=fft(input_signal(:,2)); % правый канал
eps = 0.000001; % Малая константа, чтобы избежать lg(0)
y=20*log10(abs(Spectr_input(:,1))+eps); %Преобразовать в дБ
f=[0:(Fd/N):Fd/2]; %Перевести абсциссу графика в Гц
%строим график амплитудного спектра входного сигнала
% в одном из каналов (левом)
y=y(1:length(f));
figure(3),
semilogx(f,y); grid; axis([1 Fd/2 -100 100])
xlabel('Частота (Гц)');
ylabel('Уровень (дБ)');
title('Амплитудный спектр исходного аудиосигнала');