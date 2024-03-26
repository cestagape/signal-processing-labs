import soundfile as sf
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal

# Инициализация функций

# Функция для визуализации частотных характеристик
def equalizer(sample_rate, signal, title: str):
    # Вычисление амплитудного спектра сигнала
    fft_spectrum = np.fft.fft(signal)
    # Преобразование сигнала в Дб
    amplitude_db = 20 * np.log10(np.abs(fft_spectrum))

    # Генерация частотной оси
    frequency_axis = np.fft.fftfreq(len(fft_spectrum), 1 / sample_rate)

    # Построение графика частотных характеристик (Эквалайзер)
    plt.figure(figsize=(15,5))
    plt.plot(frequency_axis[:len(frequency_axis) // 2], amplitude_db[:len(frequency_axis) // 2])
    plt.xlabel('Частота, Гц)')
    plt.ylabel('Амплитуда, Дб')
    plt.title(f'Частотные характеристики {title}')
    # Ограничение частотных характеристик свойствами слуха
    plt.xlim(20, 20000)
    plt.grid()
    # Создание логарфмической шкалы на оси X
    plt.semilogx()


# Функция для сравнения громкости
def compare_loudness(original_signal, filtered_signals, sample_rate, titles):
    # Рассчет средней квадратичной громкости с переводом в Дб
    original_rms = 20 * np.log10(np.sqrt(np.mean(original_signal ** 2)))
    filtered_rms = [20 * np.log10(np.sqrt(np.mean(signal ** 2))) for signal in filtered_signals]

    # Построение диаграммы
    plt.figure()
    plt.bar(np.arange(len(filtered_signals) + 1), [original_rms] + filtered_rms, color=['blue'] + ['black'] * len(filtered_signals))
    plt.xticks(np.arange(len(filtered_signals) + 1), ['Original'] + titles)
    plt.ylabel('Амплитуда аудиоволны (Громкость), Дб')
    plt.title('Сравнение громкости аудиосигналов')
    plt.show()


# Применение функций

# Считываем файл и создаем АЧХ
original_signal, sample_rate = sf.read("assets/Kaytranada - You're The One (Ft. Syd)-.mp3")
equalizer(sample_rate, original_signal[:, 0],  ' до фильтрации')

# Параметры фильтрации
order = 4
cutoff_freq = 3400
titles = ['Фильтр Чебышева 1-го типа', 'Фильтр Чебышева 2-го типа', 'Фильтр Баттерворта']

# Применение фильтра Чебышева 1-го типа
cheb1_b, cheb1_a = signal.cheby1(order, 5, cutoff_freq/sample_rate, btype='high')
filtered_cheb1 = signal.filtfilt(cheb1_b, cheb1_a, original_signal[:, 0])

# Применение фильтра Чебышева 2-го типа
cheb2_b, cheb2_a = signal.cheby2(order, 30, cutoff_freq/sample_rate, btype='high')
filtered_cheb2 = signal.filtfilt(cheb2_b, cheb2_a, original_signal[:, 0])

# Применение фильтра Баттерворса
butter_b, butter_a = signal.butter(order, cutoff_freq/sample_rate, btype='high')
filtered_butter = signal.filtfilt(butter_b, butter_a, original_signal[:, 0])

# Графики амплитудных спектров после фильтрации
equalizer(sample_rate, filtered_cheb1, 'после фильтра Чебышева 1-го типа')
equalizer(sample_rate, filtered_cheb2, 'после фильтра Чебышева 2-го типа')
equalizer(sample_rate, filtered_butter, 'после фильтра Butterworth')

# Сравнение громкостей
compare_loudness(original_signal[:, 0], [filtered_cheb1, filtered_cheb2, filtered_butter], sample_rate, titles)

# Вывод частотных хар-ик до и после, сохранение отфильтрованного файла
plt.show()
# sf.write("outputs/cheb1_filtered_audio.mp3", filtered_cheb1, sample_rate)
# sf.write("outputs/cheb2_filtered_audio.mp3", filtered_cheb2, sample_rate)
# sf.write("outputs/butter_filtered_audio.mp3", filtered_butter, sample_rate)
