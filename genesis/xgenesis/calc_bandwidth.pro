function calc_bandwidth

common data,record,global,profile,info

cola=2  ;default value
cola=3

idx=where(info.order eq 2,count)
if count gt 0 then cola=idx
idx=where(info.order eq 3,count)
if count gt 0 then colf=idx

bw=dblarr(info.nz)
feq=reform(profile[2,*])

for i=0,info.nz-1 do begin
   signal=calc_spectrum(i,cola=cola,colf=colf)
   dnorm=total(signal)
   dmean=total(signal*feq)/dnorm
   dsig=sqrt(total(signal*(feq-dmean)^2)/dnorm)*1e-9   
   bw[i]=dsig/info.xlamds
endfor

return,bw*100.

end
