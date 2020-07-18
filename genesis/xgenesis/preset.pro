pro preset

;
;  initialize common blocks, graphic device
;

common export,ex_data,ex_x		; data for export/saving
common enviroment,env   		; runtime enviroment
common file,io          		; file access
common widget,base      		; widget informations
common plot, setting,labels,asignment,par_label,asignment_old,asignment_new
common data, data_record,data_global,data_profile,data_info ; data set 


ex_data=0
ex_x=0

env = { platform: '', $  ; platform
        depth: 0L }      ; bit-depth of graphic device


io = {  curdir: '', 	$      ; current directory
        error: 0L ,    $       ; last error
        error_msg: '', $       ; error messages
        filename: '',  $       ; filename -> '' = no file selected
  	path:     '',  $       ; path to current file
 	type:'empty',  $       ; sfiletype of outputfile (original, hdf, xml, sdds)
	particle_size : 0L, $  ; record length for '.par' file
        particle_nz : 0L, $    ; records in z
	particle_nt : 0L, $    ; records in t
        particle_isopen : 0B, $; file is open
        field_size: 0L, $      ; record length for '.fld' files
	field_nz: 0L, $        ; records in z
        field_nt: 0L, $        ; records in t
        field_isopen : 0B ,$   ; file is open
        field_harmonic : 1L, $ ; harmonics to be plotted
        field_enforceopen : 0B } ; when switching files, enfore open of files       

base={mainbase: 0L, $ ;main base
      menubase: 0L, $ ;menu base
      menuid:  0L,  $ ;menu id
      buttonbase:0L,$ ;plotselection base 
      buttonsecbase:0L,$ ;plotsection base for particles and field
      statbase:0L,$ ; statistic widget
      specmin:0L, $ ; minimum value of spectral range
      specmax:0L, $ ; maximum value of spectral range
      zlabelbase:0L,$ ;label for z-position
      slabelbase:0L}  ;label for s-position 	

setting = {recz:0L , $ ; current record in z
           rect:0L , $ ; current record in t
	   parx:1L , $ ; current x-column for particle distribution plot
	   pary:0L , $ ; current y-column for particle distribution plot
           particle_recz : 0L, $  ; current record in z
           particle_rect : 0L, $  ; current record in t
           field_recz: 0L, $      ; current record in z
           field_rect: 0L, $      ; current record in t
           overplot: 0B , $ ; overplot
           save_ani: 0B , $ ; save frames of animations
           logpower: 0B , $ ; plot radiation power vs z by default on log scale 
           inclspec: 0B , $ ; include bandwidth and spectrum in animation
           fixspec:  0B , $ ; enforce fixed plotting range in nm for spectrum
; unused 	   log: 0B , $ ; do log scale (except for power, where it is inverted)
	   plotoption:0L , $ ; plot style (normal, averaged etc.)
           plotstyle2d:0L, $  ; 2d plot stile (mesh, grid etc.)
           calc_sat_average:0B, $ ; average of s when calculating bunching
           calc_sat_bunching:0B, $ ; use bunching instead of power
           fzoom:0L} ; zoom for field plots 

labels=[['Power','P [W]'], $				;0     ; this is the order as they should appear on the window
	['Increment','(1/P)dP/dz [m!U-1!N]'], $		;1
    	['Phase','!9f!X [rad]'],$			;2
	['Rad. Size','!9s!X!Irad!N [m]'], $		;3
        ['Divergence','!9q!Iq!X!N [rad]'],$		;4
	['Spectrum','P(!9l!X) [a.u.]'],$		;5
	['Bandwidth','bw [%]'],$			;6
	['Far Field','dP/d!9W!X [W/rad!U2!N]'],$	;7
	['Current','I [A]'],$				;8
	['Energy','<!9g!X> - !9g!X!I0!N'],$		;9
	['Energy Spread','!9s!Ig!N!X'],$		;10
	['Beam Size in X','!9s!X!Ix!N [m]'],$		;11
	['Beam Size in Y','!9s!X!Iy!N [m]'],$		;12
	['Beam Centroid in X','<x> [m]'],$		;13
	['Beam Centroid in Y','<y> [m]'],$		;14
	['Bunching Fundamental','|<exp(i!9q!X)>|'],$	;15
	['Phase Fundamental','<!9q!X> [rad]'],$		;16
	['Power 2nd Harm.','P [W]'],$			;17
	['Bunching 2nd Harm.','|<exp(i2!9q!X)>|'],$	;18
	['Phase 2nd Harm.','<2!9q!X> [rad]'],$		;19
	['Power 3rd Harm.','P [W]'],$		        ;20
	['Bunching 3rd Harm.','|<exp(i3!9q!X)>|'],$	;21
	['Phase 3rd Harm.','<3!9q!X> [rad]'],$		;22
	['Power 4th Harm.','P [W]'],$		      	;23
	['Bunching 4th Harm.','|<exp(i4!9q!X)>|'],$	;24
	['Phase 4th Harm.','<4!9q!X> [rad]'],$		;25
	['Power 5th Harm.','P [W]'],$			;26
	['Bunching 5th Harm.','|<exp(i5!9q!X)>|'],$	;27
	['Phase 5th Harm.','<5!9q!X> [rad]'],$		;28
	['Power 6th Harm.','P [W]'],$			;29
	['Bunching 6th Harm.','|<exp(i6!9q!X)>|'],$	;30
	['Phase 6th Harm.','<6!9q!X> [rad]'],$		;31
	['Power 7th Harm.','P [W]'],$			;32
	['Bunching 7th Harm.','|<exp(i7!9q!X)>|'],$	;33
	['Phase 7th Harm.','<7!9q!X> [rad]'],$		;34
	['Error','!9D!XP/P [%]']]			;35

; asignment links the labels array with the column of the input file, negative numbers are special or ignored
; old output format
asignment_old=[0,1,3,4,5,-1,-2,14,-3,6,13,8,9,11,12,7, $   	; label 0-15
               19,-6,15,20,-6,16,21,-6,17,22,-6,18,23, $     	; label 16-28
               -6,-6,-6,-6,-6,-6,10] 				; label 29-35
; new output format
asignment_new=[0,1,3,4,5,-1,-2,14,-3,6,13,8,9,11,12,7, $   	; label 0-15
 	       -6,16,15,17,20,19,21,24,23,25,28,27,29,$		; label 16-28
               32,31,33,36,35,37,10]				; label 29-35
asignment=asignment_old


par_label=['!9g!X','!9q!X [rad]','x [m]','y [m]','!9gb!X!Lx!N','!9gb!X!Ly!N']


data_record=dblarr(1,1,1)
data_global=dblarr(3,1)
data_profile=dblarr(1)
data_info= { order: [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1] , $    ; array to hold column asignment, derived from lout
             ncol:0L     , $    ; number of columns
             isscan: 0B  , $    ; flag to indicate scan runs
             nz: 0L , $		; entries per records
	     nt: 0L , $         ; number of records
             xlamds: 0.0, $     ; resonant wavelength
  	     dt: 0. ,$          ; sample spacing of slices
             version: 1L, $     ; check for updated output format of genesis
             hasharmonics: 0B,$ ; check for new version of harmonics
             harmonics:[1,0,0,0,0,0,0,0,0,0]}           ; numbers of harmonics
return
end
