pro xinfo,group=group

common widget,base
common file,io
common data, record,global,profile,info 

if xregistered('statistic') ne 0 then return
if (io.type eq 'empty') then return

statbase=widget_base(title='File Info',/Column,tlb_frame_attr=1,$
       xoffset=200,yoffset=250)
base.statbase=statbase

tmpbase=widget_base(statbase,column=2,/grid_layout)

tmpbase1=widget_label(tmpbase,value='File:',/align_left)
tmpbase1=widget_label(tmpbase,value='File Type:',/align_left)
tmpbase1=widget_label(tmpbase,value='Run Type:',/align_left)
tmpbase1=widget_label(tmpbase,value='Record Entries:',/align_left)
tmpbase1=widget_label(tmpbase,value='Records in z:',/align_left)
if (info.nt gt 1) then begin
 tmpbase1=widget_label(tmpbase,value='Records in t:',/align_left)
endif
if (io.particle_nz gt 0) then begin
  tmpbase1=widget_label(tmpbase,value='Particle Distribution',/align_left)
  tmpbase1=widget_label(tmpbase,value='Records in z',/align_left)
  if (io.particle_nt gt 1) then tmpbase1=widget_label(tmpbase,value='Records in t',/align_left)
endif
if (io.field_nz gt 0) then begin
  tmpbase1=widget_label(tmpbase,value='Field Distribution',/align_left)
  tmpbase1=widget_label(tmpbase,value='Records in z',/align_left)
  if (io.field_nt gt 1) then tmpbase1=widget_label(tmpbase,value='Records in t',/align_left)
endif

tmpbase1=widget_text(tmpbase,value=io.filename,xsize=12)
tmpbase1=widget_text(tmpbase,value=io.type,xsize=12)
if (info.isscan ne 0 ) then begin
   tmpbase1=widget_text(tmpbase,value='Scan',xsize=12)
endif else begin
   if (info.nt gt 0) then begin
      tmpbase1=widget_text(tmpbase,value='Steady-State',xsize=12)
   endif else begin
      tmpbase1=widget_text(tmpbase,value='Time-Dependent',xsize=12)
   endelse
endelse
tmpbase1=widget_text(tmpbase,value=string(info.ncol),xsize=12)
tmpbase1=widget_text(tmpbase,value=string(info.nz),xsize=12)
if (info.nt gt 1) then begin
 tmpbase1=widget_text(tmpbase,value=string(info.nt))
endif
if (io.particle_nz gt 0) then begin
  tmpbase1=widget_text(tmpbase,value='generated',xsize=12)
  tmpbase1=widget_text(tmpbase,value=string(io.particle_nz),xsize=12)
  if (io.particle_nt gt 1) then tmpbase1=widget_text(tmpbase,value=string(io.particle_nt),xsize=12)
endif
if (io.field_nz gt 0) then begin
  tmpbase1=widget_text(tmpbase,value='generated',xsize=12)
  tmpbase1=widget_text(tmpbase,value=string(io.field_nz),xsize=12)
  if (io.field_nt gt 1) then tmpbase1=widget_text(tmpbase,value=string(io.field_nt),xsize=12)
endif

base=widget_button(statbase,value='Done',uvalue=statbase)
   

widget_control,statbase,/realize
xmanager,'statistic',statbase,GROUP_LEADER=group, $
    event_handler='xinfo_event_pro',/no_block 


end
