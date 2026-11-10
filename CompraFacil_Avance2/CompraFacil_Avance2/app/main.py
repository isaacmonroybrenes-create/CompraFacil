"""CompraFacil: consola de demostración Oracle. Sin SELECT/INSERT/UPDATE/DELETE en Python."""
import os
from getpass import getpass
import oracledb

FIELDS = {
    "CATEGORIA": [("nombre", str), ("descripcion", str)],
    "PRODUCTO": [("id_categoria", int), ("nombre", str), ("descripcion", str), ("precio", float), ("stock", int), ("estado", str)],
    "CLIENTE": [("nombre", str), ("apellidos", str), ("correo", str), ("telefono", str), ("direccion", str)],
    "PEDIDO": [("id_cliente", int), ("estado", str), ("total", float)],
    "DETALLE_PEDIDO": [("id_pedido", int), ("id_producto", int), ("cantidad", int), ("precio_unitario", float)],
}

def conectar():
    usuario = os.getenv("DB_USER", "COMPRAFACIL")
    password = os.getenv("DB_PASSWORD") or getpass("Contraseña Oracle (no se muestra): ")
    dsn = os.getenv("DB_DSN", "localhost:1521/FREEPDB1")
    return oracledb.connect(user=usuario, password=password, dsn=dsn)

def leer_campos(tabla):
    datos = []
    for campo, convertir in FIELDS[tabla]:
        datos.append(convertir(input(f"{campo}: ").strip()))
    return datos

def mostrar_cursor(cur):
    for fila in cur:
        print(" | ".join(str(valor) for valor in fila))

def ejecutar(conn, tabla, operacion):
    nombre = f"SP_{tabla}_{operacion}"
    with conn.cursor() as cursor:
        if operacion == "LISTAR":
            salida = conn.cursor()
            try:
                cursor.callproc(nombre, [salida])
                mostrar_cursor(salida)
            finally: salida.close()
        elif operacion == "OBTENER":
            pk = int(input("ID: "))
            salida = conn.cursor()
            try:
                cursor.callproc(nombre, [pk, salida]); mostrar_cursor(salida)
            finally: salida.close()
        elif operacion == "ELIMINAR":
            cursor.callproc(nombre, [int(input("ID: "))]); conn.commit()
        elif operacion == "CREAR":
            valores = leer_campos(tabla)
            nuevo_id = cursor.var(oracledb.NUMBER)
            cursor.callproc(nombre, valores + [nuevo_id]); conn.commit()
            print("Creado ID:", nuevo_id.getvalue())
        elif operacion == "ACTUALIZAR":
            pk = int(input("ID: "))
            cursor.callproc(nombre, [pk] + leer_campos(tabla)); conn.commit()
        print("Operación terminada.")

def main():
    print("CompraFacil - CRUD por procedimientos almacenados")
    with conectar() as conn:
        while True:
            print("\nTablas:", ", ".join(FIELDS))
            tabla = input("Tabla (o SALIR): ").strip().upper()
            if tabla == "SALIR": break
            if tabla not in FIELDS: print("Tabla inválida"); continue
            operacion = input("CREAR / LISTAR / OBTENER / ACTUALIZAR / ELIMINAR: ").strip().upper()
            if operacion not in {"CREAR", "LISTAR", "OBTENER", "ACTUALIZAR", "ELIMINAR"}:
                print("Operación inválida"); continue
            try: ejecutar(conn, tabla, operacion)
            except (oracledb.Error, ValueError) as exc:
                conn.rollback(); print("Error:", exc)

if __name__ == "__main__": main()
