pro xgenesis

;
;  xgenesis main routine
;

;
;   common blocks
;

common enviroment,env
common widget, base
;
;  initialize xgenesis and set color depth and table
;
        
preset

if (!version.os_family eq 'Windows') then begin
  env.platform='WIN'
endif else begin
  env.platform='X'
endelse

set_plot,env.platform
device,get_visual_depth=depth   ; old value
env.depth=depth
device,retain=2,decompose=0


loadct,1

;
;  create master widget
;


if xregistered('xgenesis') ne 0 then return

base.mainbase=widget_base(title='Xgenesis',mbar=tmpbase,tlb_frame_attr=1, $
                     /column,xoffset=50,yoffset=20)
base.menubase=tmpbase

create_widgets ; create window

tmpbase=base.mainbase
widget_control,tmpbase,/realize  ; realize window

xmanager,'xgenesis',tmpbase,/no_block

end
