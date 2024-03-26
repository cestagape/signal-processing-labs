I=imread('assets/blurry.png');
figure('Name','Исходное изображение');
imshow(I);
figure('Name','Гистограмма исходного изображения');
imhist(rgb2gray(I));

% 1) функция HISTEQ с выделением матрицы яркости:

h=64; % количество столбцов желаемой гистограммы

I_hsv = rgb2hsv(I); % перевод в цветовое пр-во HSV
J_hsv = I_hsv; % подготавливаем данные вых. изображения
V = I_hsv(:,:,3); % выделение матрицы яркости
V_out = histeq(V,h); % эквализация гистограммы
J_hsv(:,:,3) = V_out; % изменяем матрицу яркости
J1 = im2uint8(hsv2rgb(J_hsv)); % формируем изображение
figure('Name','Изображение после эквализации (HISTEQ)');
imshow(J1);
figure('Name','Гистограмма после эквализации (HISTEQ)');
imhist(im2uint8(V_out));
imwrite(J1, 'outputs/output_image_HISTEQ.png')

% 2) функция IMADJUST:

MinMaxValues = stretchlim(I);
J2 = imadjust(I,MinMaxValues,[]);
figure('Name','Линейно-контрастированное изображение (IMADJUST)');
imshow(J2);
figure('Name','Гистограмма после IMADJUST');
imhist(J2);
imwrite(J2, 'outputs/output_image_IMADJUST.png')

% 3) функция ADAPTHISTEQ-rayleigh:

% у функции есть особенность: исходные данные д.б. от 0 до 1

LAB = rgb2lab(I);
L = LAB(:,:,1)/100; % нормировка под диапазон от 0 до 1
L = adapthisteq(L,'ClipLimit',0.02,'Distribution','rayleigh');

LAB(:,:,1) = L*100; % денормировка
J3 = lab2rgb(LAB); % обратное преобразование в изображение
figure('Name','adapthisteq_Image');
imshow(J3);
figure('Name','histogram_adapthisteq_rayleigh_Image');
imhist(uint8(L.*255)); % построение гистограммы
imwrite(J3, 'outputs/output_image_ADAPTHISTEQ_rayleigh.png');


% 2 ЧАСТЬ РАБОТЫ
% функция ADAPTHISTEQ-exponential

LAB = rgb2lab(I);
L = LAB(:,:,1)/100; % нормировка под диапазон от 0 до 1
L = adapthisteq(L,'ClipLimit',0.02,'Distribution','exponential');

LAB(:,:,1) = L*100; % денормировка
J4 = lab2rgb(LAB); % обратное преобразование в изображение
figure('Name','adapthisteq_Image');
imshow(J4);
figure('Name','histogram_adapthisteq_exponential_Image');
imhist(uint8(L.*255)); % построение гистограммы
imwrite(J4, 'outputs/output_image_ADAPTHISTEQ_exponential.png');

% функция ADAPTHISTEQ-uniform

LAB = rgb2lab(I);
L = LAB(:,:,1)/100; % нормировка под диапазон от 0 до 1
L = adapthisteq(L,'ClipLimit',0.02,'Distribution','uniform');

LAB(:,:,1) = L*100; % денормировка
J5 = lab2rgb(LAB); % обратное преобразование в изображение
figure('Name','adapthisteq_Image_uniform');
imshow(J5);
figure('Name','histogram_adapthisteq_exponential_Image');
imhist(uint8(L.*255)); % построение гистограммы
imwrite(J5, 'outputs/output_image_ADAPTHISTEQ_uniform.png');