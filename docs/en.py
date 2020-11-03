

E=152.08e-3 #GeV
K=2.133
n=1
lambda_y=2.8 #cm
gamma=1/(3.36e-3)
thetta=0
E_n=0.95*(E**2)*n/(lambda_y*(1+(K**2)/2+(gamma**2)*(thetta**2)))
print(E_n)