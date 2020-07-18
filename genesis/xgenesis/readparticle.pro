function readparticle,iz,it,keep_open=keep_open

common file,io
common plot, setting,labels,asignment,par_label

if (n_elements(iz) ne 0) then begin
  recz=iz
endif else begin 
  recz=setting.particle_recz
endelse

if (n_elements(it) ne 0) then begin
  rect=it
endif else begin 
  rect=setting.particle_rect
endelse

;
; error handler
;
io.error=0
io.error_msg=''
catch,error_status
if error_status ne 0 then begin
  io.error=-abs(error_status)
  io.error_msg=!error_state.msg
  catch,/cancel
  return,0
endif 

if (io.particle_isopen eq 0) then begin
  filename=io.filename+'.par'
  openr,lun,filename,/get_lun
  io.particle_isopen=lun
endif else begin
  lun=io.particle_isopen
endelse

data=dblarr(io.particle_size,6) ; data record
idx=6L*8L*io.particle_size*(rect*io.particle_nz+recz)       ; pointer position  
point_lun,lun,idx
readu,lun,data

if (n_elements(keep_open) eq 0) then begin
  free_lun,lun
  io.particle_isopen=0 
endif

return, data

end
