-- CompraFácil | CRUD mediante procedimientos almacenados
-- Ejecutar después de 01_crear_tablas.sql.
-- Los procedimientos usan parámetros enlazados desde Python; la aplicación no debe
-- ejecutar SQL directo para las operaciones del negocio.

CREATE OR REPLACE PACKAGE pkg_compras AS
  PROCEDURE crear_categoria(p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2, p_id OUT NUMBER);
  PROCEDURE actualizar_categoria(p_id IN NUMBER, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2);
  PROCEDURE eliminar_categoria(p_id IN NUMBER);
  PROCEDURE listar_categorias(p_resultado OUT SYS_REFCURSOR);

  PROCEDURE crear_producto(p_categoria IN NUMBER, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2,
    p_precio IN NUMBER, p_stock IN NUMBER, p_estado IN VARCHAR2, p_id OUT NUMBER);
  PROCEDURE actualizar_producto(p_id IN NUMBER, p_categoria IN NUMBER, p_nombre IN VARCHAR2,
    p_descripcion IN VARCHAR2, p_precio IN NUMBER, p_stock IN NUMBER, p_estado IN VARCHAR2);
  PROCEDURE eliminar_producto(p_id IN NUMBER);
  PROCEDURE listar_productos(p_resultado OUT SYS_REFCURSOR);

  PROCEDURE crear_cliente(p_nombre IN VARCHAR2, p_apellidos IN VARCHAR2, p_correo IN VARCHAR2,
    p_telefono IN VARCHAR2, p_direccion IN VARCHAR2, p_id OUT NUMBER);
  PROCEDURE actualizar_cliente(p_id IN NUMBER, p_nombre IN VARCHAR2, p_apellidos IN VARCHAR2,
    p_correo IN VARCHAR2, p_telefono IN VARCHAR2, p_direccion IN VARCHAR2);
  PROCEDURE eliminar_cliente(p_id IN NUMBER);
  PROCEDURE listar_clientes(p_resultado OUT SYS_REFCURSOR);

  PROCEDURE crear_pedido(p_cliente IN NUMBER, p_id OUT NUMBER);
  PROCEDURE cambiar_estado_pedido(p_id IN NUMBER, p_estado IN VARCHAR2);
  PROCEDURE eliminar_pedido_vacio(p_id IN NUMBER);
  PROCEDURE listar_pedidos(p_resultado OUT SYS_REFCURSOR);

  PROCEDURE agregar_detalle(p_pedido IN NUMBER, p_producto IN NUMBER, p_cantidad IN NUMBER);
  PROCEDURE actualizar_cantidad_detalle(p_detalle IN NUMBER, p_cantidad IN NUMBER);
  PROCEDURE eliminar_detalle(p_detalle IN NUMBER);
  PROCEDURE listar_detalles(p_pedido IN NUMBER, p_resultado OUT SYS_REFCURSOR);
  PROCEDURE reporte_productos_vendidos(p_resultado OUT SYS_REFCURSOR);
  PROCEDURE reporte_ventas_periodo(p_desde IN DATE, p_hasta IN DATE, p_resultado OUT SYS_REFCURSOR);
END pkg_compras;
/

