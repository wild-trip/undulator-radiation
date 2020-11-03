pro READDATA,filename,reopen=reopen,base=base
;
;   Reading of Genesis output file of original format
;   file information are given in a supplied record  
;

common file, io
common data, data_record,data_global,data_profile,data_info

file=''
io.error=0
io.error_msg=''

; reopen current file?

if (n_elements(reopen) ne 0) then begin
   if (reopen ne 0) then begin
      file=io.filename
   endif
endif

;  checking for filename   

if (n_elements(filename) ne 0) then begin
   file = filename 
endif
  
; if no file is selected then pick one

newpath=''
oldpath=io.curdir
if (file eq '') then begin
   if (n_elements(base) ne 0) then begin
     file=dialog_pickfile(/read,/must_exist,title='Select GENESIS output file', $
       get_path=newpath,path=oldpath,dialog_parent=base)
   endif else begin
     file=dialog_pickfile(/read,/must_exist,title='Select GENESIS output file', $
       get_path=newpath,path=oldpath)
   endelse
   if file eq '' then begin
    io.error=-1
    io.error_msg=''
    return
  endif  
  io.curdir=newpath
  io.path=newpath                             
endif

; closing old opened files

close,/all
io.particle_isopen=0L
io.field_isopen=0L

OPENR, UNIT, file,/GET_LUN,ERROR=ERR
IF (ERR NE 0 ) THEN BEGIN
   io.error=-1L
   io.error_msg='Cannot open file: '+file
   return
ENDIF
;
; error handler
;
catch,error_status
if error_status ne 0 then begin
  io.error=-abs(error_status)
  io.error_msg=!error_state.msg
  catch,/cancel
  return
endif 
;
;  skip namelist
;
c='1'
REPEAT READF, UNIT, FORMAT='(X,A2)', c  UNTIL c EQ '$e'
READF,UNIT,FORMAT='(A2)',c

;
;  read flags for output parameters
;
LOUT=INDGEN(40)*0L
READF,UNIT,FORMAT='(A50)',c
for i=0,23 do begin
  lout[i]=uint('0'+strmid(c,i*2+1,1)) ;"It's ugly, isn't it?"
endfor
NIN=FIX(TOTAL(LOUT))
data_info.ncol=nin
icount=0L
for i=0,14 do begin
  if lout[i] ne 0 then begin
     data_info.order[icount]=i
     icount=icount+1
   endif
endfor

;check for harmonics
data_info.hasharmonics=0B
for i=15,23 do begin
   if (lout[i] eq 4) then begin
      data_info.version=2L
   endif
endfor

data_info.hasharmonics=0B

if (data_info.version eq 2L) then begin
  for i=15,20 do begin
    if (lout[i] ne 0) then begin
       data_info.harmonics[i-14]=1
       for j=0,3 do begin
          k=15+(i-15)*4+j
          data_info.order[icount]=k
          icount=icount+1
          data_info.hasharmonics=1B
       endfor
    endif
  endfor  
endif else begin
  for i=15,23 do begin
     if (lout[i] ne 0) then begin
        data_info.order[icount]=i
        icount=icount+1
     endif   
   endfor
endelse



IF NIN EQ 0 THEN BEGIN
  io.error=-2
  io.error_msg='empty file: '+file
  RETURN
ENDIF
;
; read record size and aux. parameters
;
NZ=0L
READF,UNIT,nz
data_info.nz=nz

NSLICE=0L
READF,UNIT,NSLICE
;nslice=7200
data_info.nt=nslice

xlamds=1.e0
READF,UNIT,xlamds
data_info.xlamds=xlamds

delt=1.e0
READF,UNIT,DELT
data_info.dt=delt

ncar=1L
READF,UNIT,ncar
io.field_size=ncar

dxy=1e0
READF,UNIT,dxy

npart=0L
READF,UNIT,npart
io.particle_size=npart

nparz=0L
READF,UNIT,nparz
io.particle_nz=nparz

npars=0L
READF,UNIT,npars
io.particle_nt=npars

nfldz=0L
READF,UNIT,nfldz
io.field_nz=nfldz

nflds=0L
READF,UNIT,nflds
io.field_nt=nflds
;
; Read Global parameter 
;
data_global=DINDGEN(3,NZ)
READF, UNIT, FORMAT='(A1)', c
READF, UNIT, data_global
;
; Read main part
;
data_profile=dindgen(3,nslice)
data_record=dindgen(nin,nz,nslice)
;data_record=findgen(nin,nz,nslice)
data_getrecord=dindgen(nin,nz)
;
c1='1'
c2='1'
c3='1'
FOR I=0L,NSLICE-1L DO BEGIN
  READF, UNIT, FORMAT='(A1)', c1,c2,c3
  getval=1e0 
  if (i eq 0) then begin
      data_info.isscan=0L
      READF, UNIT, getval,c1
      if strmatch(c1,'*scan*',/fold_case)  then begin
          data_info.isscan=1L
      endif     
  endif else begin
      readf,unit,getval
  endelse
  data_profile[data_info.isscan,i]=getval
  READF, UNIT, FORMAT='(A1)', c1,c2,c3
  READF, UNIT, data_getrecord
  data_record[*,*,i]=data_getrecord
endfor
 

free_lun,unit

; get time and frequency profile

if (data_info.isscan eq 0) then data_profile[1,*]=dindgen(nslice)*delt*1.e6
if ((nslice le 1) or (delt le 0.5*xlamds)) then begin
   data_profile[2,*]=xlamds
endif else begin
   fout=(dindgen(nslice)/(nslice-1.)-0.5)/delt+1.e0/xlamds
   data_profile[2,*]=1/fout*1e9
endelse 

io.error=0L
io.error_msg=''
io.filename=file
io.type='original'

RETURN
END
