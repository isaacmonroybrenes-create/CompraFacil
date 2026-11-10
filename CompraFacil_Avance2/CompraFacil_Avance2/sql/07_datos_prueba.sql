-- Ejecutar conectado como COMPRAFACIL, una sola vez, despues de 01-06.
DECLARE v_cat NUMBER; v_prod NUMBER; v_cli NUMBER; v_ped NUMBER; v_det NUMBER;
BEGIN
 SP_CATEGORIA_CREAR('Tecnologia','Articulos electronicos',v_cat);
 SP_PRODUCTO_CREAR(v_cat,'Mouse USB','Mouse optico',7500,20,'ACTIVO',v_prod);
 SP_CLIENTE_CREAR('Ana','Rodriguez','ana.comprafacil@example.com','88880000','San Jose',v_cli);
 SP_PEDIDO_CREAR(v_cli,'PENDIENTE',0,v_ped);
 SP_DETALLE_PEDIDO_CREAR(v_ped,v_prod,2,7500,v_det);
 DBMS_OUTPUT.PUT_LINE('Datos insertados. Pedido '||v_ped||' total esperado: 15000');
 COMMIT;
END;
/
