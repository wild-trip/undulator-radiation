pro radial,kind

common file,io
common plot, setting,labels,asignment,par_label

data=readparticle(i,/keep_open)
x=reform(data[*,2L])
y=reform(data[*,3L])
theta=reform(data[*,1])

r=sqrt(x^2+y^2)

minr=0.e0
maxr=max(r)
nr=15
dr=(maxr-minr)/nr


rplot=(dindgen(nr)+0.5)/nr*maxr
rprof=dblarr(nr)*0.
rbun=dblarr(nr)*0.
totcount=0.
for i=0,nr-1 do begin
  idx=where((r gt (rplot[i]-0.5*dr)) and (r le (rplot[i]+0.5*dr)),count)
  if count le 0 then begin
    rprof[i]=0.
    rbun[i]=0.
  endif else begin
    totcount=totcount+count
    rprof[i]=count
    rbun[i]=abs(total(complex(cos(theta[idx]),sin(theta[idx])))/count)
  endelse 
endfor

rprof=rprof/totcount
rplot=rplot*1e6
label={title:'',x:'!9r!x [!9m!Xm]',y:'',z:''}	

case kind of
0:begin
    label.y='P(!9r!X)'
    label.title='Radial Distribution'
    rdata=rprof
  end
1:begin
    label.y='b(!9r!X)'
    label.title='Radial Bunching Factor' 
    rdata=rbun 
  end
else: print,'Unknown radial plotting style'
endcase

plot_1d,rdata,rplot,label,overplot=setting.overplot,/histogram


return
end
