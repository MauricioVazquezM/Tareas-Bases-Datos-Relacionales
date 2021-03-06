---TAREA EXTRA
---TAREA EXTRA
---TAREA EXTRA
---TAREA EXTRA
---TAREA EXTRA

---Descripcion:
--Una de las métricas para saber si un cliente es bueno, aparte de la suma y el promedio de sus pagos, 
--es si tenemos una progresión consistentemente creciente en los montos.
--Debemos calcular para cada cliente su promedio mensual de deltas en los pagos de sus órdenes en la tabla order_details en la BD de Northwind, es decir, 
--la diferencia entre el monto total de una orden en tiempo t y el anterior en t-1, 
--para tener la foto completa sobre el customer lifetime value de cada miembro de nuestra cartera.

--SOLUCION:
select * from customers c2;

with orders as(
	select o.customer_id as customer_id, o.order_id as orden, od.unit_price*od.quantity as tot_compra, o.order_date as datt 
	from order_details od join orders o using (order_id) join customers c using(customer_id)
	), 
	diff as(
	select o.customer_id ,(tot_compra -lag(tot_compra) over (partition by o.customer_id order by datt asc)) as delta 
	from orders o
	), 
	avgg as(
	select d.customer_id, avg(d.delta) as avgg_prog 
	from diff d
	group by d.customer_id
	order by avgg_prog asc
	)
	select a.customer_id, a.avgg_prog
	from avgg a
	group by a.customer_id, a.avgg_prog
	order by avgg_prog desc;

