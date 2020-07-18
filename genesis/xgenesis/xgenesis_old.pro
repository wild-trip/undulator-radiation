;###########################################################################
;
;   Common Blocks
;
;##########################################################################

;-----------------------------------------------------------------------------
;
PRO PRESET
;`
;  Clear the data array
;
COMMON WIDGETCOM, WIDGETINFO,DRAWINFO,XPL,YPL,ZPL,genhelp,xgenhelp,idlhelp
COMMON DATCOM, RECORD,CUR,BANDW,PSPEC,GAIN,DIVER,ERROR,WHALF,BUNCH,PHASE,XRMS,$
	              YRMS,MIDP,LOGP,GAMM,AW,ZOUT,TOUT,FOUT,H2OUT,H3OUT,$
                      H4OUT,H5OUT,SIGGAM,XAVG,YAVG,FFLD
COMMON PARTCOM, GAM,PHI,XPOS,YPOS,PXPOS,PYPOS
COMMON RADCOM, FIELDR,FIELDI
;
;
CUR=0.     ;current   (t)
BANDW=0.   ;bandwidth (z)
PSPEC=0.   ;spectrum  (f,z)
GAIN=0.    ;radiation power (t,z) 
DIVER=0.   ;diffraction angle (z,t)
ERROR=0.   ;energy conservation (z,t) 	
WHALF=0.   ;radiation size (z,t)
BUNCH=0.   ;bunching factor (z,t) 
PHASE=0.   ;central phase (z,t)
XRMS=0.    ;beam size in x (z,t)
YRMS=0.	   ;beam size in y (z,t)
MIDP=0.    ;central power (z,t)
LOGP=0.    ;log differential gain (z,t)
GAMM=0.	   ;beam energy (z,t)
AW=0.      ;wiggler field (z)
H2OUT=0.   ;2nd harmonic of bunching (z,t)
H3OUT=0.   ;3rd harmonic of bunching (z,t)
H4OUT=0.   ;4th harmonic of bunching (z,t)
H5OUT=0.   ;5th harmonic of bunching (z,t)
XAVG=0.    ;Beam Position in x
YAVG=0.    ;Beam Position in y
FFLD=0.    ;Far Field on axis
SIGGAM=0.  ;energy spread 
;
GAM=0.     ;Particle Energy
PHI=0.     ;Particle Phase
XPOS=0.    ;Particle X-Position
YPOS=0.    ;Particle Y-Position
PXPOS=0.   ;Particle Px-Momentum
PYPOS=0.   ;Particle Py-Momentum
;
FIELDR=0.  ;Radiation Field - real part
FIELDI=0.  ;Radiation Field - imaginary part
FIELD=0.   ;Selected Field 
;
RECORD={NSLICE:0L,$   ;# of slice 
	ISLICE:0L,$   ;current slice
	NZ:0L,$	      ;# of history entries
	IZ:0L,$       ;current history
	NPART:0L,$    ;# of particlres
	NCAR:0L,$     ;radiation mesh size	
	NFLDZ:0L,$    ;# of radiation records in z
	IFLDZ:0L,$    ;current record
	NFLDS:0L,$    ;# of radiation recors in t
	IFLDS:0L,$    ;current record
	NPARZ:0L,$    ;next 4 entries the same for particles 
	IPARZ:0L,$
	NPARS:0L,$
	IPARS:0L,$
	IPMODE:0L,$   ;mode for t-z plots
        IPARCOL:0L,$  ;color for particle scatter plot
        IFLDMOD:0L,$  ;plotting mode for radiation profile
        IFLDSUB:1L,$  ;size of mesh to be plotted
	XLAMDS:1.,$   ;radiation wavelength
	DXY:1.,$      ;mesh size	
        LOUT:INDGEN(19)*0L,$ ;Flags for output parameter
        CPATH:'',$    ;filepath
	CFILE:''}     ;input file
RETURN
END


;############################################################################
;
;  Small Windows for Dialog   
;
;#############################################################################



;--------------------------------------------------------------------------
;
PRO PRINT_EVENT,event
;
; Event : PRINT
;
COMMON PRINTCOM, PRINTINFO
COMMON WIDGETCOM
COMMON DATCOM
;
IF (TAG_NAMES(event,/STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL,printInfo.top,/DESTROY
    RETURN	
ENDIF
;
WIDGET_CONTROL,event.id, GET_UVALUE=uval
CASE uval of
'PRCMD'   :BEGIN
             WIDGET_CONTROL,event.id,GET_VALUE=ctmp
	     PrintInfo.DEFCOM=ctmp(0)
	   END
'PRFLE'   :BEGIN
             WIDGET_CONTROL,event.id,GET_VALUE=ctmp
	     PrintInfo.DEFFLE=ctmp(0)
	   END
'PTYPE'   :PrintInfo.Type=event.index
'PBROWSE' :BEGIN
             ctmp=DIALOG_PICKFILE(GROUP=base,/WRITE)
             IF ctmp EQ '' THEN RETURN
             PrintInfo.DEFFLE=ctmp
	     WIDGET_CONTROL,PrintInfo.File,SET_VALUE=ctmp	
           END
'TOPRNT'  :Begin
             PrintInfo.DEST=0L
             WIDGET_CONTROL,Printinfo.base1,/MAP
             WIDGET_CONTROL,Printinfo.base2,MAP=0
           END
'TOFILE'  :BEGIN
             PrintInfo.DEST=1L
             WIDGET_CONTROL,Printinfo.base1,MAP=0
             WIDGET_CONTROL,Printinfo.base2,/MAP
           END
'CANPRINT':WIDGET_CONTROL,printInfo.top,/DESTROY
'EXEPRINT':BEGIN
              OLDNAME=!D.NAME
              cfile=PrintInfo.DEFFLE
              IF PrintInfo.DEST EQ 0 THEN cfile='idl.ps'
              DrawInfo.DEV=1
              Color=0L
              IF DrawInfo.Flag EQ 2 THEN Color=1L       
              Encap=0L
	      If PrintInfo.Type EQ 1 THEN Encap=1L
              IF PrintInfo.Type NE 2 THEN BEGIN
                 SET_PLOT,'PS'
                 DEVICE,FILE=cfile,ENCAPSULATED=Encap,COLOR=Color
                 DOPLOT
                 DEVICE, /CLOSE
                 SET_PLOT,OLDNAME
              ENDIF ELSE BEGIN
                 WRITE_jpeg,cfile,TVRD()                              
              ENDELSE
              IF PrintInfo.DEST EQ 0 THEN BEGIN
                 SPAWN, PrintInfo.DEFCOM+' '+cfile
                 SPAWN, 'rm '+cfile
              ENDIF 
              DrawInfo.DEV=0 
              WIDGET_CONTROL,printInfo.top,/DESTROY
           END
ENDCASE
RETURN
END

;--------------------------------------------------------------------------
;
PRO DOPRINT, GROUP=GROUP,DEFCOM=DEFCOM,DEFFLE=DEFFLE
;
; Create Print Dialog Box
;
COMMON PRINTCOM
;
PrintInfo={DEFCOM:'lpr',$
	   DEFFLE:'idl.ps',$
	   DEST:0L,$
           TOP:0L,$
           TYPE:0L,$
           FILE:0L,$
	   ORIENTATION:0L,$
           BASE1:0L,$
           BASE2:0L}
;
IF KEYWORD_SET(DEFCOM) THEN PrintInfo.DEFCOM=DEFCOM	   
IF KEYWORD_SET(DEFFLE) THEN PrintInfo.DEFFLE=DEFFLE	   
;
IF xregistered('doprint') NE 0 THEN RETURN
;
; create bases
;
mainPrintBase=WIDGET_BASE(TITLE='Print Document',/COLUMN,$
                        /TLB_KILL_REQUEST_EVENT,MAP=0)
;
Printbase1=WIDGET_BASE(mainPrintBase,/COLUMN)
Printstream=WIDGET_BASE(Printbase1,/ROW,/EXCLUSIV)
PrintButton1=WIDGET_BUTTON(printstream,VALUE='To Printer',UVALUE='TOPRNT',YSIZE=YTMP)
PrintButton2=WIDGET_BUTTON(printstream,VALUE='To File   ',UVALUE='TOFILE',YSIZE=YTMP)
;
Printtoprint=WIDGET_BASE(Printbase1,/ROW,/MAP)
PrintInfo.BASE1=printtoprint
Printlab=WIDGET_LABEL(Printtoprint,VALUE='Command')
Printtext=WIDGET_TEXT(Printtoprint,VALUE=printInfo.defcom,UVALUE='PRCMD',$
                       XSIZE=20,/EDITABLE,/ALL_EVENTS)
;
Printtofile=WIDGET_BASE(Printbase1,/ROW,MAP=0)
PrintInfo.base2=printtofile
Printlab=WIDGET_LABEL(Printtofile,VALUE='File')
Printtext1=WIDGET_TEXT(Printtofile,VALUE=printinfo.deffle,UVALUE='PRFLE',$
                       XSIZE=20,/EDITABLE,/ALL_EVENTS)
Printbut=WIDGET_BUTTON(PrintToFIle,VALUE='Browse...',UVALUE='PBROWSE')
VALUES=['PS','EPS','GIF']
Printlist=WIDGET_DROPLIST(PrinttoFile,VALUE=VALUES,UVALUE='PTYPE')	
;
PrintBottom=Widget_Base(mainPrintBase,/ROW)
PrintButton=Widget_Button(PrintBottom,VALUE='Print',UVALUE='EXEPRINT')
PrintButton=Widget_Button(PrintBottom,VALUE='Cancel',UVALUE='CANPRINT')
;
WIDGET_CONTROL,mainPrintBase,/REALIZE,/MAP
WIDGET_CONTROL,PrintButton1,/SET_BUTTON
PrintInfo.TOP=mainPrintBase
PrintInfo.FILE=Printtext1
;
XMANAGER, 'doprint',mainPrintBase,GROUP_LEADER=GROUP,EVENT_HANDLER='print_event',/NO_BLOCK
END

;--------------------------------------------------------------------------
;
PRO STAT_EVENT,event
;
;  Dismis Widget
;
IF (TAG_NAMES(event,/STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL,printInfo.top,/DESTROY
    RETURN	
ENDIF
WIDGET_CONTROL,event.id,GET_UVALUE=mainbase
WIDGET_CONTROL,mainbase,/DESTROY
RETURN
END

;-------------------------------------------------------------------------------
;
PRO STATISTIC, GROUP=GROUP
;
;   Print some information on screen
;
COMMON DATCOM
;
IF XREGISTERED('statistic') NE 0 THEN RETURN
;
mainStatBase=WIDGET_BASE(TITLE='File Information',/COLUMN,$
                        /TLB_KILL_REQUEST_EVENT,MAP=0)
;
StatBase=WIDGET_BASE(mainStatBase,COLUMN=2,/GRID_LAYOUT)
base=WIDGET_LABEL(StatBase,VALUE='File',/ALIGN_LEFT)
base=WIDGET_LABEL(StatBase,VALUE='Run Type',/ALIGN_LEFT)
base=WIDGET_LABEL(StatBase,VALUE='Parameter',/ALIGN_LEFT)
base=WIDGET_LABEL(StatBase,VALUE='Records in z',/ALIGN_LEFT)
If record.NSLICE GT 1 THEN base=WIDGET_LABEL(StatBase,Value='Records in t',/ALIGN_LEFT)
base=WIDGET_LABEL(StatBase,VALUE='Field Record',/ALIGN_LEFT)
If record.NFLDZ GT 0 THEN BEGIN
   base=WIDGET_LABEL(StatBase,VALUE='Records in z',/ALIGN_LEFT)
   If record.NFLDS GT 1 THEN base=WIDGET_LABEL(StatBase,VALUE='Records in s',/ALIGN_LEFT)
ENDIF
base=WIDGET_LABEL(StatBase,VALUE='Particle Record',/ALIGN_LEFT)
If record.NPARZ GT 0 THEN BEGIN
   base=WIDGET_LABEL(StatBase,VALUE='Records in z',/ALIGN_LEFT)
   If record.NFLDS GT 1 THEN base=WIDGET_LABEL(StatBase,VALUE='Records in s',/ALIGN_LEFT)
ENDIF

base=WIDGET_TEXT(StatBase,VALUE=record.cfile,XSIZE=12)
ctmp='Single Run'
If record.NSLICE GT 1 THEN ctmp='Several Runs'
base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
ctmp=STRING(LONG(TOTAL(record.LOUT)))
base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
ctmp=STRING(record.NZ)
base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
If record.NSLICE GT 1 THEN BEGIN
  ctmp=STRING(record.NSLICE)
  base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
ENDIF
CTMP='None'
IF record.NFLDZ GT 0 THEN CTMP='Generated'
base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
IF record.NFLDZ GT 0 THEN BEGIN
   CTMP=STRING(record.NFLDZ)
   base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
   IF record.NFLDS GT 1 THEN BEGIN
      CTMP=STRING(record.NFLDS)
      base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
   ENDIF
ENDIF
CTMP='None'
IF record.NPARZ GT 0 THEN CTMP='Generated'
base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
IF record.NPARZ GT 0 THEN BEGIN
   CTMP=STRING(record.NPARZ)
   base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
   IF record.NPARS GT 1 THEN BEGIN
      CTMP=STRING(record.NPARS)
      base=WIDGET_TEXT(StatBase,VALUE=ctmp,XSIZE=12)
   ENDIF
ENDIF

base=WIDGET_BUTTON(mainstatbase,VALUE='DONE',UVALUE=mainstatbase)
WIDGET_CONTROL,mainStatBase,/REALIZE,/MAP
;
XMANAGER,'statistic',mainStatBase,GROUP_LEADER=GROUP,Event_Handler='stat_event',/NO_BLOCK
END

;--------------------------------------------------------------------------
;
PRO LABEL_EVENT,event
;
;  Set Label
;
COMMON WIDGETCOM
COMMON LABELCOM, setlabelbase,tmplx,tmply,tmplt,oldlx,oldly,oldlt
;
IF (TAG_NAMES(event,/STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL,setlabelbase,/DESTROY
    RETURN	
ENDIF
WIDGET_CONTROL,event.id,GET_UVALUE=uval
CASE uval of
'LABX':WIDGET_CONTROL,event.id,GET_VALUE=tmplx
'LABY':WIDGET_CONTROL,event.id,GET_VALUE=tmply
'LABT':WIDGET_CONTROL,event.id,GET_VALUE=tmplt
'DOLB':BEGIN
       DrawInfo.xtitle=tmplx(0)
       DrawInfo.ytitle=tmply(0)
       DrawInfo.title=tmplt(0)
       DOPLOT
       WIDGET_CONTROL,setlabelbase,/DESTROY
       END
'RFLB':BEGIN
       DrawInfo.xtitle=tmplx(0)
       DrawInfo.ytitle=tmply(0)
       DrawInfo.title=tmplt(0)
       DOPLOT
       END
'CALB':BEGIN
       DrawInfo.xtitle=oldlx
       DrawInfo.ytitle=oldly
       DrawInfo.title=oldlt
       DOPLOT
       WIDGET_CONTROL,setlabelbase,/DESTROy
       END
ELSE:RETURN
ENDCASE
RETURN
END

;-------------------------------------------------------------------------------
;
PRO SETLABEL, GROUP=GROUP
;
;   Widget for changing labels
;
COMMON WIDGETCOM
COMMON LABELCOM
;
If DrawInfo.flag EQ 0 THEN RETURN
IF XREGISTERED('SETLABEL') NE 0 THEN RETURN
;
setlabelBase=WIDGET_BASE(TITLE='Plot Label',/COLUMN,$
                        /TLB_KILL_REQUEST_EVENT,MAP=0)
;
tmplx=DrawInfo.xtitle
tmply=DrawInfo.ytitle
tmplt=DrawInfo.title
oldlx=tmplx
oldly=tmply
oldlt=tmplt
;
labBase=WIDGET_BASE(SetlabelBase,COLUMN=2,/GRID_LAYOUT)
base=WIDGET_LABEL(labBase,VALUE='Title',/ALIGN_LEFT)
base=WIDGET_LABEL(labBase,VALUE='X-Axis',/ALIGN_LEFT)
base=WIDGET_LABEL(labBase,VALUE='Y-Axis',/ALIGN_LEFT)
;
base=WIDGET_TEXT(labBase,VALUE=tmplt,UVALUE='LABT',XSIZE=20,/EDITABLE,/ALL_EVENTS)
base=WIDGET_TEXT(labBase,VALUE=tmplx,UVALUE='LABX',XSIZE=20,/EDITABLE,/ALL_EVENTS)
base=WIDGET_TEXT(labBase,VALUE=tmply,UVALUE='LABY',XSIZE=20,/EDITABLE,/ALL_EVENTS)
;
labbase=WIdget_Base(setlabelbase,/ROW)
base=WIDGET_BUTTON(labbase,VALUE='Refresh',UVALUE='RFLB')
base=WIDGET_BUTTON(labbase,VALUE='Done',UVALUE='DOLB')
base=WIDGET_BUTTON(labbase,VALUE='Cancel',UVALUE='CALB')
;
WIDGET_CONTROL,setlabelBase,/REALIZE,/MAP
;
XMANAGER,'SETLABEL',setlabelBase,GROUP_LEADER=GROUP,Event_Handler='label_event',/NO_BLOCK
END



;--------------------------------------------------------------------------
;
PRO LINE_EVENT,event
;
;  Set Line
;
COMMON WIDGETCOM
COMMON LINECOM, setlinebase,tmpln1,tmpln2,oldln1,oldln2
;
IF (TAG_NAMES(event,/STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL,setlinebase,/DESTROY
    RETURN	
ENDIF
WIDGET_CONTROL,event.id,GET_UVALUE=uval
CASE uval of
'LIN1':BEGIN
         WIDGET_CONTROL,event.id,GET_VALUE=ctmp
         tmpln1=FLOAT(CTMP(0))
       END
'LIN2':tmpln2=event.index
'DOLN':BEGIN
       DrawInfo.LINEWIDTH=tmpln1
       DrawINfo.LINESTYLE=tmpln2 
       DOPLOT
       WIDGET_CONTROL,setlinebase,/DESTROY
       END
'RFLN':BEGIN
       DrawInfo.LineWIDTH=tmpln1
       DrawINfo.LINESTYLE=tmpln2 
       DOPLOT
       END
'CALN':BEGIN
       DrawInfo.LINEWIDTH=oldln1
       DrawINfo.LINESTYLE=oldln2 
       WIDGET_CONTROL,setlinebase,/DESTROY
       END
ELSE:RETURN
ENDCASE
RETURN
END

;-------------------------------------------------------------------------------
;
PRO SETLINE, GROUP=GROUP
;
;   Print some information on screen
;
COMMON WIDGETCOM
COMMON LINECOM
;
If DrawInfo.flag EQ 0 THEN RETURN
IF XREGISTERED('SETLINE') NE 0 THEN RETURN
;
setlineBase=WIDGET_BASE(TITLE='Set Line',/COLUMN,$
                        /TLB_KILL_REQUEST_EVENT,MAP=0)
;
tmpln1=DrawInfo.Linewidth
tmpln2=DrawInfo.Linestyle
oldln1=tmpln1
oldln2=tmpln2
;
lineBase=WIDGET_BASE(SetlineBase,COLUMN=2,/GRID_LAYOUT)
base=WIDGET_LABEL(lineBase,VALUE='Thickness',/ALIGN_LEFT)
base=WIDGET_LABEL(lineBase,VALUE='Style',/ALIGN_LEFT)
;
base=WIDGET_TEXT(lineBase,VALUE=STRING(tmpln1),UVALUE='LIN1',XSIZE=6,/EDITABLE,/ALL_EVENTS)
VALUES=['Solid','Dotted','Dashed','Dash Dot','Dash 3*Dot','Long Dashes']
base=WIDGET_DROPLIST(linebase,VALUE=VALUES,UVALUE='LIN2')
WIDGET_CONTROL,base,SET_DROPLIST_SELECT=tmpln2
;
linebase=WIdget_Base(setlinebase,/ROW)
base=WIDGET_BUTTON(linebase,VALUE='Refresh',UVALUE='RFLN')
base=WIDGET_BUTTON(linebase,VALUE='Done',UVALUE='DOLN')
base=WIDGET_BUTTON(linebase,VALUE='Cancel',UVALUE='CALN')
;
WIDGET_CONTROL,setlineBase,/REALIZE,/MAP
;
XMANAGER,'SETLINE',setLineBase,GROUP_LEADER=GROUP,Event_Handler='line_event',/NO_BLOCK
END

;--------------------------------------------------------------------------
;
PRO FONT_EVENT,event
;
;  Set Font
;
COMMON WIDGETCOM
COMMON FONTCOM, setFONTbase,tmpfn1,tmpfn2,oldfn1,oldfn2
;
IF (TAG_NAMES(event,/STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL,setfontbase,/DESTROY
    RETURN	
ENDIF
WIDGET_CONTROL,event.id,GET_UVALUE=uval
CASE uval of
'FON1':BEGIN
         WIDGET_CONTROL,event.id,GET_VALUE=ctmp
         tmpfn1=FLOAT(CTMP(0))
       END
'FON2':tmpfn2=event.index-1
'DOFN':BEGIN
       DrawInfo.FONTSIZE=tmpfn1
       DrawINfo.FONTMODE=tmpfn2 
       DOPLOT
       WIDGET_CONTROL,setfontbase,/DESTROY
       END
'RFFN':BEGIN
       DrawInfo.FONTSIZE=tmpfn1
       DrawINfo.FONTMODE=tmpfn2 
       DOPLOT
       END
'CAFN':BEGIN
       DrawInfo.FONTSIZE=oldfn1
       DrawINfo.FONTMODE=oldfn2 
       WIDGET_CONTROL,setfontbase,/DESTROY
       END
ELSE:RETURN
ENDCASE
RETURN
END

;-------------------------------------------------------------------------------
;
PRO SETFONT, GROUP=GROUP
;
;   Print some information on screen
;
COMMON WIDGETCOM
COMMON FONTCOM
;
If DrawInfo.flag EQ 0 THEN RETURN
IF XREGISTERED('SETFONT') NE 0 THEN RETURN
;
setfontBase=WIDGET_BASE(TITLE='Set Font',/COLUMN,$
                        /TLB_KILL_REQUEST_EVENT,MAP=0)
;
tmpfn1=DrawInfo.FONTSIZE
tmpfn2=DrawInfo.FONTMODE
oldfn1=tmpfn1
oldfn2=tmpfn2
;
fontBase=WIDGET_BASE(SetfontBase,COLUMN=2,/GRID_LAYOUT)
base=WIDGET_LABEL(fontBase,VALUE='Size',/ALIGN_LEFT)
base=WIDGET_LABEL(fontBase,VALUE='Type',/ALIGN_LEFT)
;
base=WIDGET_TEXT(fontBase,VALUE=STRING(tmpfn1),UVALUE='FON1',XSIZE=6,/EDITABLE,/ALL_EVENTS)
VALUES=['Vector','System']
base=WIDGET_DROPLIST(fontbase,VALUE=VALUES,UVALUE='FON2')
WIDGET_CONTROL,base,SET_DROPLIST_SELECT=tmpfn2+1
;
fontbase=WIdget_Base(setfontbase,/ROW)
base=WIDGET_BUTTON(fontbase,VALUE='Refresh',UVALUE='RFFN')
base=WIDGET_BUTTON(fontbase,VALUE='Done',UVALUE='DOFN')
base=WIDGET_BUTTON(fontbase,VALUE='Cancel',UVALUE='CAFN')
;
base=WIDGET_LABEL(setfontbase,VALUE='Hardware font may not be',/ALIGN_LEFT)
base=WIDGET_LABEL(setfontbase,VALUE='displayed correctly on',/ALIGN_LEFT)
base=WIDGET_LABEL(setfontbase,VALUE='Screen. Use !9-Command',/ALIGN_LEFT)
base=WIDGET_LABEL(setfontbase,VALUE='for Greek Characters.',/ALIGN_LEFT)

WIDGET_CONTROL,setfontBase,/REALIZE,/MAP
;
XMANAGER,'SETFONT',setFontBase,GROUP_LEADER=GROUP,Event_Handler='font_event',/NO_BLOCK
END


;--------------------------------------------------------------------------
;
PRO MESH_EVENT,event
;
;  Set Radiation Meshsize
;
COMMON WIDGETCOM
COMMON DATCOM
COMMON MESHCOM, setmeshbase
;
IF (TAG_NAMES(event,/STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL,event.id,/DESTROY
    RETURN	
ENDIF
WIDGET_CONTROL,event.id,GET_UVALUE=uval
CASE uval of
'SETM':BEGIN
         WIDGET_CONTROL,event.id,GET_VALUE=ival
         record.IFLDSUB=ival
       END
ELSE:WIDGET_CONTROL,setmeshbase,/DESTROY
ENDCASE
RETURN
END

;-------------------------------------------------------------------------------
;
PRO SETMESH, GROUP=GROUP
;
;   Print some information on screen
;
COMMON WIDGETCOM
COMMON DATCOM
COMMON MESHCOM
 ;
If record.ncar LT 2 THEN RETURN
IF XREGISTERED('SETMESH') NE 0 THEN RETURN
;
setmeshBase=WIDGET_BASE(TITLE='Set',/COLUMN,$
                        /TLB_KILL_REQUEST_EVENT,MAP=0)
;
base=WIDGET_LABEL(setmeshBase,VALUE='Gridpoints')
base=WIDGET_SLIDER(setmeshbase,VALUE=record.ifldsub,MIN=1,MAX=record.ncar,UVALUE='SETM')
base=WIDGET_BUTTON(setmeshbase,VALUE='DONE',UVALUE='DOMS')
;
WIDGET_CONTROL,setmeshBase,/REALIZE,/MAP
;
XMANAGER,'SETMESH',setmeshBase,GROUP_LEADER=GROUP,Event_Handler='mesh_event',/NO_BLOCK
END
;
;
;###########################################################################
;
;   Plotting
;
;##########################################################################

;-----------------------------------------------------------------------------
;
PRO DOPLOT
;
; Plot using the UVALUE of the draw widget
;
COMMON WIDGETCOM
;
; Get Plot data and set plot parameter
;
!P.TITLE=DrawInfo.TITLE
!X.TITLE=DrawInfo.XTITLE
!Y.TITLE=DrawInfo.YTITLE
!P.THICK=DrawInfo.LINEWIDTH
!P.CHARSIZE=DrawInfo.FONTSIZE
!P.LINESTYLE=DrawInfo.LINESTYLE
!P.FONT=DrawInfo.FONTMODE
;
; check for different plot mode
;
CASE DrawInfo.flag of
0:RETURN                              ; no plot stored 
1:BEGIN                               ; simple x-y plot or scatter plot if Psym is selected
  !P.PSYM=DrawInfo.psym
  IF (DrawInfo.psym GT 0 AND DrawInfo.psym LT 10) THEN BEGIN
    PLOT,XPL,YPL,/NODATA ,/YNOZERO  
    A=STRING(INDGEN(N_ELEMENTS(ZPL)))
    A='.'
    XYOUTS,XPL,YPL,A,COLOR=ZPL
  ENDIF ELSE BEGIN
    CASE DrawInfo.LOG OF                    
    1    : PLOT_IO,XPL,YPL            ;-> log scale  
    ELSE : PLOT,XPL,YPL               ;-> lin scale
    ENDCASE
  ENDELSE 
  RETURN
  END
2:BEGIN                                ; image plot
    IF DrawInfo.DEV EQ 1 THEN BEGIN            ;plot to a non-screen device
       DX=MAX(XPL)-MIN(XPL)           ;size of plot
       DY=MAX(YPL)-MIN(YPL)
       PLOT, XPL, YPL, /NODATA,YSTYLE=9,XSTYLE=9,TICKLEN=-0.02 ;draw axis
       POSARR=!P.POSITION             ;get position of axis
       TV, ZPL,XPL(0),YPL(0),XSIZE=DX,YSIZE=DY,/DATA   ;plot image
    ENDIF ELSE BEGIN                  ;plot to screen
       DX=N_ELEMENTS(ZPL(*,0))        ;size of 2d array
       DY=N_ELEMENTS(ZPL(0,*))
       XORG=FIX((!D.X_SIZE-DX)/2)     ;origin of image
       YORG=FIX((!D.Y_SIZE-DY)/2)
       IF XORG LT 0 THEN XORG = 0     ;check case of image > display
       IF YORG LT 0 THEN YORG = 0
       POSARR=[XORG,YORG,XORG+DX,YORG+DY]    ;position of image
       PLOT, XPL, YPL,POSITION=POSARR,/DEVICE,/NODATA,YSTYLE=1  ;clear screen
       TV, ZPL, POSARR(0), POSARR(1), /DEVICE                   ;plot image
       PLOT, XPL, YPL,POSITION=POSARR,/DEVICE,/NODATA,/NOERASE,YSTYLE=1 ;draw axis
    ENDELSE
  RETURN
  END
3:BEGIN    
    !Z.TITLE=drawinfo.ztitle                             ; surface plot    
    SURFACE, ZPL, /SAVE,YSTYLE=5,XSTYLE=5
    PLOT,XPL,YPL,/T3D,/NODATA,/NOERASE,TITLE='',XSTYLE=9,YSTYLE=9
    !Z.TITLE=''  
    RETURN
  END
ELSE:BEGIN 
      !Z.TITLE=drawinfo.ztitle 
      SHADE_SURF,ZPL,/SAVE,YSTYLE=5,XSTYLE=5
      PLOT,XPL,YPL,/T3D,/NODATA,/NOERASE,TITLE='',XSTYLE=9,YSTYLE=9
      !Z.TITLE=''  
      RETURN 
     END
ENDCASE

RETURN
END

;---------------------------------------------------------------------------------------
;
PRO PLOT_2D,zdat,nx,ny,NORM=NORM
;
; Creates the Image for 2d-color plots 
;
COMMON WIDGETCOM
;
zpl=TRANSPOSE(zdat)
IF KEYWORD_SET(NORM) THEN BEGIN
   FOR i=0,ny-1 DO BEGIN
      zpl(*,i)=zpl(*,i)/MAX(zpl(*,i))
   ENDFOR
ENDIF
EXPAND,zpl,LONG(0.8*DrawInfo.xsize),LONG(0.8*Drawinfo.ysize),ztmp
zpl=0B
zpl=BYTSCL(Ztmp,TOP=!D.TABLE_SIZE-1)
ztmp=0.
;zpl(*,0)=0B
DrawInfo.flag=2
DOPLOT
RETURN
END 

;---------------------------------------------------------------------------------------
;
PRO INIT_PLOT,xdat,ydat,lti,lx,ly,LOG=LOG,NORM=NORM
;
;   Fill plot record with simple y vs x plot or 2d images
;
COMMON WIDGETCOM
COMMON DATCOM
;
DrawInfo.title=lti
DrawInfo.xtitle=lx
DrawInfo.ytitle=ly
DrawInfo.log=0L
IF KEYWORD_SET(LOG) THEN DrawInfo.log=1L
DrawInfo.psym=0L
DrawInfo.flag=1L
xpl=xdat
ZPL=0.
YSIZ=SIZE(ydat)
IF KEYWORD_SET(NORM) EQ 0 THEN NORM=0
CASE NORM OF
0: ypl=REFORM(ydat)
1: BEGIN
      ypl=FINDGEN(YSIZ(1))
      FOR i=0,YSIZ(1)-1 DO BEGIN
          ypl(i)=TOTAL(ydat(i,*))/DOUBLE(YSIZ(2))
      ENDFOR
      DrawInfo.title=lti+' (Average)'
   END
5: BEGIN
      ypl=FINDGEN(YSIZ(1))
      FOR i=0,YSIZ(1)-1 DO BEGIN
          ypl(i)=MAX(ydat(i,*))
      ENDFOR
      DrawInfo.title=lti+' (Maximum)'
   END
2: BEGIN
     DrawInfo.psym=10L
     YMIN=MIN(ydat)
     YMAX=MAX(YDAT)
     IF YMAX LE YMIN THEN YMIN=YMIN-1
     YBIN=(YMAX-YMIN)/15.
     YTMP=HISTOGRAM(REFORM(ydat),BINSIZE=YBIN,MIN=YMIN,MAX=YMAX)
     YPL=FINDGEN(17)*0.
     NBIN=N_ELEMENTS(YTMP)
     YPL(1:0+NBIN)=YTMP
     XPL=FINDGEN(17)*YBIN+YMIN-YBIN
     DrawInfo.xtitle=ly
     DrawInfo.ytitle='# counts'
     Drawinfo.title='Histogram of '+lti
   END							
ELSE:BEGIN
       ypl=zout   
       DrawInfo.ytitle='z [m]' 
       PLOT_2D,ydat,YSIZ(2),YSIZ(1),NORM=NORM-3
       RETURN 
     END 
ENDCASE
DOPLOT
RETURN
END


;-------------------------------------------------------------------------------
;
PRO PART_PLOT,XDAT,YDAT,lti,lx,ly
;
;  Do scatter plot of particle variables
;
COMMON WIDGETCOM
COMMON DATCOM
COMMON PARTCOM
;
XPL=XDAT
YPL=YDAT
DrawInfo.title=lti
DrawInfo.xtitle=lx
DrawInfo.ytitle=ly
DrawInfo.log=0L
DrawInfo.psym=1L
DrawInfo.flag=1L
CASE record.IPARCOL OF
1:ZPL=GAM(*,record.IPARZ,record.IPARS)
2:ZPL=SQRT(XPOS(*,record.IPARZ,record.IPARS)^2+YPOS(*,record.IPARZ,record.IPARS)^2)
3:ZPL=GAM(*,0,0)
4:ZPL=SQRT(XPOS(*,0,0)^2+YPOS(*,0,0)^2)
ELSE:ZPL=FINDGEN(record.NPART)
ENDCASE
ZPL=BYTSCL(ZPL,TOP=!D.TABLE_SIZE-2B)+1B
IF record.IPARCOL EQ 0 THEN ZPL=!D.TABLE_SIZE-1B
DOPLOT
RETURN
END
;
;--------------------------------------------------------------------------------
;
PRO FLD_PLOT,radr,radi,lti,lx,ly,FFT=FFT,FAR=FAR
;
COMMON WIDGETCOM
COMMON DATCOM
COMMON RADCOM
;
DrawInfo.title=lti
DrawInfo.xtitle=lx
DrawInfo.ytitle=ly
DrawInfo.ztitle='I [W/m!E2!N]' 
DrawInfo.log=0L
DrawInfo.psym=0L
DrawInfo.flag=3L
XTMP=REFORM(radr,record.ncar,record.ncar)
YTMP=REFORM(radi,record.ncar,record.ncar)
ZTMP=XTMP^2+YTMP^2
DTMP=record.DXY
IF keyword_set(FFT) THEN BEGIN
   DRAWINFO.ztitle='dP/d!4X!3 [GW/mrad!E2!N]'
   CTMP=DCOMPLEX(XTMP,YTMP)
   CTMP=FFT(CTMP,/DOUBLE,/OVERWRITE,/INVERSE) 
   ZTMP=SHIFT(ABS(CTMP),(record.NCAR+1)/2,(record.NCAR+1)/2)^2*1.e-15
   CTMP=0.
   DTMP=1000.*record.XLAMDS/(record.NCAR*record.DXY)  ;compare Siegman p.658->factor 2 pi ??
ENDIF
NPAD=LONG((record.NCAR-record.IFLDSUB)/2)
XPL=FINDGEN(record.IFLDSUB)-0.5*(record.NCAR+1)+NPAD
XPL=XPL*DTMP
YPL=XPL
ZPL=ZTMP(NPAD:NPAD+record.IFLDSUB-1,NPAD:NPAD+record.IFLDSUB-1)
XTMP=0.
YTMP=0.
ZTMP=0.
;
CASE record.IFLDMOD OF
0:DrawInfo.Flag=3L
1:DrawInfo.Flag=4L
2:Begin
   ZTMP=TRANSPOSE(ZPL)
   PLOT_2D,ZTMP,record.IFLDSUB,record.IFLDSUB
   ZTMP=0
   RETURN
  End
ELSE:RETURN 
ENDCASE
DOPLOT
RETURN
END

;--------------------------------------------------------------------------------
;
PRO ANIMATE
;
;   Animated Plots of radiation pulse 
;   remove commentsign ';' to get GIFs
;
;
COMMON WIDGETCOM
COMMON DATCOM
;
ctmp='00000000'
nfill=fix(ALOG10(record.nz))
cfill=STRMID(ctmp,0,nfill)
;
DrawInfo.Flag=0L
!P.TITLE=''
!X.TITLE=''
!Y.TITLE=''
!P.FONT=-1
MAXGAIN=FINDGEN(record.NZ)
NGAIN=FINDGEN(record.NZ,record.NSLICE)
FOR i=1,record.NZ-1 DO BEGIN
    MAXGAIN(i)=MAX(GAIN(i,*))
    NGAIN(i,*)=0.99*GAIN(i,*)/MAX(GAIN(i,*)) 
ENDFOR
NGAIN=TRANSPOSE(NGAIN)
!P.REGION=[0.,0.5,1.,1.]
PLOT,TOUT, NGAIN(*,1),/NODATA,XSTYLE=1,YSTYLE=1,XTITLE='t [ps]',YTITLE='P(t)/P!IMax',$
    XRANGE=[0,TOUT(record.NSLICE-1)],YRANGE=[0.,1.],TITLE='Radiation Power'
!P.REGION=[0.,0.,1.,0.5]
PLOT_IO, ZOUT(1:record.NZ-1), MAXGAIN(1:record.NZ-1),/NODATA,YSTYLE=1,XSTYLE=1,/NOERASE,$
   XTITLE='z [m]',YTITLE='P!IMax!N [W]'

 
FOR i=2, record.NZ-1 DO BEGIN
  XMPL=ZOUT(I-1:I)
  YMPL=MAXGAIN(I-1:I)
  !P.REGION=[0.,0.5,1.,1.]
  PLOT, TOUT, NGAIN(*,i),XSTYLE=1,YSTYLE=1,/NOERASE,/NODATA,$
      XRANGE=[0,TOUT(record.NSLICE-1)],YRANGE=[0.,1.]
  OPLOT, TOUT, NGAIN(*,i-1),COLOR=0
  OPLOT, TOUT, NGAIN(*,i)
  !P.REGION=[0.,0.,1.,0.5]
  PLOT_IO,XMPL,YMPL,XSTYLE=5,YSTYLE=5,/NOERASE,$
          XRANGE=[ZOUT(1),ZOUT(record.NZ-1)],$
          YRANGE=[MIN(MAXGAIN(1:record.NZ-1)),MAX(MAXGAIN(1:record.NZ-1))]
;  print,'frame: ',i-2
;  T=TVRD()
;  ntmp=fix(alog10(i))
;  ctmp=STRCOMPRESS(STRING(i))
;  ctmp=STRMID(ctmp,1,STRLEN(ctmp))
;  cout='JPG/out'+STRMID(cfill,0,nfill-ntmp)+ctmp+'.jpg'
;  write_jpeg, cout,T 
ENDFOR
  
!P.REGION=[0.,0.,1.,1.]
RETURN
END


;-----------------------------------------------------------------------------------
;
PRO ANIMATE_PARTICLEII
;
; Animation of the long. phase space
;
COMMON DATCOM
COMMON WIDGETCOM
COMMON PARTCOM
;
ctmp='00000000'
nfill=fix(ALOG10(record.NPARz))
cfill=STRMID(ctmp,0,nfill)
;
DrawInfo.flag=0L
;
PART_PLOT,phi(*,0,0),gam(*,0,0),'set color','x','y'
XLAB=[MIN(PHI),MAX(PHI)]
YLAB=[MIN(GAM),MAX(GAM)]
A=STRING(INDGEN(N_ELEMENTS(ZPL)))
A='.'
ips=record.ipars
FOR i=FIX(record.NPARZ*0.4),record.NPARZ-1 DO BEGIN
    PLOT,XLAB,YLAB,/NODATA ,/YNOZERO,TITLE='Long. Phase Space',XTITLE='!4u!3',YTITLE='!4c!3'
    XYOUTS,PHI(*,i,IPS),GAM(*,i,IPS),A,COLOR=ZPL
    T=TVRD()
    ntmp=fix(alog10(i))
    ctmp=STRCOMPRESS(STRING(i))
    ctmp=STRMID(ctmp,1,STRLEN(ctmp))
    cout='JPG/out'+STRMID(cfill,0,nfill-ntmp)+ctmp+'.jpg'
    write_jpeg, cout,T 
ENDFOR
RETURN
END    


;-----------------------------------------------------------------------------------
;
PRO ANIMATE_PARTICLE
;
; Animation of the long. phase space
;
COMMON DATCOM
COMMON WIDGETCOM
COMMON PARTCOM
;
DrawInfo.flag=0L
;
XINTERANIMATE, SET=[350,200,record.NPARZ]
b0 = WIDGET_BASE(TITLE = "ANIMATE-TMP",XOFFSET=700,YOFFSET=0)	
b1=WIDGET_DRAW(b0,RETAIN=2,XSIZE=350,YSIZE=200) 
WIDGET_CONTROL, b0, /REALIZE			;create the widgets
WIDGET_CONTROL, b1, GET_VALUE=win_tmp         ;Get window id
WSET, win_tmp
PART_PLOT,phi(*,0,0),gam(*,0,0),'set color','x','y'
XLAB=[MIN(PHI),MAX(PHI)]
YLAB=[MIN(GAM),MAX(GAM)]
A=STRING(INDGEN(N_ELEMENTS(ZPL)))
A='.'
ips=record.ipars
FOR i=0,record.NPARZ-1 DO BEGIN
    PLOT,XLAB,YLAB,/NODATA ,/YNOZERO,TITLE='Long. Phase Space',XTITLE='!4u!3',YTITLE='!4c!3'
    XYOUTS,PHI(*,i,IPS),GAM(*,i,IPS),A,COLOR=ZPL
    XINTERANIMATE,FRAME=i,WINDOW=win_tmp
ENDFOR
XINTERANIMATE, 20,GROUP=widgetInfo.mainWinbase
WIDGET_CONTROL,b0,/DESTROY
WSET,widgetInfo.DrawID
RETURN
END    






;###########################################################################
;
;   Input/Output - routines
;
;##########################################################################


;----------------------------------------------------------------------
;
PRO READDATA,base 
;
;   main input routine
;
COMMON WIDGETCOM
COMMON DATCOM
;
; Get Filename
;
ctmp=DIALOG_PICKFILE(GROUP=base,/READ,PATH=record.cpath,GET_PATH=ctmppath,$
     TITLE='Select GENESIS Record File',/MUST_EXIST)
IF ctmp EQ '' THEN RETURN
;
; Clear old settings/records
;
PRESET
record.cfile=ctmp
record.cpath=ctmppath
nn=STRLEN(ctmppath)
nnn=STRLEN(ctmp)
cname='XGENESIS - '+STRMID(ctmp,nn,nnn-nn)

WIDGET_CONTROL,base,TLB_SET_TITLE=cname
;
WIDGET_CONTROL,widgetInfo.mainWinBase,/HOURGLASS
WIDGET_CONTROL,widgetInfo.CommentBase,SET_VALUE='Loading Records'
WidgetInfo.ButtonMode=0L
FOR i=0,3 DO BEGIN
  WIDGET_CONTROL,widgetInfo.mainButtonBase(i),MAP=0
  FOR j=0,16 DO BEGIN
      WIDGET_CONTROL,widgetInfo.Buttonset(j,i+4),MAP=0
  ENDFOR    
ENDFOR
;
; Define scale values to read & Read header
;
c='1'
c1=c
c2=c
r1=1.
I1=1L
;
OPENR, UNIT, record.cfile,/GET_LUN,ERROR=ERR
IF (ERR NE 0 ) THEN BEGIN
   MESSAGE,'FILE-ERROR'
   RETURN
ENDIF
;
LLOUT=INDGEN(19)*0L
REPEAT READF, UNIT, FORMAT='(X,A2)', c  UNTIL c EQ '$e'
READF,UNIT,FORMAT='(A2)',c
READF,UNIT,FORMAT='(A50)',c
for i=0,18 do begin
  record.lout(i)=uint('0'+strmid(c,i*2+1,1)) ;"It's ugly, isn't it?"
endfor


NIN=FIX(TOTAL(record.LOUT))

IF NIN EQ 0 THEN BEGIN
  WIDGET_CONTROL,widgetInfo.mainWinBase,HOURGLASS=0
  WIDGET_CONTROL,widgetInfo.CommentBase,SET_VALUE='Empty Imput File'
  record.cfile='' 
  CLOSE,UNIT 
  RETURN
ENDIF
;
READF,UNIT,FORMAT='(I5)',I1
record.NZ=I1
READF,UNIT,FORMAT='(I5)',I1
record.NSLICE=I1
READF,UNIT,FORMAT='(E14.4)',r1
record.XLAMDS=r1
READF,UNIT,FORMAT='(E14.4)',DELT
READF,UNIT,FORMAT='(I5)',I1
record.NCAR=I1
record.ifldsub=I1
READF,UNIT,FORMAT='(E14.4)',r1
record.DXY=r1
READF,UNIT,FORMAT='(I5)',I1
record.NPART=I1
READF,UNIT,FORMAT='(I5)',I1
record.NPARZ=I1
READF,UNIT,FORMAT='(I5)',I1
record.NPARS=I1
READF,UNIT,FORMAT='(I5)',I1
record.NFLDZ=I1
READF,UNIT,FORMAT='(I5)',I1
record.NFLDS=I1
;
; Calculate bunchlength and frequency range
;
TOUT=FINDGEN(record.NSLICE)*3.33e3*DELT
FEQ0=3.e8/record.XLAMDS
IF record.NSLICE GT 1 THEN BEGIN
  FOUT=(FINDGEN(record.NSLICE)/(record.NSLICE-1.)-0.5)*3.e8/DELT+FEQ0
ENDIF ELSE BEGIN
  FOUT=FINDGEN(record.NSLICE)+FEQ0
ENDELSE
;
; Read Global parameter 
;
GETVAL=FINDGEN(2,record.NZ)
ZOUT=FINDGEN(record.NZ)
AW  =FINDGEN(record.NZ)
READF, UNIT, FORMAT='(A1)', c
READF, UNIT, FORMAT='(2E14.4)', GETVAL
ZOUT   = GETVAL(0,*)
AW     = GETVAL(1,*)
;
; Read main part
;
CUR    = FINDGEN(record.NSLICE)
BANDW  = FINDGEN(record.NZ)  
PSPEC  = FINDGEN(record.NZ,record.NSLICE)
GAIN   = FINDGEN(record.NZ,record.NSLICE)
DIVER  = FINDGEN(record.NZ,record.NSLICE)
ERROR  = FINDGEN(record.NZ,record.NSLICE)
WHALF  = FINDGEN(record.NZ,record.NSLICE)
BUNCH  = FINDGEN(record.NZ,record.NSLICE)
PHASE  = FINDGEN(record.NZ,record.NSLICE)
XRMS   = FINDGEN(record.NZ,record.NSLICE)
YRMS   = FINDGEN(record.NZ,record.NSLICE)
MIDP   = FINDGEN(record.NZ,record.NSLICE)
LOGP   = FINDGEN(record.NZ,record.NSLICE)
GAMM   = FINDGEN(record.NZ,record.NSLICE)
XAVG   = FINDGEN(record.NZ,record.NSLICE)
YAVG   = FINDGEN(record.NZ,record.NSLICE)
SIGGAM = FINDGEN(record.NZ,record.NSLICE)
FFLD   = FINDGEN(record.NZ,record.NSLICE)
H2OUT  = FINDGEN(record.NZ,record.NSLICE)
H3OUT  = FINDGEN(record.NZ,record.NSLICE)
H4OUT  = FINDGEN(record.NZ,record.NSLICE)
H5OUT  = FINDGEN(record.NZ,record.NSLICE)

;
GETVAL = FINDGEN(NIN,record.NZ)
cformat='('+STRING(NIN)+'E14.4)'   ; correct format for reading (NIN columns)
;
FOR I=0,record.NSLICE-1 DO BEGIN
  READF, UNIT, FORMAT='(A1)', c,c1,c2
  READF, UNIT, FORMAT='(E15.4)',r1
  CUR(i)=r1 
  READF, UNIT, FORMAT='(A1)', c,c1
  READF, UNIT, FORMAT='(A1)', c
  READF, UNIT, FORMAT=cformat, GETVAL
  IIN=-1
  FOR J=0,18 DO BEGIN
    IF record.LOUT(J) NE 0 THEN BEGIN
       IIN=IIN+1
       CASE J OF
       0: GAIN(*,i)  = GETVAL(IIN,*)
       1: LOGP(*,i)  = GETVAL(IIN,*)
       2: MIDP(*,i)  = GETVAL(IIN,*)
       3: PHASE(*,i) = GETVAL(IIN,*)
       4: WHALF(*,i) = GETVAL(IIN,*)
       5: DIVER(*,i) = GETVAL(IIN,*)
       6: GAMM(*,i)  = GETVAL(IIN,*)
       7: BUNCH(*,i) = GETVAL(IIN,*)
       8: XRMS(*,i)  = GETVAL(IIN,*)
       9: YRMS(*,i)  = GETVAL(IIN,*)
       10:ERROR(*,i) = GETVAL(IIN,*)
       11:XAVG(*,i)  = GETVAL(IIN,*)  
       12:YAVG(*,i)  = GETVAL(IIN,*)  
       13:SIGGAM(*,i)= GETVAL(IIN,*)  
       14:FFLD(*,i)  = GETVAL(IIN,*)  
       15:H2OUT(*,i) = GETVAL(IIN,*)  
       16:H3OUT(*,i) = GETVAL(IIN,*)  
       17:H4OUT(*,i) = GETVAL(IIN,*)  
       18:H5OUT(*,i) = GETVAL(IIN,*)  

     ELSE: Message,'Invalid Parameter in READDATA'
       ENDCASE	
     ENDIF
  ENDFOR
ENDFOR 
CLOSE, UNIT
;
IF record.NSLICE GT 1 THEN BEGIN
  NSFT=FIX(record.NSLICE/2)+1
  IF (record.LOUT(2) NE 0) AND (record.LOUT(3) NE 0) THEN BEGIN 
    WIDGET_CONTROL, widgetinfo.Commentbase,SET_VALUE='FFT of Records'
    FOR i=1,record.NZ-1 DO BEGIN
      TDUM=COMPLEX(COS(PHASE(i,*)),SIN(PHASE(i,*)))
      TDUM=TDUM*SQRT(MIDP(i,*))
      TDUM=FFT(TDUM,-1,/OVERWRITE)
      PSPEC(i,*)=SHIFT(ABS(TDUM),-NSFT)^2
      DNORM=TOTAL(PSPEC(i,*))
      DMEAN=TOTAL(PSPEC(i,*)*FOUT)/DNORM
      DSIG=TOTAL(PSPEC(i,*)*(FOUT-DMEAN)^2)/DNORM
      BANDW(i)=SQRT(DSIG)/FEQ0    
    ENDFOR
    BANDW(0)=BANDW(1)
    PSPEC(0,*)=PSPEC(1,*)
  ENDIF
ENDIF 
;
; Setup Widget and Buttons
;
WIDGET_CONTROL,widgetInfo.mainWinBase,HOURGLASS=0
widgetInfo.Buttonmode=1L
CREATE_BUTTONS,1L,widgetInfo.mainButtonBase(0),record.NSLICE
IF record.NSLICE GT 1 THEN CREATE_BUTTONS,2L,widgetInfo.mainButtonBase(1),record.NZ
WIDGET_CONTROL,widgetInfo.mainButtonBase(0),/MAP
;
RETURN
END


;----------------------------------------------------------------------------
;
PRO LOADRAD
;
;  Load the Radiation data set
;
COMMON WIDGETCOM
COMMON DATCOM
COMMON RADCOM
;
IF record.NFLDZ LT 1 THEN RETURN
;
WIDGET_CONTROL,widgetInfo.mainWinBase,/HOURGLASS
WIDGET_CONTROL,widgetInfo.CommentBase,SET_VALUE='Loading Radiation Records'
;
NEL=LONG(record.NCAR*record.NCAR)
;
FIELDR=FINDGEN(NEL,record.NFLDZ,record.NFLDS)
FIELDI=FINDGEN(NEL,record.NFLDZ,record.NFLDS)
GETVAL1=DBLARR(NEL,/NOZERO)
GETVAL2=DBLARR(NEL,/NOZERO)
;
OPENR, UNIT, record.cfile+'.fld',/GET_LUN
;
FOR I=0,record.NFLDS-1  DO BEGIN
  FOR J=0,record.NFLDZ-1 DO BEGIN
        READU, UNIT, GETVAL1
        READU, UNIT, GETVAL2
        FIELDR(*,J,I)=GETVAL1/record.dxy
	FIELDI(*,J,I)=GETVAL2/record.dxy
  ENDFOR
ENDFOR
;
CLOSE, UNIT
;
CREATE_BUTTONS,3L,widgetInfo.mainButtonBase(2),[record.NFLDZ,record.NFLDS]
WIDGET_CONTROL,widgetInfo.mainWinBase,HOURGLASS=0
;
RETURN
END

;----------------------------------------------------------------------------
;
PRO LOADPART
;
;   Load the Particle Data set
;
COMMON PARTCOM 
COMMON WIDGETCOM
COMMON DATCOM
;
IF record.NPARZ LT 1 THEN RETURN
;
GAM   =DBLARR(record.NPART,record.NPARZ,record.NPARS,/NOZERO)
PHI   =DBLARR(record.NPART,record.NPARZ,record.NPARS,/NOZERO)
XPOS  =DBLARR(record.NPART,record.NPARZ,record.NPARS,/NOZERO)
YPOS  =DBLARR(record.NPART,record.NPARZ,record.NPARS,/NOZERO)
PXPOS =DBLARR(record.NPART,record.NPARZ,record.NPARS,/NOZERO)
PYPOS =DBLARR(record.NPART,record.NPARZ,record.NPARS,/NOZERO)
GETVAL=DBLARR(record.NPART,/NOZERO)
;
WIDGET_CONTROL,widgetInfo.mainWinBase,/HOURGLASS
WIDGET_CONTROL,widgetInfo.CommentBase,SET_VALUE='Loading Particle Records'
;
Openr, unit, record.cfile+'.par',/GET_LUN
;
FOR I=0,record.NPARS-1  DO BEGIN
  FOR J=0,record.NPARZ-1 DO BEGIN
        READU, UNIT, GETVAL
        GAM(*,j,i)=GETVAL
        READU, UNIT, GETVAL
        index1=WHERE(GETVAL GT  !PI, COUNT1)
        index2=WHERE(GETVAL LT -!PI, COUNT2)
;here is the error !!!!!!!!  in WHERE      
        IF COUNT1 GT 0 THEN BEGIN
           GETVAL(INDEX1)=GETVAL(INDEX1)-2.*!PI*FIX((GETVAL(INDEX1)+!PI)/2./!PI)
        ENDIF
        IF COUNT2 GT 0 THEN BEGIN
           GETVAL(INDEX2)=GETVAL(INDEX2)+2.*!PI*FIX((-GETVAL(INDEX2)+!PI)/2./!PI)
        ENDIF
        PHI(*,J,i)=GETVAL   
        READU, UNIT, GETVAL
        XPOS(*,j,i)=GETVAL
        READU, UNIT, GETVAL
        YPOS(*,j,i)=GETVAL
        READU, UNIT, GETVAL
        PXPOS(*,j,i)=GETVAL
        READU, UNIT, GETVAL
        PYPOS(*,j,i)=GETVAL
  ENDFOR
ENDFOR
;
CLOSE, UNIT
;
CREATE_BUTTONS,4L,widgetInfo.mainButtonBase(3),[record.NPARZ,record.NPARS]
WIDGET_CONTROL,widgetInfo.mainWinBase,HOURGLASS=0
;
RETURN
END

;----------------------------------------------------------------------------
;
PRO SAVEDATA,base
;
; Export last plot
; PLOT - ASCII FILE
; TV - GIF FILE
;
COMMON WIDGETCOM
COMMON DATCOM
;
CASE DRAWINFO.FLAG Of
1:BEGIN
    CTIT='Save 1D Data to ASCII-File (*.dat)'
    CFILT='*.dat'
    CFILE='out.dat'
  END
2:BEGIN
    CTIT='Save 2D Data to GIF-File (*.gif)'
    CFILT='*.gif'
    CFILE='out.gif'
  END
3:BEGIN
    CTIT='Save 2D Data to GIF-File (*.gif)'
    CFILT='*.gif'
    CFILE='out.gif'
  END
4:BEGIN
    CTIT='Save 2D Data to GIF-File (*.gif)'
    CFILT='*.gif'
    CFILE='out.gif'
  END
ELSE:RETURN
ENDCASE
;
cfile=DIALOG_PICKFILE(FILE=CFILE,GET_PATH=ctmppath,$
      GROUP=base,FILTER=CFILT,TITLE=CTIT,/FIX_FILTER)
If STRLEN(cfile) LT 3 THEN RETURN
record.cpath=ctmppath
CASE DRAWINFO.FLAG OF
1:BEGIN
   NEL=MIN([N_ELEMENTS(XPL),N_ELEMENTS(YPL)])
   PUTVAL=FINDGEN(2,NEL)
   PUTVAL(0,*)=XPL(0:NEL-1)
   PUTVAL(1,*)=YPL(0:NEL-1)
   OPENW,UNIT,CFILE,/GET_LUN
   PRINTF,UNIT,FORMAT='(E14.4,X,E14.4)',PUTVAL
   CLOSE,UNIT
  END
2:WRITE_JPeG,CFILE,ZPL
3:BEGIN
    ZTMP=BYTSCL(ZPL,TOP=!D.TABLE_SIZE-1) 
    WRITE_JPeG,CFILE,ZTMP
  END 
4:BEGIN
    ZTMP=BYTSCL(ZPL,TOP=!D.TABLE_SIZE-1) 
    WRITE_JPeG,CFILE,ZTMP
  END 
ENDCASE
RETURN
END  

;-----------------------------------------------------------------------------
;
PRO GIVE_COMMENT
;
; Updates the Bottom comment line
;
COMMON WIDGETCOM
COMMON DATCOM
;
IF record.NZ LT 1 THEN BEGIN
   WIDGET_CONTROL,WidgetInfo.Commentbase,SET_VALUE='No Data in Memory'
   RETURN
ENDIF
ctmp='Plot: '
CASE WidgetInfo.Buttonmode of
1:Begin
    ctmp=ctmp+'Z-Dependency'
    IF record.ipmode eq 1 then ctmp= ctmp+' - T-Average'
    if record.ipmode eq 5 then ctmp= ctmp+' - T-Maximum'
    If Record.ipmode eq 3 then ctmp= ctmp+' - 2D-Plot (Y-Axis) - Color coded'
    If Record.ipmode eq 4 then ctmp= ctmp+' - 2D-Plot (Y-Axis) - Normalized - Color coded'
  END
2:Begin
    ctmp=ctmp+'T-Dependency'
    If Record.ipmode eq 2 then ctmp=ctmp+' - Histogram'
    If Record.ipmode eq 3 then ctmp=ctmp+' - 2D-Plot - Color coded'
    If Record.ipmode eq 4 then ctmp=ctmp+' - 2D-Plot - Normalized - Color coded'
  END
3:Begin
    Case record.ifldmod of
    0:ctmp=ctmp+'Radiation Distribution - Mesh'
    1:ctmp=ctmp+'Radiation Distribution - Shaded Surface'
    2:ctmp=ctmp+'Radiation Distribution - Image'
    ELSE:ctmp=ctmp+''
    ENDCASE
  END	
4:Begin
    Case record.iparcol of
    0:ctmp=ctmp+'Particle Distributon'
    1:ctmp=ctmp+'Particle Distributon - Color coded (Energy)'
    2:ctmp=ctmp+'Particle Distributon - Color coded (Radius)'
    3:ctmp=ctmp+'Particle Distributon - Color coded (Init. Energy)'
    4:ctmp=ctmp+'Particle Distributon - Color coded (Init. Radius)'
    Else:ctmp=ctmp+''
    ENDCASE
  END
ELSE:RETURN 
ENDCASE 
;
WIDGET_CONTROL,WidgetInfo.Commentbase,SET_VALUE=ctmp
RETURN
END

;############################################################################
;
;  Event-Processing
;
;############################################################################

;------------------------------------------------------------------------
;
PRO xgen_event, event
;
;  event handler of xgenesis
;
COMMON WIDGETCOM
COMMON DATCOM
COMMON PARTCOM
COMMON RADCOM
;
;  check for a quit by window manager
;
IF (TAG_NAMES(event,/STRUCTURE_NAME) eq 'WIDGET_KILL_REQUEST') THEN BEGIN
    WIDGET_CONTROL,event.top,/DESTROY
    RETURN	
ENDIF
;
; get event user value
;
WIDGET_CONTROL,event.id,GET_UVALUE=uval
;
; catch event of menu item
;
if uval eq 'MENU_ROOT' then begin
   uval=WidgetInfo.MenuEntry(event.value)
   uval=strmid(uval,2,strlen(uval)-1)
   CASE uval OF
   "QUIT":BEGIN
             WIDGET_CONTROL,event.top,/DESTROY     ;exit application
             RETURN
	  END
   "OPEN_FILE":READDATA,event.top               ;load main record
   "SAVE_DATA":SAVEDATA,event.top
   "PRINT":IF DrawInfo.flag GT 0 THEN DOPRINT,GROUP=event.top      ;print last plot
   "STATISTIC":STATISTIC,GROUP=event.top  ;print record information
   "SHOWDATA":IF record.NZ GT 1 THEN XDISPLAYFILE, record.cfile,GROUP=event.top
   "PLOTZ":BEGIN
             IBASE=WidgetInfo.BUTTONMODE
             IF IBASE EQ 1L THEN RETURN
             WIDGET_CONTROL,WidgetInfo.mainButtonBase(ibase-1),MAP=0
	     WIDGET_CONTROL,WidgetInfo.mainButtonBase(0),/MAP
             WidgetInfo.ButtonMode=1L
           END
   "PLOTT":BEGIN
             IBASE=WidgetInfo.BUTTONMODE
             IF IBASE EQ 2L THEN RETURN
             IF record.NSLICE LE 1 THEN RETURN 
             WIDGET_CONTROL,WidgetInfo.mainButtonBase(ibase-1),MAP=0
	     WIDGET_CONTROL,WidgetInfo.mainButtonBase(1),/MAP
             WidgetInfo.ButtonMode=2L
           END
   "PLOTR":BEGIN
             IBASE=WidgetInfo.BUTTONMODE
             IF IBASE EQ 3L THEN RETURN
             IF record.NFLDZ LT 1 THEN RETURN
             IF N_ELEMENTS(FIELDR) LT 4 THEN LOADRAD 
             WIDGET_CONTROL,WidgetInfo.mainButtonBase(ibase-1),MAP=0
	     WIDGET_CONTROL,WidgetInfo.mainButtonBase(2),/MAP
             WidgetInfo.ButtonMode=3L
           END
   "PLOTP":BEGIN
             IBASE=WidgetInfo.BUTTONMODE
             IF IBASE EQ 4L THEN RETURN
             IF record.NPARZ LT 1 THEN RETURN
             IF N_ELEMENTS(PHI) LT 4 THEN LOADPART 
             WIDGET_CONTROL,WidgetInfo.mainButtonBase(ibase-1),MAP=0
	     WIDGET_CONTROL,WidgetInfo.mainButtonBase(3),/MAP
             WidgetInfo.ButtonMode=4L
           END
   "POWANIMATE":IF record.NSLICE GT 1 THEN ANIMATE
   "PARTANIMATE":IF N_ELEMENTS(PHI) GT 1 THEN ANIMATE_PARTICLE
   "MESHSIZE":IF N_ELEMENTS(fieldr) GT 3 THEN SETMESH,GROUP=event.top
   "SETLABEL":SETLABEL,GROUP=event.top
   "SETFONT":SETFONT,GROUP=event.top
   "SETLINE":SETLINE,GROUP=event.top
   "SETCOLOR":XLOADCT,GROUP=event.top           ;select color table
   "EDITCOLOR":XPALETTE,GROUP=event.top         ;edit color table
   "PLOTMODE1":record.IPMODE=0L
   "PLOTMODE2":IF record.NSLICE GT 1 THEN record.IPMODE=1L
   "PLOTMODE3":IF record.NSLICE GT 1 THEN record.IPMODE=2L
   "PLOTMODE4":IF record.NSLICE GT 1 THEN record.IPMODE=3L
   "PLOTMODE5":IF record.NSLICE GT 1 THEN record.IPMODE=4L
   "PLOTMODE6":IF record.NSLICE GT 1 THEN record.IPMODE=5L
   "PARTCOL1":record.IPARCOL=0L
   "PARTCOL2":If record.NPARZ GT 0 THEN record.IPARCOL=1L
   "PARTCOL3":If record.NPARZ GT 0 THEN record.IPARCOL=2L
   "PARTCOL4":If record.NPARZ GT 0 THEN record.IPARCOL=3L
   "PARTCOL5":If record.NPARZ GT 0 THEN record.IPARCOL=4L
   "FIELD1":IF record.NFLDZ GT 0 THEN record.IFLDMOD=0L
   "FIELD2":IF record.NFLDZ GT 0 THEN record.IFLDMOD=1L
   "FIELD3":IF record.NFLDZ GT 0 THEN record.IFLDMOD=2L
   "HELPGEN":XDISPLAYFILE,'xgenesis.pro',GROUP=event.top,TEXT=genhelp
   "HELPXGEN":XDISPLAYFILE,'xgenesis.pro',GROUP=event.top,TEXT=xgenhelp
   "HELPIDL":XDISPLAYFILE,'xgenesis.pro',GROUP=event.top,TEXT=idlhelp
   ELSE:  MESSAGE,'Error in XGEN_EVENT'
   ENDCASE
   GIVE_COMMENT
   RETURN
ENDIF
;
; catch event: plotting z- or t-dependency
;
IF UVAL EQ 'GETT' THEN BEGIN
   WIDGET_CONTROL,event.id,GET_VALUE=IVAL
   record.ISLICE=IVAL
   RETURN
ENDIF
IF UVAL EQ 'GETZ' THEN BEGIN
   WIDGET_CONTROL,event.id,GET_VALUE=IVAL
   record.IZ=IVAL
   RETURN
ENDIF
;
IF UVAL EQ 'GETPT' THEN BEGIN
   WIDGET_CONTROL,event.id,GET_VALUE=IVAL
   record.IPARS=IVAL
   RETURN
ENDIF
IF UVAL EQ 'GETPZ' THEN BEGIN
   WIDGET_CONTROL,event.id,GET_VALUE=IVAL
   record.IPARZ=IVAL
   RETURN
ENDIF
;
IF UVAL EQ 'GETRT' THEN BEGIN
   WIDGET_CONTROL,event.id,GET_VALUE=IVAL
   record.IFLDS=IVAL
   RETURN
ENDIF
IF UVAL EQ 'GETRZ' THEN BEGIN
   WIDGET_CONTROL,event.id,GET_VALUE=IVAL
   record.IFLDZ=IVAL
   RETURN
ENDIF
;
preuval=STRMID(uval,0,1)
uval=strmid(uval,2,strlen(uval)-1)
IF preuval eq 'T' or preuval eq 'Z' or preuval eq 'P' or preuval eq 'R' THEN BEGIN
  CASE preuval OF
  'Z': BEGIN
         LOG=1L
         xout=zout   
         lx='z [m]'
         iz0=0
         iz1=record.NZ-1
	 it=record.ISLICE
         IF record.IPMODE EQ 1 THEN it=record.NSLICE
	 it0=it
	 it1=it	 
       END
  'T': BEGIN
         LOG=0L
         xout=tout
         lx='t [ps]'
         iz0=record.iz
	 iz1=record.iz
         it0=0
	 it1=record.NSLICE-1
       END
  'P': BEGIN
         iz0=record.iparz 
         it0=record.ipars
       END
  'R': BEGIN
         iz0=record.ifldz
	 it0=record.iflds
       END 
  ELSE:Message, 'error in xgen_event'  	
  ENDCASE
  NORM=record.IPMODE
  IF (NORM EQ 1 AND preuval EQ 'T') THEN NORM=0
  IF (NORM EQ 2 AND preuval EQ 'Z') THEN NORM=0
  IF ((NORM EQ 3) OR (NORM EQ 4) OR (NORM EQ 1) OR (NORM EQ 5)) AND ((PREUVAL EQ 'T') OR (PREUVAl EQ 'Z')) THEN BEGIN
     iz0=0
     iz1=record.NZ-1
     it0=0
     it1=record.Nslice-1
     If ((NORM GE 3) AND (NORM LE 4)) THEN BEGIN
       xout=tout
       lx='t [PS]'
     ENDIF
  ENDIF  			
  CASE uval of
  'But1' : INIT_PLOT,XOUT,GAIN(iz0:iz1,it0:it1),'Radiation Power',lx,'P [W]',LOG=LOG,NORM=NORM
  'But2' : INIT_PLOT,XOUT,LOGP(iz0:iz1,it0:it1),'Power Increment',lx,'Re(!4K!3)',NORM=NORM
  'But3' : INIT_PLOT,XOUT,MIDP(iz0:iz1,it0:it1),'Center Power',lx,'P [W]',NORM=NORM
  'But4' : INIT_PLOT,XOUT,PHASE(iz0:iz1,it0:it1),'Center Phase',lx,'!4u!3 [Rad]',NORM=NORM
  'But5' : INIT_PLOT,XOUT,WHALF(iz0:iz1,it0:it1),'Radiation Size',lx,'!4r!3!Irad!N [m]',NORM=NORM
  'But6' : INIT_PLOT,XOUT,DIVER(iz0:iz1,it0:it1),'Defraction Angle',lx,'!4r!3!I!4h!3!N [m]',NORM=NORM
  'But7' : INIT_PLOT,XOUT,GAMM(iz0:iz1,it0:it1),'Beam Energy',lx,'<!4c!3>',NORM=NORM
  'But8' : INIT_PLOT,XOUT,BUNCH(iz0:iz1,it0:it1),'Bunching Factor',lx,'|<exp(i!4h!3)>|',NORM=NORM
  'But9' : INIT_PLOT,XOUT,XRMS(iz0:iz1,it0:it1),'X - Beam Size',lx,'!4r!3!Ix!N [m]',NORM=NORM
  'But10': INIT_PLOT,XOUT,YRMS(iz0:iz1,it0:it1),'Y - Beam Size',lx,'!4r!3!Iy!N [m]',NORM=NORM
  'But11': INIT_PLOT,XOUT,ERROR(iz0:iz1,it0:it1),'Error',lx,'Error [%]',NORM=NORM
  'But12': INIT_PLOT,ZOUT,AW(*),'Wiggler Field','z [m]','<a!IW!N>'
  'But13': INIT_PLOT,TOUT,CUR(*),'Current','t [ps]','I [A]'
  'But14': INIT_PLOT,FOUT,PSPEC(iz0:iz1,it0:it1),'Power Spectrum','!4x!3 [Hz]','P(!4x!3) [W]',NORM=NORM
  'But15': INIT_PLOT,ZOUT,BANDW(*),'Bandwidth','z [m]','!4Dx!3/!4x!3!I0!N'
  'But16': PART_PLOT,XPOS(*,iz0,it0),YPOS(*,iz0,it0),'Beam Size','x [m]','y [m]'
  'But17': PART_PLOT,XPOS(*,iz0,it0),PXPOS(*,iz0,it0),'Phase Space in X','x [m]','px [Rad]'
  'But18': PART_PLOT,YPOS(*,iz0,it0),PYPOS(*,iz0,it0),'Phase Space in Y','y [m]','py [Rad]'
  'But19': PART_PLOT,PHI(*,iz0,it0),GAM(*,iz0,it0),'Long. Phase Space','!4u!3','!4c!3'
  'But20': FLD_PLOT,FIELDR(*,iz0,it0),FIELDI(*,iz0,it0),'Radiation Profile','x [m]','y [m]'
  'But21': FLD_PLOT,FIELDR(*,iz0,it0),FIELDI(*,iz0,it0),'Radiation Profile',$
                                      '!4h!3!Ix!N [mRad]','!4h!3!Iy!N [mRad]',/FFT
  'ABut1': INIT_PLOT,XOUT,XAVG(iz0:iz1,it0:it1),'X-Centroid Position',lx,'<x> [m]',NORM=NORM
  'ABut2': INIT_PLOT,XOUT,YAVG(iz0:iz1,it0:it1),'Y-Centroid Position',lx,'<y> [m]',NORM=NORM
  'ABut3': INIT_PLOT,XOUT,SIGGAM(iz0:iz1,it0:it1),'Energy Spread',lx,'!4r!Ic!N!3',NORM=NORM
  'ABut4': INIT_PLOT,XOUT,FFLD(iz0:iz1,it0:it1),'Far Field (on-axis)',lx,'I [a.u.]',LOG=LOG,NORM=NORM
  'ABut5': INIT_PLOT,XOUT,H2OUT(iz0:iz1,it0:it1),'2nd Harmonic',lx,'|<exp(i2!4h!3)>|',NORM=NORM
  'ABut6': INIT_PLOT,XOUT,H3OUT(iz0:iz1,it0:it1),'3rd Harmonic',lx,'|<exp(i3!4h!3)>|',NORM=NORM
  'ABut7': INIT_PLOT,XOUT,H4OUT(iz0:iz1,it0:it1),'4th Harmonic',lx,'|<exp(i4!4h!3)>|',NORM=NORM
  'ABut8': INIT_PLOT,XOUT,H5OUT(iz0:iz1,it0:it1),'5th Harmonic',lx,'|<exp(i5!4h!3)>|',NORM=NORM
  ELSE:RETURN
  ENDCASE
endif

RETURN
END



;############################################################################
;
;   Initialisation module
;      - Set up buttons, Menubar, 
;      - defines default values,
;      - get system dependent values,
;      - create application widget              
;
;#############################################################################


;----------------------------------------------------------------------------
;
pro set_default
;
;  Purpose:  Reset the system variables.
;

;    Set_Shading, LIGHT=[0.0, 0.0, 1.0], /REJECT, /GOURAUD, $
;        VALUES=[0, (!D.N_Colors-1L)]

;    T3d, /RESET
    !P.T3d = 0
    !P.Position = [0.0, 0.0, 0.0, 0.0]
    !P.Clip = [0L, 0L, (!D.X_Size-1L), (!D.Y_Size-1L), 0L, 0L]
    !P.Region = [0.0, 0.0, 0.0, 0.0]
    !P.Background = 0L
    !P.Charsize = 8.0 / Float(!D.X_Ch_Size)
    !P.Charthick = 0.0
    !P.Color = !D.N_Colors - 1L
    !P.Font = (-1L)
    !P.Linestyle = 0L
    !P.Multi = [0L, 0L, 0L, 0L, 0L]
    !P.Noclip = 0L
    !P.Noerase = 0L
    !P.Nsum = 0L
    !P.Psym = 0L
    !P.Subtitle = ''
    !P.Symsize = 0.0
    !P.Thick = 0.0
    !P.Title = ''
    !P.Ticklen = 0.02
    !P.Channel = 0

    !X.S = [0.0, 1.0]
    !X.Style = 0L
    !X.Range = 0
    !X.Type = 0L
    !X.Ticks = 0L
    !X.Ticklen = 0.0
    !X.Thick = 0.0
    !X.Crange = 0.0
    !X.Omargin = 0.0
    !X.Window = 0.0
    !X.Region = 0.0
    !X.Charsize = 0.0
    !X.Minor = 0L
    !X.Tickv = 0.0
    !X.Tickname = ''
    !X.Gridstyle = 0L
    !X.Tickformat = ''

    !Y = !X
    !Z = !X

    !X.Style=1L
    !X.Margin = [10.0, 3.0]     ;.Margin is different for x,y,z
    !Y.Margin = [4.0, 2.0]
    !Z.Margin = 0
    
    LOADCT,1
 
    RETURN
end

;----------------------------------------------------------------------------
;
PRO SET_HELP,genhelp,xgenhelp,idlhelp
;
; Defines the help text of the application
;

genhelp=[ $
 'GENESIS 1.3 is a Fortran based code for simulation ',$
 'of steadystate or time dependend FEL. The program',$
 'is independent of a graphic platform, because it',$
 'generates only ASCII- or binary outputfiles.',$
 'To view, analyze and print the results the postprocessor',$
 'XGENESIS is used, which runs under the IDL (Interactive',$
 'Data Language) envirement. This makes the postprocessor',$
 'easier to transform to other platforms where IDL is',$
 'installed.',$
 'GENESIS generates up to three output files:',$
 ' - Main outputfile (ASCII format)',$
 ' - Records of the radiation field (Binary)',$
 ' - Records of the particles parameters (Binary)',$
 'The filenames of the two records shares the filename of the',$
 'main file plus an extension (.par for the particle records',$
 'and .fld for the field records).',$
 'For further information, see the manual or contact:',$
 'Sven Reiche, email:sven.Reiche@desy.de']

xgenhelp=[ $
 'XGENESIS is the postprocessor of GENESIS. It is written',$
 'in the IDL (Interactive Data Language) syntax to give an',$
 'easy way to modify the code or to transform it to other',$
 'platforms.',$
 'The window of the the IDL-application XGENESIS consist',$
 'of 4 main parts:',$
 ' - Menubar',$
 ' - Plot area',$
 ' - Parameter selection',$
 ' - Status line',$
 'The menubar contains common items for loading a file, printing',$
 'the last plot or changing the plotting style. The different',$
 'data sets can be selected.',$ 
 'The parameter selection is a group of buttons, which will',$
 'produced the selected dependency, e.g. Radiation power vs',$
 'undulator position.',$
 'For further information, see the manual or contact:',$
 'Sven Reiche, email:sven.Reiche@desy.de']

idlhelp=[ $
 'The Interactive Data Language (IDL) is a tool for easy way',$
 'to display, analyize and modify sets of data. It is based on',$
 'a Fortran like command syntax which can be used interactively',$
 'or for writing modules or application.',$
 'For more information see the manual']

RETURN
END


;----------------------------------------------------------------------------
;
PRO GET_MENU_ENTRY, MENU_ENTRY
;
;   Defines the Menu entries by pairs (NAME - UVALUES)   
;


MENU_ENTRY =   ['1\File', '', $
	        '0\Open','M_OPEN_FILE',$
		'0\Save','M_SAVE_DATA',$
		'0\Print','M_PRINT',$
		'2\Quit','M_QUIT',$
	        '1\Data','',$
                '0\Z-Dependency','M_PLOTZ',$
                '0\T-Dependency','M_PLOTT',$
                '0\Field','M_PLOTR',$ 
                '0\Particle','M_PLOTP',$
		'0\Statistic','M_STATISTIC',$
                '2\Raw Data','M_SHOWDATA',$
                '1\Mode','',$
		'1\T-Dependency','',$
		'0\Normal','M_PLOTMODE1',$	      	
		'0\T-Averaged','M_PLOTMODE2',$
	      	'0\T-Maximum','M_PLOTMODE6',$
		'0\Histogram','M_PLOTMODE3',$	      	
		'0\2D - Normal','M_PLOTMODE4',$	      	
		'2\2D - Normalized','M_PLOTMODE5']	      	
            
MENU_ENTRY =   [MENU_ENTRY,$
		'1\Field-Mesh','',$
		'1\Plot Style','',$
		'0\Mesh','M_FIELD1',$
		'0\Shading','M_FIELD2',$
		'2\Image','M_FIELD3',$
		'2\Set Size...','M_MESHSIZE',$
	 	'1\Particle-Coding','',$
		'0\None','M_PARTCOL1',$
		'0\Energy','M_PARTCOL2',$
		'0\Radius','M_PARTCOL3',$
		'0\Init. Energy','M_PARTCOL4',$
		'2\Init. Radius','M_PARTCOL5',$
                '3\Animation','',$\  
		'0\Radiation Pulse','M_POWANIMATE',$
	        '2\Long. Phase Space','M_PARTANIMATE',$
		'1\Option','',$
		'0\Label','M_SETLABEL',$
		'0\Font','M_SETFONT',$
		'0\Line','M_SETLINE',$
		'0\Colors','M_SETCOLOR',$
		'2\Edit Color','M_EDITCOLOR',$
		'1\Help','',$
		'0\about GENESIS','M_HELPGEN',$
		'0\about XGENESIS','M_HELPXGEN',$
		'2\about IDL','M_HELPIDL']

RETURN
END

;------------------------------------------------------------------------
;
PRO Get_Button_List,Button_List,Button_Mode,LOUT,NSLD
;
;  Definition of the Buttons to be displayed in the Application
;   BUTTON_MODE=1 -> Plot vs z (Steady State)
;   BUTTON_MODE=2 -> Plot vs z (Scan or Timedependency)
;   BUTTON_MODE=3 -> Plot of Field distribution
;   BUTTON_MODE=4 -> Plot of particle distribution
;   BUTTON_MODE=0 -> reset Button Field

;
;   Initialize/Clear array of structures
;
Button_List=Replicate({Flag:0L,Value:'',uvalue:''},27)
;
; Treat case of Radiation Field and particle plots
;
IF (Button_MODE EQ 4) THEN BEGIN
   BUTTON_LIST(0:3).FLAG=[1,1,1,1]
   BUTTON_LIST(0:3).VALUE=['X - Y','X - Px','Y - Py','Phi - Gamma']
   BUTTON_LIST(0:3).UVALUE=['P_But16','P_But17','P_But18','P_But19']
   BUTTON_LIST(25:26).FLAG=[0,0]
   IF NSLD(0) GT 1 THEN    BUTTON_LIST(25:26).FLAG=[1,1]
   BUTTON_LIST(25:26).Value=['Z','']
   BUTTON_LIST(25:26).Uvalue=['','GETPZ']
   IF NSLD(1) GT 1 THEN BEGIN
     BUTTON_LIST(23:24).FLAG  =BUTTON_LIST(25:26).FLAG
     BUTTON_LIST(23:24).Value =BUTTON_LIST(25:26).Value
     BUTTON_LIST(23:24).Uvalue=BUTTON_LIST(25:26).Uvalue
     BUTTON_LIST(25:26).FLAG=[1,1]
     BUTTON_LIST(25:26).Value=['T','']
     BUTTON_LIST(25:26).Uvalue=['','GETPT']
   ENDIF
   RETURN
ENDIF
IF (Button_MODE EQ 3) THEN BEGIN
   BUTTON_LIST(0:1).FLAG=[1,1]
   BUTTON_LIST(0:1).VALUE=['Near Field','Far Field']
   BUTTON_LIST(0:1).UVALUE=['R_But20','R_But21']
   BUTTON_LIST(25:26).FLAG=[0,0]
   IF NSLD(0) GT 1 THEN    BUTTON_LIST(25:26).FLAG=[1,1]
   BUTTON_LIST(25:26).Value=['Z','']
   BUTTON_LIST(25:26).Uvalue=['','GETRZ']
   IF NSLD(1) GT 1 THEN BEGIN
     BUTTON_LIST(23:24).FLAG  =BUTTON_LIST(25:26).FLAG
     BUTTON_LIST(23:24).Value =BUTTON_LIST(25:26).Value
     BUTTON_LIST(23:24).Uvalue=BUTTON_LIST(25:26).Uvalue
     BUTTON_LIST(25:26).FLAG=[1,1]
     BUTTON_LIST(25:26).Value=['T','']
     BUTTON_LIST(25:26).Uvalue=['','GETRT']
   ENDIF
   RETURN
ENDIF
;
; Set Buttons for t- and z-plots. Only few differences
;
TMP_VALUE=['Power','Power Increment','Power - Center','Phase - Center', $
           'Radiation Size','Diffraction Angle','Beam Energy',$
	   'Bunching','X-Beam Size','Y-Beam Size','Error',$
           '<x>','<y>','E - Spread','Far Field','2nd Harm.',$
           '3nd Harm.','4th Harm.','5th Harm.' ]
TMP_UVALUE=['But1','But2','But3','But4','But5','But6','But7','But8','But9',$
            'But10','But11','ABut1','ABut2','ABut3','ABut4','ABut5','ABut6',$
            'ABut7','ABut8' ]
TMP_FLAG=LOUT(0:18)
IF (BUTTON_MODE EQ 1) THEN BEGIN
   PREUVAL='Z_'
   TMP_VALUE=[TMP_VALUE,'Wiggler Field']
   TMP_UVALUE=[TMP_UVALUE,'But12']
   TMP_FLAG=[TMP_FLAG,1]
   END_VALUE=['T','']
   END_UVALUE=['','GETT']
   END_FLAG=[0,0]
   IF NSLD GT 1 THEN END_FLAG=[1,1]
ENDIF ELSE BEGIN
   PREUVAL='T_'
   TMP_VALUE=[TMP_VALUE,'Current','Spectrum','Bandwidth']
   TMP_UVALUE=[TMP_UVALUE,'But13','But14','But15']
   IF (LOUT(2)+LOUT(3)) EQ 2 THEN LTMP=[1,1] ELSE LTMP=[0,0]
   TMP_FLAG=[TMP_FLAG,1,LTMP]
   END_VALUE=['Z','']
   END_UVALUE=['','GETZ']
   END_FLAG=[0,0]
   IF NSLD GT 1 THEN END_FLAG=[1,1]
ENDELSE
N1=N_ELEMENTS(TMP_FLAG)
N2=N_ELEMENTS(END_FLAG)
BUTTON_LIST(0:N1-1).FLAG=TMP_FLAG 
BUTTON_LIST(0:N1-1).VALUE=TMP_VALUE
BUTTON_LIST(0:N1-1).UVALUE=PREUVAL+TMP_UVALUE
BUTTON_LIST(27-N2:26).FLAG=END_FLAG 
BUTTON_LIST(27-N2:26).VALUE=END_VALUE
BUTTON_LIST(27-N2:26).UVALUE=END_UVALUE
TMP_VALUE=0
TMP_UVALUE=0
TMP_FLAG=0
RETURN
END

;----------------------------------------------------------------------
;
PRO CREATE_BUTTONS,BUTTON_MODE,BASE,NSLD
;
; Create Buttons in Window
;
COMMON DATCOM
COMMON WIDGETCOM
;
IF BUTTON_MODE LT 1 THEN RETURN
;
; Get List of Buttons
;
GET_BUTTON_LIST,BUTTON_LIST,BUTTON_MODE,Record.LOUT,NSLD
;
; Create Buttons
;
IF BUTTON_MODE GE 3 THEN BEGIN
   For i=0,3 DO BEGIN
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(i,BUTTON_MODE-1),$
          SET_VALUE=Button_List(i).Value,SET_UVALUE=Button_List(i).uvalue
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(i,BUTTON_MODE-1+4), MAP=BUTTON_LIST(i).FLAG
   ENDFOR       
ENDIF ELSE BEGIN
  NC=0
  FOR I=0,22 DO BEGIN
    IF BUTTON_LIST(i).FLAG NE 0 THEN BEGIN
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(nc,BUTTON_MODE-1),$
          SET_VALUE=Button_List(i).Value,SET_UVALUE=Button_List(i).uvalue
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(nc,BUTTON_MODE-1+4), /MAP
       NC=NC+1 
    ENDIF
  ENDFOR    
ENDELSE
;
IF BUTTON_LIST(26).FLAG NE 0 THEN BEGIN
   IF BUTTON_MODE LT 3 THEN BEGIN 
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(25,BUTTON_MODE-1),$
          SET_VALUE=Button_List(25).Value
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(26,BUTTON_MODE-1),$
          SET_VALUE=0,SET_UVALUE=Button_List(26).uvalue,SET_SLIDER_MAX=NSLD-1
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(25,BUTTON_MODE+3), /MAP
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(26,BUTTON_MODE+3), /MAP
   ENDIF ELSE BEGIN 
       NSLD2=NSLD(0)
       IF BUTTON_LIST(24).FLAG NE 0 THEN BEGIN
         WIDGET_CONTROL,WidgetInfo.BUTTONSET(23,BUTTON_MODE-1),$
           SET_VALUE=Button_List(23).Value
         WIDGET_CONTROL,WidgetInfo.BUTTONSET(24,BUTTON_MODE-1),$
           SET_VALUE=0,SET_UVALUE=Button_List(24).uvalue,SET_SLIDER_MAX=NSLD2-1
         WIDGET_CONTROL,WidgetInfo.BUTTONSET(23,BUTTON_MODE+3), /MAP
         WIDGET_CONTROL,WidgetInfo.BUTTONSET(24,BUTTON_MODE+3), /MAP
         NSLD2=NSLD(1)
       ENDIF
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(25,BUTTON_MODE-1),$
          SET_VALUE=Button_List(25).Value
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(26,BUTTON_MODE-1),$
          SET_VALUE=0,SET_UVALUE=Button_List(26).uvalue,SET_SLIDER_MAX=NSLD2-1
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(25,BUTTON_MODE+3), /MAP
       WIDGET_CONTROL,WidgetInfo.BUTTONSET(26,BUTTON_MODE+3), /MAP
   ENDELSE 
ENDIF
RETURN
END
 

;------------------------------------------------------------------------
;
PRO XGENESIS
;
;  Main routine - creates the application
;
COMMON WIDGETCOM
;
;  check, whether XGENESIS is allready running
;
IF xregistered('xgenesis') ne 0 THEN RETURN
;
; Set device parameter, clear data record
;
SET_DEFAULT  
SET_HELP,genhelp,xgenhelp,idlhelp  
PRESET  
;
; Get main widget base mainWinBase 
;
mainWinBase=WIDGET_BASE(TITLE='XGENESIS',MBAR=mainWinMenuBase,$
                        /TLB_KILL_REQUEST_EVENTS,$
		        MAP=0,/COLUMN)
;
; Set up font and color
;
DefaultFont='-adobe-helvetica-medium-r-normal--14-*-*-*'
WIDGET_CONTROL,Default_Font=DefaultFont(0)
;
;  Set Up Menu
;
GET_MENU_ENTRY, MENU_ENTRY               
NMENU=N_ELEMENTS(MENU_ENTRY)/2
MENU_ENTRY=REFORM(MENU_ENTRY,2,NMENU,/OVERWRITE)
mainWinMenu = CW_PDMENU(mainWinMenuBase,Menu_ENTRY(0,*),$
                        /RETURN_INDEX,/MBAR,/HELP,UVALUE='MENU_ROOT')
;
; Get base for Draw widget
;
mainWinTop=WIDGET_BASE(mainWinbase,XSIZE=930,YSIZE=640)
mainDrawBase=WIDGET_BASE(mainWintop,/COLUMN,XSIZE=800,YSIZE=635,XOFFSET=0,YOFFSET=0)
DrawBase=WIDGET_DRAW(mainDrawbase,RETAIN=2,XSIZE=800,YSIZE=635)
;
;
; Get base for Buttons, fill with unvisible buttons
;
mainButtonbase=INDGEN(4)
Buttonset=INDGEN(27,8)
For i=0,1 DO BEGIN
  mainButtonBase(i)=WIDGET_BASE(mainWintop,/COLUMN,YOFFSET=0,XOFFSET=801,MAP=0,SPACE=-6)
  for j=0,24 DO BEGIN
      buttonset(j,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
      buttonset(j,i)=WIDGET_BUTTON(buttonset(j,i+4),VALUE='a',UVALUE='',XSIZE=120,YSIZE=23)
  ENDFOR
  buttonset(25,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
  buttonset(25,i)=WIDGET_LABEL(buttonset(25,i+4),VALUE='a',XSIZE=16)
  buttonset(26,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
  buttonset(26,i)=WIDGET_SLIDER(buttonset(25,i+4),VALUE=0,UVALUE='',MIN=0,MAX=1,XSIZE=100)
ENDFOR
For i=2,3 DO BEGIN
  mainButtonBase(i)=WIDGET_BASE(mainWintop,/COLUMN,YOFFSET=0,XOFFSET=801,MAP=0,SPACE=-6)
  for j=0,22 DO BEGIN
      buttonset(j,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
      buttonset(j,i)=WIDGET_BUTTON(buttonset(j,i+4),VALUE='a',UVALUE='',XSIZE=120,ysize=23)
  ENDFOR
  buttonset(23,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
  buttonset(23,i)=WIDGET_LABEL(buttonset(23,i+4),VALUE='a',XSIZE=12)
  buttonset(24,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
  buttonset(24,i)=WIDGET_SLIDER(buttonset(23,i+4),VALUE=0,UVALUE='',MIN=0,MAX=1,XSIZE=100)
  dummy=WIDGET_LABEL(buttonset(24,i+4),value='',xsize=6)
  buttonset(25,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
  buttonset(25,i)=WIDGET_LABEL(buttonset(25,i+4),VALUE='a',XSIZE=12)
  buttonset(26,i+4)=WIDGET_BASE(mainButtonBase(i),/ROW,MAP=0)  
  buttonset(26,i)=WIDGET_SLIDER(buttonset(25,i+4),VALUE=0,UVALUE='',MIN=0,MAX=1,XSIZE=100)
ENDFOR
;
; Get Base for Comment widget
;
mainCommentBase=WIDGET_BASE(mainWinbase,/COLUMN,/FRAME)
CommentBase=WIDGET_LABEL(mainCommentBase,VALUE='Xgenesis - Version 0.1',$
                         /ALIGN_LEFT,/DYNAMIC_RESIZE)
;
; realize main widget and get draw ID
;
WIDGET_CONTROL,mainWinBase,/REALIZE,/MAP
WIDGET_CONTROL,DrawBase,GET_VALUE=DrawID
WSET, DrawID
;
; store all needed information in a structure, clear old arrays
;
WidgetInfo =  {$
		mainWinBase:mainWinBase,$
		mainWinMenu:mainWinMenu,$
   		MenuEntry:MENU_ENTRY(1,*),$
                mainWinTop:mainWinTop,$
		mainButtonBase:mainButtonBase,$
                ButtonSet:ButtonSet,$
		ButtonMode:1L,$
		Drawbase:DrawBase,$
		DrawID:DrawID,$
		CommentBase:CommentBase,$
		DefaultFont:DefaultFont}
DrawInfo   =  {$
		TITLE:'',$
		XTITLE:'',$
		YTITLE:'',$
                ZTITLE:'',$
		PSYM:0L,$
		FLAG:0L,$
		FONTSIZE:1.,$
		FONTMODE:-1L,$
		LINESTYLE:0L,$
		LINEWIDTH:1.,$
                LOG:0L,$
		DEV:0L,$
		XSIZE:700L,$
		YSIZE:485L}
MENU_ENTRY=0
LAB_BUTTON=0
;
;  Start Application
;
XMANAGER, 'xgenesis',mainWinBase,EVENT_HANDLER='xgen_event',/NO_BLOCK

END
