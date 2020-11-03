function calc_spectrum,nz,cola=cola,colf=colf

common plot, setting,labels,asignment,par_label,asignment_old,asignment_new
common data,record,global,profile,info

if (n_elements(nz) eq 0) then nz=setting.recz  ; use current selection if not defined

if ((n_elements(cola) ne 1) or (n_elements(colf) ne 1)) then begin ; get column for phase and amplitude
    idx=where(info.order eq 2,count)
    if count gt 0 then cola=idx
    idx=where(info.order eq 3,count)
    if count gt 0 then colf=idx
endif

phase=reform(record[colf,nz,*])
amp=reform(record[cola,nz,*])


signal=complex(cos(phase),sin(phase))*sqrt(amp)
signal=fft(signal,-1,/overwrite)
nshift=fix(info.nt/2)+1
signal=shift(abs(signal),-nshift)^2



return,signal

end
