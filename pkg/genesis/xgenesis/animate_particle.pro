pro animate_particle


common file,io
common plot, setting,labels,asignment,par_label,asignment_old,asignment_new



dosave=0
if setting.save_ani ne 0 then begin
   dosave=1
   file=dialog_pickfile(/write,path=io.curdir,file='animation',$
     title='Select Root Filename')
   if file eq '' then dosave=0   
endif

size=io.particle_size
rec=io.particle_nz


x=dblarr(size,rec)
y=dblarr(size,rec)

for i=0,rec-1 do begin
   print,'Loading ',i+1,' of ',rec,' records'
   data=readparticle(i,/keep_open)
   x[*,i]=reform(data[*,setting.parx])
   y[*,i]=reform(data[*,setting.pary]) 
endfor

if (setting.parx eq 1) then begin
  x=x+!pi
  x=x mod (2.*!pi)
  idx=where(x lt 0, count)
  if (count gt 0) then x[idx]=x[idx]+2.*!pi
  x=x-!pi
endif 
 
if (setting.pary eq 1) then begin
   y=y+!pi
   y=y mod (2.*!pi)
   idx=where(y lt 0, count)
   if (count gt 0) then y[idx]=y[idx]+2.*!pi
   y=y-!pi
endif 

print,'reading particle done'

; Because the animation cannot use the Hardware Fonts the label have to be rewritten

par_ani_label=['!7c!X','!7h!X [rad]','x [m]','y [m]','!7cb!X!Lx!N','!7cb!X!Ly!N']


xrange=[min(x),max(x)]
yrange=[min(y),max(y)]
xlabel=par_ani_label[setting.parx]
ylabel=par_ani_label[setting.pary]

xinteranimate,set=[320,240,rec]

window,/free,xsize=320,ysize=240


for i=0,rec-1 do begin
  plot,x[*,i],y[*,i],xrange=xrange,xstyle=1,yrange=yrange,ystyle=1,psym=3,$
    xtitle=xlabel,ytitle=ylabel
  t=tvrd()
  if (dosave ne 0) then write_jpeg,file+string(i,format='(I5.5)')+'.jpg',t
  xinteranimate,frame=i,image=t
endfor

wdelete,!D.window
xinteranimate



return
end
