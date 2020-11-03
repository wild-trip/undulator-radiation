pro menuevent_proc,event

common widget,base
common file,io


widget_control,event.id,get_uvalue=uval


case uval of
 "Open":begin
           if xregistered('xgen-select') ne 0 then begin
               widget_control,base.buttonbase,/destroy
           endif
           if xregistered('xgen-second') ne 0 then begin
               widget_control,base.buttonsecbase,/destroy
           endif
           readdata,base=event.top
           if (io.error eq 0) then begin
               create_buttons
               create_sec_button
           endif else begin
              print,'Error:'
              print,io.error_msg
           endelse
        end
 "Reopen":begin
           if xregistered('xgen-select') ne 0 then begin
             widget_control,base.buttonbase,/destroy
           endif
           if xregistered('xgen-second') ne 0 then begin
               widget_control,base.buttonsecbase,/destroy
           endif
           readdata,/reopen,base=event.top
           if (io.error eq 0) then begin
               create_buttons
	       create_sec_button
           endif else begin
              print,'Error:'
              print,io.error_msg
           endelse
          end
 "Quit":begin
	  widget_control,event.top,/destroy
	  return 
        end
 "Raw File":xdisplayfile,io.filename,group=event.top
 "Info":xinfo,group=event.top
 "Export":export_data
 "Start iPlot": iplot
 "Edit Color Table":xpalette
 "Load Color Table":xloadct
  else: Message, 'Error in Menuevent_proc'
endcase 

return
end
