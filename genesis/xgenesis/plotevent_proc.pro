pro plotevent_proc,event

common widget,base
common data,record,global,profile,info
common file,io
common plot, setting,labels,asignment,par_label,asignment_old,asignment_new





widget_control,event.id,get_uvalue=uval

label={title:'',x:'',y:'',z:''}	

limitrange=0B


case uval.kind of
 0:begin ; normal buttons
                     		; get axis
       

       if uval.direction eq 0 then begin

         xaxis=reform(global[0,*])
	 label.x='z [m]'
	 minz=0
	 maxz=info.nz-1
         if maxz lt 0 then maxz = 0
         mint=setting.rect
	 maxt=setting.rect
        
       endif else begin

         xaxis=reform(profile[1,*])
	 label.x='s [!9m!Xm]'
	 if (uval.column eq -1) then begin 
                ; plotting frequency
		xaxis=reform(profile[2,*])
	        label.x='!9l!x [nm]'
                if (setting.fixspec ne 0) then begin
                  widget_control,base.specmin,get_value=value1
                  widget_control,base.specmax,get_value=value2
                  xtmp=[float(value1),float(value2)]
                  xrange=[min(xtmp),max(xtmp)]
                  if (xrange[1] gt max(xaxis)) then xrange[1]=max(xaxis)
                  if (xrange[1] le min(xaxis)) then xrange[1]=max(xaxis)
                  if (xrange[0] lt min(xaxis)) then xrange[0]=min(xaxis)
                  if (xrange[0] ge max(xaxis)) then xrange[0]=min(xaxis)           
                  limitrange=1B
                endif
         endif
         if (info.isscan ne 0) then label.x='Scan-Parameter'
	 minz=setting.recz
	 maxz=setting.recz
	 mint=0
	 maxt=info.nt-1
         if maxt lt 0 then maxt=0 

       endelse

       dolog=0
       if ((uval.direction eq 0) and (setting.logpower ne 0) and (uval.label eq 0)) then begin
         dolog=1
       endif
       label.title=labels[0,uval.label]       

       if (setting.plotoption eq 0) then begin ; simple plot
         plot_data=reform(get_data(uval.column,minz,maxz,mint,maxt))
       endif else begin
         plot_data=reform(process_data(setting.plotoption,uval.direction,uval.column))          
       endelse

