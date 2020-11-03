pro plot_2d,data,x,y,label,plotstyle

common export,ex_data,ex_x

;
; save plot data for export
;

ex_data=data

case plotstyle of
0:begin
    isurface,data,x,y,/view_next,xtitle=label.x,ytitle=label.y, $
             ztitle=label.z,name=label.title,color=[0,0,0],style=1,/hidden_lines
  end 
1:begin
    isurface,data,x,y,/view_next,xtitle=label.x,ytitle=label.y, $
             ztitle=label.z,name=label.title,color=[0,0,150],style=2,shading=1
  end
2:begin
    coltab=bytarr(256,3)
    tvlct,coltab,/get
    iimage,data,/view_next,/interpolate,rgb_table=coltab,$
           xtitle=label.x,ytitle=label.y,name=label.title,$ 
           image_dimension=[600,400]
;    iplot,x,xrange=[min(x),max(x)],xstyle=1,$
;          yrange=[min(y),max(y)],ystyle=1,/overplot,/view_next,/hide$
;           dimension=[600,400]
  end
3:begin
    coltab=bytarr(256,3)
    tvlct,coltab,/get
    icontour,data,x,y,/view_next,rgb_table=coltab,n_levels=7,/fill, $
       xtitle=label.x,ytitle=label.y,name=label.title
    icontour,data,x,y,/overplot,n_levels=7,color=[0,0,0],name=outline
  end
else:print,'Unknown 2D Plot Option'
endcase

return

end
