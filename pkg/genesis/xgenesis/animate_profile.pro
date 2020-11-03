pro animate_profile

common widget,base
common file, io
common data,record,global,profile,info
common plot, setting,labels,asignment,par_label,asignment_old,asignment_new

dosave=0
if setting.save_ani ne 0 then begin
   dosave=1
   file=dialog_pickfile(/write,path=io.curdir,file='animation',$
     title='Select Root Filename')
   if file eq '' then dosave=0   
endif

z=reform(global[0,1:*])
s=reform(profile[1,*])
power=reform(get_data(0,1,info.nz-1,0,info.nt-1))
if (setting.inclspec) then begin
   bandwidth=calc_bandwidth()
   f=reform(profile[2,*])
   if (setting.fixspec ne 0) then begin
       widget_control,base.specmin,get_value=value1
       widget_control,base.specmax,get_value=value2
       xtmp=[float(value1),float(value2)]
       xrange=[min(xtmp),max(xtmp)]
       if (xrange[1] gt max(f)) then xrange[1]=max(f)
       if (xrange[1] le min(f)) then xrange[1]=max(f)
       if (xrange[0] lt min(f)) then xrange[0]=min(f)
       if (xrange[0] ge max(f)) then xrange[0]=min(f)           
    endif else begin
      xrange=[min(f),max(f)] 
    endelse
endif

pavg=dblarr(info.nz-1)
for i=0,info.nz-2 do begin
 pavg[i]=mean(reform(power[i,*]))
 power[i,*]=1./max(power[i,*])*power[i,*] 
endfor

pcharsave=!P.CHARSIZE
if (setting.inclspec ne 0) then begin
 !P.CHARSIZE=0.7
endif

x1title='!Xs [!7l!Xm]'
y1title='!XP / Max(P)'

x2title='!Xz [m]'
y2title='!X< P > [W]'

x3title='!7k!X [nm]'
y3title='!XP(!7k!X) / Max(P)'

x4title='!Xz [m]'
y4title='!7Dk/k!X [%]'

xinteranimate,set=[320,240,info.nz-1]

window,/free,xsize=320,ysize=240
if (setting.inclspec eq 0) then begin
  !P.multi=[0,1,2]
endif else begin
  !P.MULTI=[0,2,2]
endelse

for i=1,info.nz-2 do begin
  plot,s,power[i,*],xstyle=1,yrange=[0,1.1],ystyle=1,xtitle=x1title,ytitle=y1title
  if (setting.inclspec ne 0) then begin
     spec=calc_spectrum(i)
     spec=spec/max(spec)
     plot,f,spec,xstyle=1,xrange=xrange,yrange=[0,1.1],ystyle=1,xtitle=x3title,ytitle=y3title      
  endif 
  plot_io,z[0:i],pavg[0:i],xstyle=1,xrange=[0,max(z)],yrange=[min(pavg),max(pavg)],xtitle=x2title,ytitle=y2title
  if (setting.inclspec ne 0) then begin
    plot,z[0:i],bandwidth[0:i],xstyle=1,xrange=[0,max(z)],yrange=[0,max(bandwidth)],xtitle=x4title,ytitle=y4title
  endif
  t=tvrd()
  if (dosave ne 0) then write_jpeg,file+string(i,format='(I5.5)')+'.jpg',t
  xinteranimate,frame=i,image=t
endfor

wdelete,!D.window
!P.CHARSIZE=pcharsave
xinteranimate

return
end
