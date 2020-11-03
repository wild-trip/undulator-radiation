pro create_widgets

common widget,base


;
;  menu bar
;

menulist=['1\File\menuevent_proc', $
	  '0\Open',$
	  '0\Reopen',$
          '2\Quit',$
          '1\Data\menuevent_proc',$
          '0\Raw File',$
	  '0\Info',$
	  '2\Export',$
          '1\IDL\menuevent_proc',$
          '0\Start iPlot',$
          '0\Load Color Table',$
          '2\Edit Color Table']

tmpbase=base.menubase
base.menuid=CW_PDMENU(tmpbase,menulist,/mbar,/return_name)

tmpbase=base.mainbase
tmpbase1=widget_base(tmpbase,/column,/frame)
tmpbase2=widget_label(tmpbase1,value='Plot-Style',/align_left)
tmpbase3=widget_base(tmpbase1,/exclusive,/column,event_pro='plotstyle_event_proc')
val={id:0L,value:0L}
tmpbase2=widget_button(tmpbase3,value='Normal',/no_release,uvalue=val)
widget_control,tmpbase2,/set_button
val={id:0L,value:1L}
tmpbase2=widget_button(tmpbase3,value='Averaged over s',/no_release,uvalue=val)
val={id:0L,value:2L}
tmpbase2=widget_button(tmpbase3,value='Maximum along z or s',/no_release,uvalue=val)
val={id:0L,value:3L}
tmpbase2=widget_button(tmpbase3,value='2D-Plot',/no_release,uvalue=val)
val={id:0L,value:4L}
tmpbase2=widget_button(tmpbase3,value='2D-Plot, normalized',/no_release,uvalue=val)

tmpbase1=widget_base(tmpbase,/column,/frame)
tmpbase2=widget_label(tmpbase1,value='2D Plot Options',/align_left)
tmpbase3=widget_base(tmpbase1,/exclusive,/column,event_pro='plotstyle_event_proc')
val={id:1L,value:0L}
tmpbase2=widget_button(tmpbase3,value='Grid',/no_release,uvalue=val)
widget_control,tmpbase2,/set_button
val={id:1L,value:1L}
tmpbase2=widget_button(tmpbase3,value='Surface',/no_release,uvalue=val)
val={id:1L,value:2L}
tmpbase2=widget_button(tmpbase3,value='Image',/no_release,uvalue=val)
val={id:1L,value:3L}
tmpbase2=widget_button(tmpbase3,value='Contour',/no_release,uvalue=val)


tmpbase1=widget_base(tmpbase,/column,/frame)
tmpbase2=widget_label(tmpbase1,value='Aux. Plot Options',/align_left)
tmpbase3=widget_base(tmpbase1,/nonexclusive,/column,event_pro='plotstyle_event_proc')
val={id:7L}
tmpbase2=widget_button(tmpbase3,value='Log Plot for P(z)',uvalue=val)
val={id:2L}
tmpbase2=widget_button(tmpbase3,value='Save Animation',uvalue=val)
val={id:8L}
tmpbase2=widget_button(tmpbase3,value='Animate also Spectrum',uvalue=val)
val={id:3L}
tmpbase2=widget_button(tmpbase3,value='Overplot 2D Plot',uvalue=val)
val={id:5L}
tmpbase2=widget_button(tmpbase3,value='S-Average for Sat.',uval=val)
val={id:6L}
tmpbase2=widget_button(tmpbase3,value='Use Bunching for Sat.',uval=val)
val={id:9L}
tmpbase2=widget_button(tmpbase3,value='Fixed Spectral Range [nm]',uval=val)
tmpbase2=widget_base(tmpbase1,/row,event_pro='plotstyle_event_proc')
val={id:10L}
base.specmin=widget_text(tmpbase2,value='0.0',/editable,xsize=10,uval=val)
tempbase3=widget_label(tmpbase2,value='-')
base.specmax=widget_text(tmpbase2,value='0.0',/editable,xsize=10,uval=val)
tmpbase2=widget_label(tmpbase1,value='Zoom of Field Plots',/align_left)
val={id:4L}
tmpbase2=widget_slider(tmpbase1,value=0,minimum=0,maximum=100,$
                        /suppress_value,xsize=100,uvalue=val,$
                           event_pro='plotstyle_event_proc')





return

end
