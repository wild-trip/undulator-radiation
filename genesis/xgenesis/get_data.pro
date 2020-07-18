function get_data,col,minz,maxz,mint,maxt

common data,record,global,profile,info

if (col ge 0) then begin
  return,record[col,minz:maxz,mint:maxt]
endif

case col of
-1:begin
      data=dblarr(maxz-minz+1,maxt-mint+1)
      for i=0,maxz-minz do begin
        spec=reform(calc_spectrum(i+minz))
        data[i,*]=spec[mint:maxt]
      endfor
   end  
-2:begin
     bw=dblarr(info.nz)
     data=dblarr(maxz-minz+1)
     bw=calc_bandwidth()
     data[*]=bw[minz:maxz]
   end
-3:begin
     data=dblarr(maxt-mint+1)
     data[*]=profile[0,mint:maxt] 
    end
else: print,'Extrating data unknown'
endcase

return,data

end
