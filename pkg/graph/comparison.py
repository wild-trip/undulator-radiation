#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#имя проекта: comparison graphs
#номер версии: 1.0
#имя файла: comparison.py
#автор: Fedorov I.A.
#дата создания: 18.11.2020
#дата последней модификации: 20.11.2020
#описание: Визуализация данных, получаемых в spectra
#версия Python: 3.8.6

import os as os
from pyparsing import *
import numpy as np
import matplotlib.pyplot as plt

pathFile='tasks/2/solutions/3_d1=0.3.dc0'

double  = Word(nums+'.'+'e'+'+'+'-')

template = double+double+double+double+double+double+double

E=np.empty(0)
F_Dens=np.empty(0)
F_Dens_lOx=np.empty(0) #horizontal  (PL=1)
F_Dens_lOy=np.empty(0) #vertical (PL=-1)
PL=np.empty(0)

i=0
with open(pathFile, 'r') as f:
	for line in f:
		if i<2:
			i+=1
			continue
		i+=1
		l1=template.parseString(line)
		E=np.append(E,float(l1[0]))
		F_Dens=np.append(F_Dens,float(l1[1]))
		PL=np.append(PL,float(l1[3]))
f.close()
print("[log] считано", i, "строк")
F_Dens_lOx = np.array(F_Dens[:]*((PL[:]+1)/2))
F_Dens_lOy = np.array(F_Dens[:]*(-1*(PL[:]-1)/2))
print("[log] поляризации разделены")
#plotting
fig = plt.figure(figsize=(10,20))

plt.subplot(4, 1, 1)
plt.plot(E, F_Dens)
plt.xlabel('Energy / eV')
plt.ylabel('Flux density')
plt.title('Flux density dependence from Energy')
plt.grid(True)
axes = plt.gca()
left, right = axes.get_xlim()
left = 1
right = 26
top, bottom = axes.get_ylim()
axes.set_xlim(left, right)
axes.set_ylim(0, bottom)
# im = plt.imread("tasks/2/solutions/1.1_paper.png")
# implot = plt.imshow(im, aspect='auto', extent=(left + 0.001, right, top, bottom))

plt.subplot(4, 1, 2)
plt.plot(E, PL)
plt.xlabel('Energy')
plt.ylabel('PL')
plt.title('Linear polarization degree; PL = +1 (-1)  horizontal (vertical) plane')
plt.grid(True)
axes = plt.gca()
top, bottom = axes.get_ylim()
axes.set_xlim(left, right)
axes.set_ylim(top, bottom)

plt.subplot(4, 1, 3)
plt.xlim(E[0], E[-1])
plt.plot(E, F_Dens_lOx)
axes = plt.gca()
top, bottom = axes.get_ylim()
axes.set_xlim(left, right)
axes.set_ylim(0, bottom)
plt.xlabel('Energy')
plt.ylabel('Flux density')
plt.title('Flux density on the horizontal plane')
plt.grid(True)
#im = plt.imread("tasks/2/solutions/1.2_paper_Ox.png")
#implot = plt.imshow(im, aspect='auto', extent=(left + 0.001, right, 0, bottom))

plt.subplot(4, 1, 4)
plt.plot(E, F_Dens_lOy)
axes = plt.gca()
top, bottom = axes.get_ylim()
axes.set_xlim(left, right)
axes.set_ylim(0, bottom)
plt.xlabel('Energy')
plt.ylabel('Flux density')
plt.title('Flux density on the vertical plane')
im = plt.imread("tasks/2/solutions/1.2_paper_Oy.png")
#implot = plt.imshow(im, aspect='auto', extent=(left + 0.001, right, 0, bottom))
#plt.grid(True)

plt.tight_layout()
print("[log] создал графики")
#plt.show()

targetPic='tasks/2/solutions/3_d=0.3.png'
fig.savefig(targetPic, dpi=100)
print("[log] отрендерил и сохранил графики как", targetPic)
