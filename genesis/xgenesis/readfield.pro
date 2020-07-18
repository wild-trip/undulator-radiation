function readfield,iz,it,keep_open=keep_open

common file,io
common plot, setting,labels,asignment,par_label

if (n_elements(iz) ne 0) then begin
  recz=iz
endif else begin 
  recz=setting.field_recz
endelse

if (n_elements(it) ne 0) then begin
  rect=it
endif else begin 
  rect=setting.field_rect
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

if (io.field_enforceopen ne 0) then begin
  io.field_enforceopen=0
  if (io.field_isopen ne 0) then begin
   lun=io.field_isopen
   close,lun
   free_lun,lun
   io.field_isopen=0
  endif
endif

if (io.field_isopen eq 0) then begin
  filename=io.filename+'.fld'
  if (io.field_harmonic gt 1) then begin
   filename=filename+string(io.field_harmonic,format='(I1.1)')
  endif
  openr,lun,filename,/get_lun
  io.field_isopen=lun
endif else begin
  lun=io.field_isopen
endelse


data=dblarr(io.field_size,io.field_size,2) ; data record
idx=16L*io.field_size*io.field_size*(rect*io.field_nz+recz)       ; pointer position  
point_lun,lun,idx
readu,lun,data

newdata=reform(dcomplex(data[*,*,0],data[*,*,1]))

if (n_elements(keep_open) eq 0) then begin
  close,lun
  free_lun,lun
  io.field_isopen=0 
endif

return,newdata
end
