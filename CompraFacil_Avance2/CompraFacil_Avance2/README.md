# CompraFácil — Segundo avance (borrador técnico para pruebas)

Repositorio del proyecto: https://github.com/isaacmonroybrenes-create/CompraFacil

## Requisitos
Oracle Database Free (servicio FREEPDB1), SQL Developer, Python 3.10+ y `pip install -r requirements.txt`.

## Orden de ejecución
1. Conectar como SYSTEM a `localhost:1521/FREEPDB1` y ejecutar `sql/00_usuario.sql` **tras cambiar la contraseña de ejemplo**. Si COMPRAFACIL ya existe, no volver a crear el usuario.
2. Crear conexión con usuario COMPRAFACIL y ejecutar en orden `01_tablas.sql`, `02_crud_25_procedimientos.sql`, `03_funciones_15.sql`, `04_vistas_10.sql`, `05_triggers_5.sql`, `06_paquetes_10_15_cursores.sql`.
3. Ejecutar `07_datos_prueba.sql` una sola vez y `08_verificacion.sql`; confirmar que `USER_ERRORS` no devuelve filas y que los objetos están VALID.
4. Ejecutar `python app/main.py`; configurar opcionalmente `DB_USER`, `DB_PASSWORD`, `DB_DSN` en variables de entorno. No subir contraseñas.

## Alcance y cautelas
Se incluye CRUD de cinco tablas con 25 procedimientos, 15 funciones, 10 vistas, 10 paquetes, 5 triggers y 15 cursores explícitos en los paquetes de reportes. La aplicación Python invoca únicamente procedimientos almacenados. El total de pedido se recalcula al modificar detalles mediante trigger compuesto. **Este paquete no se ha probado en una instancia real de Oracle**; es indispensable compilar, probar y documentar resultados antes de entregar. Los procedimientos de detalle no reservan ni descuentan inventario: ese flujo comercial queda pendiente para el proyecto final. Las eliminaciones con referencias activas pueden fallar por integridad referencial, lo cual es esperado. No ejecutar scripts de creación dos veces sin limpiar el esquema.

## Evidencias a reunir
Capturas de conexión Oracle, `USER_OBJECTS` con estado VALID, `USER_ERRORS` sin errores, CRUD desde Python, datos en vistas, y commits de cada integrante en GitHub.
