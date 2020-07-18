pro plot_1d,data,x,label,overplot=overplot,dolog=dolog,_extra=inherit


common export,ex_data,ex_x

;
; save plot data for export
;

ex_data=data
ex_x=x

op=0
dothelog=0
if (n_elements(overplot) ne 0) then op=overplot
if (n_elements(dolog) ne 0) then dothelog=dolog 

iplot,x,data,xstyle=1,/view_next,overplot=op, y_log=dothelog, $
      xtitle=label.x,ytitle=label.y,name=label.title,_extra=inherit, $
      color=[255B,0B,0B] 

iplot,x,data,/overplot,/hide,name='cc (ignore)',_extra=inherit

return
end
