pro plotstyle_event_proc,event

common widget,base
common plot, setting,labels,asignment,par_label,asignment_old,asignment_new


widget_control,event.id,get_uvalue=uval

case uval.id of
0: setting.plotoption=uval.value
1: setting.plotstyle2d=uval.value 
2: setting.save_ani=widget_info(event.id,/button_set) 
3: setting.overplot=widget_info(event.id,/button_set) 
4: begin
     widget_control,event.id,get_value=value
     setting.fzoom=value
   end
5: setting.calc_sat_average=widget_info(event.id,/button_set)
6: setting.calc_sat_bunching=widget_info(event.id,/button_set)
7: setting.logpower=widget_info(event.id,/button_set)
8: setting.inclspec=widget_info(event.id,/button_set)
9: setting.fixspec=widget_info(event.id,/button_set)
10:begin
   end
else:print,'something happened...'
endcase

return
end
