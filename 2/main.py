import soundfile as sf
import matplotlib.pyplot as plt
import numpy as np


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
    plt.figure()
    plt.plot(frequency_axis[:len(frequency_axis) // 2], amplitude_db[:len(frequency_axis) // 2])
    plt.xlabel('Частота, Гц)')
    plt.ylabel('Амплитуда, Дб')
    plt.title(f'Частотные характеристики {title}')
    # Ограничение частотных характеристик свойствами слуха
    plt.xlim(20, 20000)
    plt.grid()
    # Создание логарфмической шкалы на оси X
    plt.semilogx()


# Функция фильтрации высоких частот
def highpass_filter(min_frequency, signal, sample_rate):
    # Переводим Гц в индексы массива
    min_frequency_index = int(len(signal) * min_frequency / sample_rate)

    # Создаем спектр входного и выходного сигнала
    fft_input = np.fft.fft2(signal)
    fft_output = np.zeros_like(fft_input) + 10 ** (-10 ** 10)

    # Реализация фильтра
    for i in range(1, min_frequency_index):
        fft_output[i, :] = fft_input[i, :]
        fft_output[len(signal) - i, :] = fft_input[len(signal) - i, :]
    fft_output[0, :] = fft_input[0, :]
    fft_output = fft_input - fft_output

    # Обратное преобразование в аудиосигнал
    output_signal = np.real(np.fft.ifft2(fft_output))

    return output_signal


# Применение функций

# Считываем файл и создаем АЧХ
original_signal, sample_rate = sf.read("Kaytranada - You're The One (Ft. Syd)-.mp3")
equalizer(sample_rate, original_signal[:, 0],  ' до фильтрации')

# Пропускаем сигнал через ФВЧ и создаём АЧХ
filtered_signal = highpass_filter(3400, original_signal, sample_rate)
equalizer(sample_rate, filtered_signal[:, 0], 'после фильтрации')

# Вывод частотных хар-ик до и после, сохранение отфильтрованного файла
plt.show()
sf.write("output_audio.wav", filtered_signal, sample_rate)
