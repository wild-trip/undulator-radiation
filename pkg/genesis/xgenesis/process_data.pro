function process_data,kind,dir,col

common data,record,global,profile,info

if (kind gt 2) then begin
   data=reform(get_data(col,0,info.nz-1,0,info.nt-1))
   if kind eq 4 then begin
      for i=0,info.nz-1 do begin
         data[i,*]=data[i,*]/max(data[i,*])
      endfor
      data[0,*]=0
   endif
   return,transpose(data)
endif

case dir of
0: begin     ; plot along z
     data=dblarr(info.nz)
     for i=0,info.nz-1 do begin
       case kind of
          1:data[i]=mean(get_data(col,i,i,0,info.nt-1))
          2:data[i]=max(get_data(col,i,i,0,info.nt-1))
          else:print,'data processing not defined'
       endcase
     endfor 
   end
1: begin     ; plot along t
     data=dblarr(info.nt)
     for i=0,info.nt-1 do begin
       case kind of
          1:data[i]=mean(get_data(col,0,info.nz-1,i,i))
          2:data[i]=max(get_data(col,0,info.nz-1,i,i))
          else:print,'data processing not defined'
       endcase
     endfor 
   end
else: print,'Processing mode undefined'
endcase
   
return, data
end
