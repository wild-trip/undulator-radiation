pro export_data

common file,io
common export,ex_data,ex_x

data=reform(ex_data)
rsize=size(data)

case rsize[0] of
0:  return
1:  begin
      n=rsize[1]
      putval=dblarr(2,n)
      putval[1,*]=data
      putval[0,*]=ex_x[0:n-1]
      file=dialog_pickfile(/write,path=io.curdir,file='out.dat',$
                   title='Export 1D Array to ASCII File',filter='*.dat')
      if file eq '' then return
      openw,lun,file,/get_lun
      printf,lun,n
      printf,lun,putval,format='(2E19.11)'
      free_lun,lun
    end
2:  begin
      n1=long(rsize[1])
      n2=long(rsize[2])
      file=dialog_pickfile(/write,path=io.curdir,file='out.dat',$
                 title='Export 2D Array to Binary File',filter='*.dat')
      if file eq '' then return
      openw,lun,file,/get_lun
      writeu,lun,n1
      writeu,lun,n2
      writeu,lun,data
      free_lun,lun
    end
else: return
endcase


return

end
