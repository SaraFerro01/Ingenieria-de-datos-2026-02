
-- Calcular inasistencias por curso 50--
select  inasistencias count (*) as asistencia 
from x.inasistencia on y.idcurso, x.idcurso=y.idcurso
join curso on idcurso 
where aistencia <> 'ASISTIO'
group by x.curso 
order by asc;



-- Cambiar estado del usuario 06 (proceso) --  
drop precedure if exists p_cestadosu
delimiter //
begin 
create precedure (in p_idusuario, in p_rol)



end if//
delimiter; 
-- 15 seleccionar curso -- 
select * curso 