CREATE OR REPLACE PACKAGE BODY pkg_compras AS
  PROCEDURE crear_categoria(p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    INSERT INTO categoria(nombre, descripcion) VALUES (p_nombre, p_descripcion)
    RETURNING id_categoria INTO p_id;
  END;
  PROCEDURE actualizar_categoria(p_id IN NUMBER, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2) IS
  BEGIN
    UPDATE categoria SET nombre=p_nombre, descripcion=p_descripcion WHERE id_categoria=p_id;
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20001,'Categoría no encontrada'); END IF;
  END;
  PROCEDURE eliminar_categoria(p_id IN NUMBER) IS
  BEGIN
    DELETE FROM categoria WHERE id_categoria=p_id;
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20002,'Categoría no encontrada'); END IF;
  END;
  PROCEDURE listar_categorias(p_resultado OUT SYS_REFCURSOR) IS
  BEGIN OPEN p_resultado FOR SELECT id_categoria,nombre,descripcion FROM categoria ORDER BY id_categoria; END;

  PROCEDURE crear_producto(p_categoria IN NUMBER, p_nombre IN VARCHAR2, p_descripcion IN VARCHAR2,
    p_precio IN NUMBER, p_stock IN NUMBER, p_estado IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    INSERT INTO producto(id_categoria,nombre,descripcion,precio,stock,estado)
    VALUES(p_categoria,p_nombre,p_descripcion,p_precio,p_stock,p_estado) RETURNING id_producto INTO p_id;
  END;
  PROCEDURE actualizar_producto(p_id IN NUMBER, p_categoria IN NUMBER, p_nombre IN VARCHAR2,
    p_descripcion IN VARCHAR2, p_precio IN NUMBER, p_stock IN NUMBER, p_estado IN VARCHAR2) IS
  BEGIN
    UPDATE producto SET id_categoria=p_categoria,nombre=p_nombre,descripcion=p_descripcion,
      precio=p_precio,stock=p_stock,estado=p_estado WHERE id_producto=p_id;
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20003,'Producto no encontrado'); END IF;
  END;
  PROCEDURE eliminar_producto(p_id IN NUMBER) IS
  BEGIN
    DELETE FROM producto WHERE id_producto=p_id;
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20004,'Producto no encontrado'); END IF;
  END;
  PROCEDURE listar_productos(p_resultado OUT SYS_REFCURSOR) IS
  BEGIN OPEN p_resultado FOR
    SELECT p.id_producto,p.id_categoria,c.nombre AS categoria,p.nombre,p.descripcion,p.precio,p.stock,p.estado
    FROM producto p JOIN categoria c ON c.id_categoria=p.id_categoria ORDER BY p.id_producto;
  END;

  PROCEDURE crear_cliente(p_nombre IN VARCHAR2, p_apellidos IN VARCHAR2, p_correo IN VARCHAR2,
    p_telefono IN VARCHAR2, p_direccion IN VARCHAR2, p_id OUT NUMBER) IS
  BEGIN
    INSERT INTO cliente(nombre,apellidos,correo,telefono,direccion)
    VALUES(p_nombre,p_apellidos,p_correo,p_telefono,p_direccion) RETURNING id_cliente INTO p_id;
  END;
  PROCEDURE actualizar_cliente(p_id IN NUMBER, p_nombre IN VARCHAR2, p_apellidos IN VARCHAR2,
    p_correo IN VARCHAR2, p_telefono IN VARCHAR2, p_direccion IN VARCHAR2) IS
  BEGIN
    UPDATE cliente SET nombre=p_nombre,apellidos=p_apellidos,correo=p_correo,
      telefono=p_telefono,direccion=p_direccion WHERE id_cliente=p_id;
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20005,'Cliente no encontrado'); END IF;
  END;
  PROCEDURE eliminar_cliente(p_id IN NUMBER) IS
  BEGIN
    DELETE FROM cliente WHERE id_cliente=p_id;
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20006,'Cliente no encontrado'); END IF;
  END;
  PROCEDURE listar_clientes(p_resultado OUT SYS_REFCURSOR) IS
  BEGIN OPEN p_resultado FOR
    SELECT id_cliente,nombre,apellidos,correo,telefono,direccion,fecha_registro FROM cliente ORDER BY id_cliente;
  END;

  PROCEDURE crear_pedido(p_cliente IN NUMBER, p_id OUT NUMBER) IS
  BEGIN
    INSERT INTO pedido(id_cliente,estado,total) VALUES(p_cliente,'PENDIENTE',0)
    RETURNING id_pedido INTO p_id;
  END;
  PROCEDURE cambiar_estado_pedido(p_id IN NUMBER, p_estado IN VARCHAR2) IS
  BEGIN
    UPDATE pedido SET estado=p_estado WHERE id_pedido=p_id;
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20007,'Pedido no encontrado'); END IF;
  END;
  PROCEDURE eliminar_pedido_vacio(p_id IN NUMBER) IS
  BEGIN
    DELETE FROM pedido WHERE id_pedido=p_id AND NOT EXISTS
      (SELECT 1 FROM detalle_pedido d WHERE d.id_pedido=p_id);
    IF SQL%ROWCOUNT=0 THEN RAISE_APPLICATION_ERROR(-20008,'Pedido inexistente o contiene detalles'); END IF;
  END;
  PROCEDURE listar_pedidos(p_resultado OUT SYS_REFCURSOR) IS
  BEGIN OPEN p_resultado FOR
    SELECT pe.id_pedido,pe.id_cliente,c.nombre,c.apellidos,pe.fecha_pedido,pe.estado,pe.total
    FROM pedido pe JOIN cliente c ON c.id_cliente=pe.id_cliente ORDER BY pe.fecha_pedido DESC;
  END;

  PROCEDURE recalcular_total(p_id_pedido IN NUMBER) IS
  BEGIN
    UPDATE pedido SET total=(SELECT NVL(SUM(subtotal),0) FROM detalle_pedido WHERE id_pedido=p_id_pedido)
    WHERE id_pedido=p_id_pedido;
  END;

  PROCEDURE agregar_detalle(p_pedido IN NUMBER, p_producto IN NUMBER, p_cantidad IN NUMBER) IS
    v_stock NUMBER; v_precio NUMBER; v_estado VARCHAR2(20); v_pedido_estado VARCHAR2(20);
  BEGIN
    IF p_cantidad <= 0 THEN RAISE_APPLICATION_ERROR(-20009,'La cantidad debe ser mayor que cero'); END IF;
    SELECT estado INTO v_pedido_estado FROM pedido WHERE id_pedido=p_pedido FOR UPDATE;
    IF v_pedido_estado IN ('ENTREGADO','CANCELADO') THEN
      RAISE_APPLICATION_ERROR(-20010,'No se pueden modificar pedidos entregados o cancelados');
    END IF;
    SELECT stock,precio,estado INTO v_stock,v_precio,v_estado FROM producto WHERE id_producto=p_producto FOR UPDATE;
    IF v_estado <> 'ACTIVO' THEN RAISE_APPLICATION_ERROR(-20011,'Producto inactivo'); END IF;
    IF v_stock < p_cantidad THEN RAISE_APPLICATION_ERROR(-20012,'Existencias insuficientes'); END IF;
    INSERT INTO detalle_pedido(id_pedido,id_producto,cantidad,precio_unitario,subtotal)
    VALUES(p_pedido,p_producto,p_cantidad,v_precio,p_cantidad*v_precio);
    UPDATE producto SET stock=stock-p_cantidad WHERE id_producto=p_producto;
    recalcular_total(p_pedido);
  END;

  PROCEDURE actualizar_cantidad_detalle(p_detalle IN NUMBER, p_cantidad IN NUMBER) IS
    v_pedido NUMBER; v_producto NUMBER; v_anterior NUMBER; v_stock NUMBER; v_precio NUMBER;
    v_estado VARCHAR2(20);
  BEGIN
    IF p_cantidad <= 0 THEN RAISE_APPLICATION_ERROR(-20013,'La cantidad debe ser mayor que cero'); END IF;
    SELECT id_pedido,id_producto,cantidad,precio_unitario INTO v_pedido,v_producto,v_anterior,v_precio
      FROM detalle_pedido WHERE id_detalle=p_detalle FOR UPDATE;
    SELECT stock,estado INTO v_stock,v_estado FROM producto WHERE id_producto=v_producto FOR UPDATE;
    IF v_estado <> 'ACTIVO' THEN RAISE_APPLICATION_ERROR(-20014,'Producto inactivo'); END IF;
    IF p_cantidad > v_anterior AND v_stock < (p_cantidad-v_anterior) THEN
      RAISE_APPLICATION_ERROR(-20015,'Existencias insuficientes');
    END IF;
    UPDATE producto SET stock=stock+(v_anterior-p_cantidad) WHERE id_producto=v_producto;
    UPDATE detalle_pedido SET cantidad=p_cantidad,subtotal=p_cantidad*v_precio WHERE id_detalle=p_detalle;
    recalcular_total(v_pedido);
  END;

  PROCEDURE eliminar_detalle(p_detalle IN NUMBER) IS
    v_pedido NUMBER; v_producto NUMBER; v_cantidad NUMBER;
  BEGIN
    SELECT id_pedido,id_producto,cantidad INTO v_pedido,v_producto,v_cantidad
      FROM detalle_pedido WHERE id_detalle=p_detalle FOR UPDATE;
    DELETE FROM detalle_pedido WHERE id_detalle=p_detalle;
    UPDATE producto SET stock=stock+v_cantidad WHERE id_producto=v_producto;
    recalcular_total(v_pedido);
  END;

  PROCEDURE listar_detalles(p_pedido IN NUMBER, p_resultado OUT SYS_REFCURSOR) IS
  BEGIN OPEN p_resultado FOR
    SELECT d.id_detalle,d.id_pedido,d.id_producto,p.nombre,d.cantidad,d.precio_unitario,d.subtotal
    FROM detalle_pedido d JOIN producto p ON p.id_producto=d.id_producto
    WHERE d.id_pedido=p_pedido ORDER BY d.id_detalle;
  END;
  PROCEDURE reporte_productos_vendidos(p_resultado OUT SYS_REFCURSOR) IS
  BEGIN OPEN p_resultado FOR
    SELECT p.id_producto,p.nombre,NVL(SUM(d.cantidad),0) AS unidades_vendidas
    FROM producto p LEFT JOIN detalle_pedido d ON d.id_producto=p.id_producto
    GROUP BY p.id_producto,p.nombre ORDER BY unidades_vendidas DESC;
  END;
  PROCEDURE reporte_ventas_periodo(p_desde IN DATE, p_hasta IN DATE, p_resultado OUT SYS_REFCURSOR) IS
  BEGIN OPEN p_resultado FOR
    SELECT TRUNC(fecha_pedido) AS fecha, SUM(total) AS total_ventas
    FROM pedido WHERE fecha_pedido >= TRUNC(p_desde)
      AND fecha_pedido < TRUNC(p_hasta)+1 AND estado <> 'CANCELADO'
    GROUP BY TRUNC(fecha_pedido) ORDER BY fecha;
  END;
END pkg_compras;
/