;  actual plotting

       case size(plot_data,/n_dimensions) of
         1:begin  ; simple 2D plots
            label.y=labels[1,uval.label]  
            if (limitrange eq 0) then begin          
              plot_1d,plot_data,xaxis,label,overplot=setting.overplot, $
                      dolog=dolog
             endif else begin
              plot_1d,plot_data,xaxis,label,overplot=setting.overplot, $
                      dolog=dolog,xrange=xrange
             endelse
           end
         2: begin ; 2D images and 3D plot
	      yaxis=reform(global[0,*])
              label.y='z [m]'
              label.z=labels[1,uval.label]
              if (uval.direction eq 0) then begin 
                xaxis=reform(profile[1,*])
  	        label.x='s [!9m!Xm]'
	        if (uval.column eq -1) then begin 
	  	  xaxis=reform(profile[2,*])
	          label.x='!9l!x [nm]'
                endif
              endif
              plot_2d,plot_data,xaxis,yaxis,label,setting.plotstyle2d
            end
         else:return
       endcase 

     end
  1:begin  ; slider and selection button
       widget_control,event.id,get_value=value
       case uval.direction of
       0: begin
          setting.recz=value
          tmplabel=string(global[0,value],format='(f8.3)')+' m'
          widget_control,base.zlabelbase,set_value=tmplabel        
          end
       1: begin
          setting.rect=value
          tmplabel=string(profile[1,value],format='(e12.5)')
	  if (info.isscan eq 0) then begin
            tmplabel=tmplabel+' microns'
          endif else begin
            tmplabel=tmplabel+' (scan)'
          endelse 
          widget_control,base.slabelbase,set_value=tmplabel        
          end
       2: setting.particle_recz=fix(value*(io.particle_nz-1.)/max(global[0,*])+0.5)
       3: setting.particle_rect=fix((value-min(profile[1,*]))*(io.particle_nt-1.)/(max(profile[1,*])-min(profile[1,*]))+0.5)
       4: setting.field_recz=fix(value*(io.field_nz-1.)/max(global[0,*])+0.5)
       5: setting.field_rect=fix((value-min(profile[1,*]))*(io.field_nt-1.)/(max(profile[1,*])-min(profile[1,*]))+0.5)
       6: begin   ; selection of columns for particle plots
            if uval.col eq 0 then begin
	      setting.parx=uval.id
            endif else begin
              setting.pary=uval.id
            endelse
          end
       7: begin  ;selection of harmonics
            io.field_harmonic=uval.id
            io.field_enforceopen=1B
          end
       else: print,'Unknown slider!'  
       endcase
    end
   2: begin    ; undulator field
         plot_data=reform(global[1+uval.label,*])
         label.x='z [m]'
         xaxis=reform(global[0,*])
         case uval.label of
	   0: begin
                label.title='Undulator Field'
	        label.y='a!Lw!N'
	      end
	   1: begin
		label.title='Quadrupole Field'
		label.y='dB/dx [T/m]'
	      end
           else: print,'undulator field component not defined'
         endcase 
         plot_1d,plot_data,xaxis,label,overplot=setting.overplot,/histogram
      end
     3: begin    ; particle distribution
           if (uval.style eq 1) then begin
              animate_particle
              return
           end
           dist=readparticle(/keep_open)
           if io.error ne 0 then begin
              print,'Error:'
              print,io.error_msg
              return
           endif
           x=reform(dist[*,setting.parx])
           if (setting.parx eq 1) then begin
	     x=x+!pi
             x=x mod (2.*!pi)
             idx=where(x lt 0, count)
             if (count gt 0) then x[idx]=x[idx]+2.*!pi
             x=x-!pi
           endif 
           y=reform(dist[*,setting.pary])
           if (setting.pary eq 1) then begin
             y=y+!pi
             y=y mod (2.*!pi)
             idx=where(y lt 0, count)
             if (count gt 0) then y[idx]=y[idx]+2.*!pi
             y=y-!pi
           endif 
	   label.x=par_label[setting.parx]
	   label.y=par_label[setting.pary]
           plot_1d,y,x,label,/scatter
        end
      4: begin    ; field distribution
            ccol=dblarr(io.field_size,io.field_size)*0.
            iz=setting.field_recz
            if uval.direction gt 1 then begin
               n1=0
   	       n2=io.field_nt-1
            endif else begin
   	       n1=setting.field_rect
	       n2=n1
            endelse
                           
	    for it=n1,n2 do begin
	      cdata=readfield(iz,it,/keep_open)
              if io.error ne 0 then begin
                print,'Error:'
                print,io.error_msg
                return
              endif
              gcenter=(io.field_size+1)/2
              gsize=gcenter-1
              if (uval.direction eq 1) or (uval.direction eq 3) then begin
                cdata=fft(cdata,/double,/overwrite,/inverse)
	        cdata=shift(cdata,gcenter,gcenter)
              endif
              ccol=ccol+abs(cdata)^2
	    endfor

            gsize=fix(gsize*(1.-0.01*setting.fzoom))
            if gsize le 0 then gsize=1
            gcenter=gcenter-1 
            data=ccol[gcenter-gsize:gcenter+gsize,gcenter-gsize:gcenter+gsize]
 	    xaxis=dindgen(2L*gsize+1)
            yaxis=xaxis
            label.x='x-plane'
            label.y='y-plane'
            plot_2d,data,xaxis,yaxis,label,setting.plotstyle2d
         end
        5: animate_profile
        6: begin
             colf=-1
             cola=-1
             idx=where(info.order eq 2,count)
             if count gt 0 then cola=idx 
             idx=where(info.order eq 3,count)
             if count gt 0 then colf=idx
             if ((cola lt 0) or (colf lt 0)) then return
             nz=setting.recz
             phase=reform(record[colf,nz,*])
             amp=reform(record[cola,nz,*])
             signal=complex(cos(phase),sin(phase))*sqrt(amp)
             trace=frog(signal,uval.trace)
             result=size(trace)
             if result[0] eq 0 then return
             xaxis=dindgen(result[1])
             yaxis=dindgen(result[2])
             label.x='time'
	     label.y='spectrum'
 	     label.z='P(!(t!X,!9w!X) [a.u.]
	     label.title='Frog Trace'
             plot_2d,trace,xaxis,yaxis,label,setting.plotstyle2d
           end
        7: saturation_analyse,uval.type
        8: radial,uval.type
  else:print,'unknown event'
endcase

return
end
