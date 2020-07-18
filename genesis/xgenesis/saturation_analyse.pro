pro saturation_analyse,kind

common data,record,global,profile,info
common plot, setting,labels,asignment,par_label


col=0

if setting.calc_sat_bunching ne 0 then begin
    idx=where(info.order eq 7, count)
    if (count gt 0) then col=idx
endif



if (setting.calc_sat_average eq 0) then begin
   data=reform(record[col,*,*])
   pdata=reform(record[0,*,*])
   nt=info.nt
endif else begin
   data=dblarr(info.nz,1)
   pdata=data
   for i=0,info.nz-1 do begin
      data[i,0]=mean(record[col,i,*])
      pdata[i,0]=mean(record[0,i,*])
   endfor
   nt=1
endelse


sat1=dblarr(nt)
sat2=sat1



for j=0,nt-1 do begin
   power=reform(data[*,j])
   ppower=reform(pdata[*,j])
   th=0.75*(max(power)-min(power))+min(power)
   idx=0
   for i=1,info.nz-1 do begin
      if ((power[i] ge power[idx]) or (power[i] lt th)) then begin
          idx=i
      endif else begin
          break
      endelse
   endfor
   sat1[j]=ppower[idx]
   sat2[j]=global[0,idx]
endfor

if (nt eq 1) then begin
   print,'Saturation Power: ',sat1[0]
   print,'Saturation Length: ',sat2[0]  
endif else begin
   label={title:'',x:'',y:'',z:''}
   case kind of
   0: begin
        plot_data=sat1
        label.y='P!Lsat!N [W]'
        label.title='Saturation Power'
      end
   1: begin
        plot_data=sat2
        label.y='L!Lsat!N [m]'
        label.title='Saturation Length'
      end
   else: Print,'Unknown Saturation type' 
   endcase 	
   label.x='s [!(m!Xm]'
   if (info.isscan ne 0) then label.x='Scan Parameter'
   x_data=reform(profile[1,*])
   plot_1d,plot_data,x_data,label,overplot=setting.overplot
endelse  

return

end
