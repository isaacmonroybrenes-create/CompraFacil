-- Ejecutar como COMPRAFACIL; habilitar DBMS Output.
SELECT object_type, status, COUNT(*) cantidad FROM user_objects
WHERE object_type IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY','VIEW','TRIGGER')
GROUP BY object_type,status ORDER BY object_type,status;
SELECT name,type,line,position,text FROM user_errors ORDER BY name,sequence;
SELECT * FROM vw_total_por_pedido;
SELECT * FROM vw_catalogo;
SELECT table_name,column_id,column_name,data_type,nullable FROM user_tab_columns
WHERE table_name IN ('CATEGORIA','PRODUCTO','CLIENTE','PEDIDO','DETALLE_PEDIDO')
ORDER BY table_name,column_id;
-- Comprobacion de cursor y funcion
DECLARE v_cur SYS_REFCURSOR; v_id NUMBER; v_nombre VARCHAR2(100); v_desc VARCHAR2(500);
BEGIN
 SP_CATEGORIA_LISTAR(v_cur);
 LOOP FETCH v_cur INTO v_id,v_nombre,v_desc; EXIT WHEN v_cur%NOTFOUND;
 DBMS_OUTPUT.PUT_LINE(v_id||' - '||v_nombre); END LOOP;
 CLOSE v_cur;
 DBMS_OUTPUT.PUT_LINE('Categorias: '||FN_CATEGORIA_CONTAR());
END;
/
