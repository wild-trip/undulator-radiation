# Task 2

## Todo (UPD)
1. [x] Сравнить результаты, полученные в  [статье](../../docs/articles/Kalitenko-Zhukovskii2020_Article_RadiationFromEllipticalUndulat.pdf) в пунктах:

    1. "3. ANALYSIS OF THE EFFECT OF THE THIRD FIELD HARMONIC ON THE RADIATION OF A PLANAR TWO-FREQUENCY UNDULATOR";

    2. "5. ANALYSIS OF RADIATION OF A TWO-FREQUENCY ELLIPTICAL UNDULATOR".

   :exclamation: Ошибка в статье: некорректные графики. DELETED.

2. [x] Написать подпрограмму, разделяющую спектр на линейно поляризованные составляющие

3. [x] Сравнить результаты с другими параметрами, похожими на 1.2. [Аналитичекая модель.](../../docs/analytical/elliptic%20undul,%20sparc,%20d=d2=0,%20d1=1.pdf)

# Description
#### 1.1 Параметры установки:

Поле:
<img src="https://render.githubusercontent.com/render/math?math=H=H_0(0, sin(k_{\lambda}z) %2B d_y sin(3k_{\lambda}z),0)">

| Переменная   |      Значение      |
|--------------|:------------------:|
|  <img src="https://render.githubusercontent.com/render/math?math=\gamma">		|	297.26			|
|  <img src="https://render.githubusercontent.com/render/math?math=K_{x 0}">      |   2.1               |
|  <img src="https://render.githubusercontent.com/render/math?math=K_{x Eff}">		|	0				|
| <img src="https://render.githubusercontent.com/render/math?math=K_{y Eff}"> 		|	2.2697 			|
| <img src="https://render.githubusercontent.com/render/math?math=d_y"> 		|	-1.22			|
|  <img src="https://render.githubusercontent.com/render/math?math=\lambda_u">	|	2.8 (cm)		|
| <img src="https://render.githubusercontent.com/render/math?math=\sigma">		|	0.9e-3 			|
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_x">	|	2.5e-6 (m*rad)	|
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_y">	|	2.9e-6 (m*rad)	|
| <img src="https://render.githubusercontent.com/render/math?math=\beta_x">		|	2.2 (m)			|
| <img src="https://render.githubusercontent.com/render/math?math=\beta_y">		|	2.2 (m)			|
| L																				|	4.2 (m)			|

##### Результат 1.1

Результат сравнения представлен на рисунке ниже.

[![Результат](solutions/2.1.1.png "Сравнение задачи 1.1")](solutions/2.1.1.png)

UPD: Изменились параметры длины и поля ондулятора.
По сравнению с предыдущим разом сходство увеличилось. Возможная причина различия - некорректные параметры ускорителя.

#### 3. Параметры установки:

Поле:
<img src="https://render.githubusercontent.com/render/math?math=H=H_0(sin(k_{\lambda}z), d_1sin(3k_{\lambda}z) %2B d_2 sin(k_{\lambda}z %2B \frac{\pi}{2}),0)">

| Переменная   |      Значение      |
|--------------|:------------------:|
|  <img src="https://render.githubusercontent.com/render/math?math=\gamma">     |   300                  |
|  <img src="https://render.githubusercontent.com/render/math?math=K_{x Eff}">      |   2.133               |
| <img src="https://render.githubusercontent.com/render/math?math=K_{y Eff}">       |   0.711              |
| <img src="https://render.githubusercontent.com/render/math?math=d_1">         |   1                |
| <img src="https://render.githubusercontent.com/render/math?math=d_2">         |   0              |
|  <img src="https://render.githubusercontent.com/render/math?math=\lambda_u">  |   2.8 (cm)        |
| <img src="https://render.githubusercontent.com/render/math?math=\sigma">      |   1e-3          |
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_x">  |   2.5e-6 (m*rad)  |
| <img src="https://render.githubusercontent.com/render/math?math=\epsilon_y">  |   2.9e-6 (m*rad)  |
| <img src="https://render.githubusercontent.com/render/math?math=\beta_x">     |   2.2 (m)     |
| <img src="https://render.githubusercontent.com/render/math?math=\beta_y">     |   2.2 (m)     |
| L                                                                             |   2.10 (m)        |

##### Описание 3.

[![Результат](solutions/2.3.png "Сравнение задачи 3")](solutions/2.3.png)

Графики почти идентичны.