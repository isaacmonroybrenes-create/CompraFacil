# Notas del modelo

Tablas definidas: CATEGORIA, PRODUCTO, CLIENTE, PEDIDO y DETALLE_PEDIDO.

Relaciones:
- CATEGORIA 1:N PRODUCTO
- CLIENTE 1:N PEDIDO
- PEDIDO 1:N DETALLE_PEDIDO
- PRODUCTO 1:N DETALLE_PEDIDO

Restricciones incluidas: correo de cliente único; precio, stock, cantidad y subtotales validados; claves primarias y foráneas; estados controlados mediante CHECK.

Pendiente de validación humana: confirmar que todos los nombres y columnas coinciden con la figura del diagrama relacional del documento y ejecutar los scripts en el entorno Oracle del curso.
