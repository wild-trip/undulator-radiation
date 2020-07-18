pro create_buttons


common widget,base
common data,record,global,profile,info
common file,io
common plot, setting,labels,asignment,par_label,asignment_old,asignment_new

; does it exist?

if xregistered('xgen-select') ne 0 then return

; set_up window

title=io.filename
tmpbase=widget_base(title=title,/column,tlb_frame_attr=1,$
         xoffset=270,yoffset=40)
base.buttonbase=tmpbase
; undulator bottons

tmpbase1=widget_base(tmpbase,/column,/frame)
tmpbase2=widget_label(tmpbase1,value='Undulator',/align_left)
tmpbase2=widget_base(tmpbase1,/row)
val={kind:2B,label:0L}
tmpbase3=widget_button(tmpbase2,value='Undulator',uvalue=val)
val={kind:2B,label:1L}
tmpbase3=widget_button(tmpbase2,value='Quadrupole',uvalue=val)

; main selection button

hasspectrum=0L

tmpbase1=widget_base(tmpbase,/column,/frame,space=-6)

asignment=asignment_old
if (info.version gt 1L) then begin
  asignment=asignment_new
end

for i=0,35 do begin
  if (asignment[i] ge 0) then begin
     idx=where(info.order eq asignment[i],count)
     if (count gt 0 ) then begin
        val1={kind:0B,label:i,column:idx,direction:0}
        val2={kind:0B,label:i,column:idx,direction:1}
        tmpbase2=widget_base(tmpbase1,/row)
        tmpbase3=widget_label(tmpbase2,value=labels[0,i],xsize=130,/align_left)
        tmpbase3=widget_button(tmpbase2,value='z',xsize=50,uvalue=val1)
        if (info.nt gt 1) then begin
          tmpbase3=widget_button(tmpbase2,value='s',xsize=50,uvalue=val2)  
        endif     
     endif
  endif else begin
    val1={kind:0B,label:i,column:asignment[i],direction:0B}
    val2={kind:0B,label:i,column:asignment[i],direction:1B}
    asign=asignment[i]
    if info.isscan ne 0 then asign = 0
    case asign of
       -1: begin ; spectrum
             idx=where((info.order eq 2) or (info.order eq 3),count)
  	     if ((count ge 2) and (info.nt gt 1) and (info.isscan eq 0)) then begin
     		tmpbase2=widget_base(tmpbase1,/row)
                tmpbase3=widget_label(tmpbase2,value=labels[0,i],xsize=183,/align_left)
                tmpbase3=widget_button(tmpbase2,value='lam',xsize=50,uvalue=val2)  
                hasspectrum=1L
             endif    
           end 
       -2:begin ; bandwidth
             idx=where((info.order eq 2) or (info.order eq 3),count)
  	     if ((count ge 2) and (info.nt gt 1) and (info.isscan eq 0)) then begin
     		tmpbase2=widget_base(tmpbase1,/row)
                tmpbase3=widget_label(tmpbase2,value=labels[0,i],xsize=130,/align_left)
                tmpbase3=widget_button(tmpbase2,value='z',xsize=50,uvalue=val1)
             endif    
          end
       -3:begin ; current
             if ((info.isscan eq 0) and (info.nt gt 1)) then begin
     		tmpbase2=widget_base(tmpbase1,/row)
                tmpbase3=widget_label(tmpbase2,value=labels[0,i],xsize=183,/align_left)
                tmpbase3=widget_button(tmpbase2,value='s',xsize=50,uvalue=val2)
	     endif
          end
       0: break
       -6: break
       else:begin
              print,'should not encounter'
            end  
    endcase 
  endelse
endfor

; create slider

if ((info.nz gt 1) and (info.nt gt 1)) then begin
  tmpbase2=widget_base(tmpbase1,/row)
  tmpbase3=widget_label(tmpbase2,value='z-position: ')
  base.zlabelbase=widget_label(tmpbase2,value=string(0,format='(f8.3)')+' m',xsize=140,/align_left)
  tmpbase2=widget_base(tmpbase1,/row)
  val1={kind:1B,direction:0B}
  tmpbase3=widget_slider(tmpbase2,value=0,minimum=0,maximum=info.nz-1,$
               /suppress_value,xsize=230,uvalue=val1)
  tmpbase2=widget_base(tmpbase1,/row)
  tmpbase3=widget_label(tmpbase2,value='s-position: ')
  tmpval=string(profile[1,0],format='(e12.5)')
  if (info.isscan eq 0) then begin
     cval=tmpval+' microns'
  endif else begin
     cval=tmpval+' (scan)'
  endelse
  base.slabelbase=widget_label(tmpbase2,value=cval,xsize=140,/align_left)
  tmpbase2=widget_base(tmpbase1,/row)
  val1={kind:1B,direction:1B}
  tmpbase3=widget_slider(tmpbase2,value=0,minimum=0,maximum=info.nt-1,$
               /suppress_value,xsize=230,uvalue=val1)
endif

tmpbase2=widget_base(tmpbase1,/row)
tmpbase3=widget_label(tmpbase2,value='Saturation',/align_left)
val={kind:7L,type:0}
tmpbase3=widget_button(tmpbase2,value='Power',uvalue=val)
val={kind:7L,type:1}
tmpbase3=widget_button(tmpbase2,value='Length',uvalue=val)

if ((info.nt gt 1) and (info.nz gt 1) and (info.isscan eq 0)) then begin
   val={kind:5L}
   tmpbase2=widget_button(tmpbase1,value='Animate Profile',uvalue=val)
endif

if (hasspectrum ne 0) then begin
   tmpbase2=widget_base(tmpbase1,/row)
   tmpbase3=widget_label(tmpbase2,value='Frog',/align_left)
   lab=['SHG','CCPG','CCSD']
   for i=0L,2L do begin
      val={kind:6L,trace:i}
      tmpbase3=widget_button(tmpbase2,value=lab[i],uvalue=val)
   endfor
endif

 
; create widget window

widget_control,tmpbase,/realize


tmpbase1=base.mainbase
xmanager,'xgen-select',tmpbase,GROUP_LEADER=tmpbase1,/no_block,$
          event_handler='plotevent_proc'

end
