function frog,signal,trace

result=size(reform(signal))
n=result[1]
if (result[0] ne 1) then begin
    print, 'Multidimensional Signal for Frog'
    return,0
endif

sig1=dcomplexarr(2*n)*0.

sig1[(n/2L):(n/2L)+n-1]=reform(signal)

case trace of
0: sig2=sig1
1: sig2=sig1*sig1
2: begin
      sig2=sig1*sig1
      sig1=conj(sig1)
   end
else:begin
       print,'Frog Trace unknown'
       return,0
     end
endcase 

n1=n/8L
n2=n/5L
trace=dblarr(2L*n1+1,2L*n2)
for i=-n1,n1 do begin
   print,'Frog-Trace - Step ',i+n1+1,' of ',2L*n1+1
   corsig=sig2*shift(sig1,3L*i)
   spec=abs(shift(fft(corsig,-1),-n))^2
   trace[i+n1,*]=spec[n-n2:n+n2-1]
endfor

return,trace

end
