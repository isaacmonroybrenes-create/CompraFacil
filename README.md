# CompraFácil

Sistema académico de gestión de compras en línea con Oracle Database, SQL, PL/SQL y Python.

## Estructura
- `sql/01_crear_tablas.sql`: crea las cinco tablas y sus restricciones.
- `sql/02_paquete_crud.sql`: paquete PL/SQL con operaciones de mantenimiento, gestión de pedidos y reportes.
- `src/`: código de la aplicación Python (pendiente de implementar).
- `docs/`: documentación y diagrama relacional.

## Instalación
1. Abrir Oracle SQL Developer y conectarse con un esquema de desarrollo.
2. Ejecutar `sql/01_crear_tablas.sql`.
3. Ejecutar `sql/02_paquete_crud.sql`.
4. Verificar que `PKG_COMPRAS` compile sin errores en la pestaña de errores del esquema.
5. Probar las operaciones antes de utilizar datos reales.

## Conexión Python
Instalar el controlador con `python -m pip install oracledb`. La conexión debe configurarse con variables de entorno; nunca guardar contraseñas en el repositorio.

## Importante
El modelo se preparó tomando como base la descripción textual del Avance 1. Antes de entregar, comparar todos los nombres y tipos de columnas con el diagrama relacional definitivo y probar los procedimientos en la versión de Oracle que use el curso.
