pro create_sec_button

common widget,base
common data,record,global,profile,info
common file,io
common plot, setting,labels,asignment,par_label

; does it exist?

if xregistered('xgen-second') ne 0 then return

if ((io.particle_nz le 0) and (io.particle_nt le 0) and $
    (io.field_nz le 0) and (io.field_nt le 0 )) then return

; set_up window

title=io.filename
tmpbase=widget_base(title=title,/column,tlb_frame_attr=1,$
        xoffset=550,yoffset=60)
base.buttonsecbase=tmpbase

if ((io.particle_nz gt 0) or (io.particle_nt gt 0)) then begin
  tmpbase1=widget_base(tmpbase,/column,/frame)
  tmpbase2=widget_label(tmpbase1,value='Particle',/align_left)
  tmpbase2=widget_base(tmpbase1,/row) 
  tmpbase3=widget_label(tmpbase2,value='',xsize=40)
  lab=['z','E','x','px','y','py']
  ord=[1L,0L,2L,4L,3L,5L]
  for i=0,5 do begin
    tmpbase3=widget_label(tmpbase2,value=lab[i],xsize=20) 
  endfor 
  tmpbase2=widget_base(tmpbase1,/row)
  tmpbase3=widget_label(tmpbase2,value='x-axis:',xsize=40,/align_lef)
  tmpbase3=widget_base(tmpbase2,/exclusive,/row)
  for i=0,5 do begin
     val={kind:1L,direction:6L,id:ord[i],col:0L}
     tmpbase4=widget_button(tmpbase3,xsize=20,value='',/no_release,uvalue=val)
     if (i eq 0) then widget_control,tmpbase4,/set_button
  endfor
  tmpbase2=widget_base(tmpbase1,/row)
  tmpbase3=widget_label(tmpbase2,value='y-axis:',xsize=40,/align_left)
  tmpbase3=widget_base(tmpbase2,/exclusive,/row)
  for i=0,5 do begin
     val={kind:1L,direction:6L,id:ord[i],col:1L}
     tmpbase4=widget_button(tmpbase3,xsize=20,value='',/no_release,uvalue=val)
     if (i eq 1) then widget_control,tmpbase4,/set_button
   endfor
  tmpbase2=widget_base(tmpbase1,/row)
  val={kind:3L,style:0L}
  tmpbase3=widget_button(tmpbase2,value='Plot',uvalue=val)
  val={kind:3L,style:1L}
  tmpbase3=widget_button(tmpbase2,value='Animate',uvalue=val) 
  if (io.particle_nz gt 1) then begin
     tmpbase2=widget_base(tmpbase1,/row)
     tmpbase3=widget_label(tmpbase2,value='z:')
     val={kind:1L,direction:2L}
     maxx=max(global[0,*])
     dx=maxx/(io.particle_nz-1.)
     tmpbase3=CW_FSLIDER(tmpbase2,/double,value=0.,minimum=0.,$
         format='(F7.3,x,1hm)',maximum=maxx,scroll=dx,xsize=150,uvalue=val)
  endif  
  if (io.particle_nt gt 1) then begin
     val={kind:1L,direction:3L}
     tmpbase2=widget_base(tmpbase1,/row)
     tmpbase3=widget_label(tmpbase2,value='s:')
     maxt=max(profile[1,*])
     mint=min(profile[1,*])
     dt=(maxt-mint)/(io.particle_nt-1.)
     fmtstring='(E12.5,x,7hmicrons)'
     if info.isscan eq 1 then fmtstring='(E12.5,x,6h(scan))' 
     tmpbase3=CW_FSLIDER(tmpbase2,/double,value=0.,minimum=mint,$
         format=fmtstring,maximum=maxt,scroll=dt,xsize=150,uvalue=val)
  endif  
  tmpbase2=widget_base(tmpbase1,/row)
  tmpbase3=widget_label(tmpbase2,value="Radial:",/align_left)
  val={kind:8L,type:0L}
  tmpbase3=widget_button(tmpbase2,value='Profile',uvalue=val)
  val={kind:8L,type:1L}
  tmpbase3=widget_button(tmpbase2,value='Bunching',uvalue=val) 
endif


if ((io.field_nz gt 0) or (io.field_nt gt 0)) then begin
  tmpbase1=widget_base(tmpbase,/column,/frame)
  tmpbase2=widget_label(tmpbase1,value='Field',/align_left)
  tmpbase2=widget_base(tmpbase1,/row)
  val={kind:4L,direction:0L}
  tmpbase3=widget_button(tmpbase2,value='Near Field',uvalue=val)
  val={kind:4L,direction:1L} 
  tmpbase3=widget_button(tmpbase2,value='Far Field',uval=val)  
;
; create selection of harmonics if required

  if (info.hasharmonics) then begin
    tmpbase2=widget_base(tmpbase1,/row)
    lab=[' ',' ','1','2','3','4','5','6','7']
    for i=0,1 do begin
      tmpbase3=widget_label(tmpbase2,value=lab[i],xsize=20) 
    endfor 
    for i=2,8 do begin
      if (info.harmonics[i-2] ne 0) then begin
        tmpbase3=widget_label(tmpbase2,value=lab[i],xsize=20) 
      endif
    endfor 
    
    ord=[1,2,3,4,5,6,7]
    tmpbase2=widget_base(tmpbase1,/row)
    tmpbase3=widget_label(tmpbase2,value='harm:',xsize=40,/align_lef)
    tmpbase3=widget_base(tmpbase2,/exclusive,/row)
    for i=0,6 do begin
      val={kind:1L,direction:7L,id:ord[i],col:0L}
      if (info.harmonics[i] ne 0) then begin
        tmpbase4=widget_button(tmpbase3,xsize=20,value='',/no_release,uvalue=val)
        if (i eq 0) then widget_control,tmpbase4,/set_button
      endif
    endfor
  endif

; create slider along z direction

  if (io.field_nz gt 1) then begin
     val={kind:1L,direction:4L}
     tmpbase2=widget_base(tmpbase1,/row)
     tmpbase3=widget_label(tmpbase2,value='z:')
     maxx=max(global[0,*])
     dx=maxx/(io.field_nz-1.)
     tmpbase3=CW_FSLIDER(tmpbase2,/double,value=0.,minimum=0.,$
         format='(F7.3,x,1hm)',maximum=maxx,scroll=dx,xsize=150,uvalue=val)
  endif  
  if (io.field_nt gt 1) then begin
     val={kind:1L,direction:5L}
     tmpbase2=widget_base(tmpbase1,/row)
     tmpbase3=widget_label(tmpbase2,value='t:')
     maxt=max(profile[1,*])
     mint=min(profile[1,*])
     dt=(maxt-mint)/(io.field_nt-1.)
     fmtstring='(E12.5,x,7hmicrons)'
     if info.isscan eq 1 then fmtstring='(E12.5,x,6h(scan))' 
     tmpbase3=CW_FSLIDER(tmpbase2,/double,value=0.,minimum=mint,$
         format=fmtstring,maximum=maxt,scroll=dt,xsize=150,uvalue=val)

     tmpbase2=widget_base(tmpbase1,/row)
     val={kind:4L,direction:2L}
     tmpbase3=widget_button(tmpbase2,value='Proj. Near Field',uvalue=val)
     val={kind:4L,direction:3L} 
     tmpbase3=widget_button(tmpbase2,value='Proj. Far Field',uvalue=val) 
  endif  
endif


widget_control,tmpbase,/realize
tmpbase1=base.mainbase
xmanager,'xgen-second',tmpbase,GROUP_LEADER=tmpbase1,/no_block,$
          event_handler='plotevent_proc'


end
