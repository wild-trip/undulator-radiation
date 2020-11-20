# Task
1. [x] Сравнить результаты, полученные в  [статье](../../docs/articles/Kalitenko-Zhukovskii2020_Article_RadiationFromEllipticalUndulat.pdf) в пунктах:

    1.1 "3. ANALYSIS OF THE EFFECT OF THE THIRD FIELD HARMONIC ON THE RADIATION OF A PLANAR TWO-FREQUENCY UNDULATOR";
    
    1.2 "5. ANALYSIS OF RADIATION OF A TWO-FREQUENCY ELLIPTICAL UNDULATOR".
2. [x] Написать подпрограмму, разделяющую спектр на линейно поляризованные составляющие

# Description
#### 1.1 Параметры установки:
Поле

<img src="https://render.githubusercontent.com/render/math?math=H=H_0(0, sin(k_{\lambda}z) %2B d_y sin(3k_{\lambda}z),0)">

| Переменная   |      Значение      |
|--------------|:------------------:|
|  <img src="https://render.githubusercontent.com/render/math?math=\gamma">		|	297.26			|
|  <img src="https://render.githubusercontent.com/render/math?math=K_x">		|	0				|
| <img src="https://render.githubusercontent.com/render/math?math=K_y"> 		|	2.1 			|
| <img src="https://render.githubusercontent.com/render/math?math=d_y"> 		|	-1.22			|
|  <img src="https://render.githubusercontent.com/render/math?math=\lambda_u">	|	2.8 (cm)		|
| <img src="https://render.githubusercontent.com/render/math?math=\sigma">		|	0.9e-3 			|
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_x">	|	2.5e-6 (m*rad)	|
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_y">	|	2.9e-6 (m*rad)	|
| <img src="https://render.githubusercontent.com/render/math?math=\beta_x">		|	2.2 (m)			|
| <img src="https://render.githubusercontent.com/render/math?math=\beta_y">		|	2.2 (m)			|
| L																				|	2.1 (m)			|

##### Описание 1.1

Результат сравнения представлен на рисунке ниже.

[![Результат](solutions/1.1_comp.png "Сравнение задачи 1.1")](solutions/1.1_comp.png)

Графики схожи по поведению. Один параметр отличается от приведенных в статье (в статье L в 2 раза больше).

1.2 Параметры установки:
Поле

<img src="https://render.githubusercontent.com/render/math?math=H=H_0(sin(k_{\lambda}z), d_1sin(k_{\lambda}z) %2B d_2 sin(3k_{\lambda}z %2B \frac{\pi}{2}),0)">

| Переменная   |      Значение      |
|--------------|:------------------:|
|  <img src="https://render.githubusercontent.com/render/math?math=\gamma">		|	11.8			|
|  <img src="https://render.githubusercontent.com/render/math?math=K_x">		|	2.21622			|
| <img src="https://render.githubusercontent.com/render/math?math=K_y"> 		|	2.21622 		|
| <img src="https://render.githubusercontent.com/render/math?math=d_1"> 		|	0.3				|
| <img src="https://render.githubusercontent.com/render/math?math=d_2"> 		|	1				|
|  <img src="https://render.githubusercontent.com/render/math?math=\lambda_u">	|	2.3 (cm)		|
| <img src="https://render.githubusercontent.com/render/math?math=\sigma">		|	0.9e-3 			|
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_x">	|	2.5e-6 (m*rad)	|
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_y">	|	2.9e-6 (m*rad)	|
| <img src="https://render.githubusercontent.com/render/math?math=\beta_x">		|	0.37 (m)		|
| <img src="https://render.githubusercontent.com/render/math?math=\beta_y">		|	0.37 (m)		|
| L																				|	3.45 (m)		|

##### Описание 1.2

Результат сравнения представлен на рисунке ниже.

[![Результат](solutions/1.2_comp.png "Сравнение задачи 1.2")](solutions/1.2_comp.png)

:exclamation: Графики cильно отличаются от аналитически построенных. Скорее всего график суммы по поляризациям так же отличается от численной модели.