
import oracledb
import getpass

print("=== CONEXIÓN COMPRAFÁCIL ===")

password = getpass.getpass("Contraseña de Oracle: ")

try:
    conexion = oracledb.connect(
        user="COMPRAFACIL",
        password=password,
        dsn="localhost:1521/FREEPDB1"
    )

    cursor = conexion.cursor()

    cursor.execute("SELECT USER FROM DUAL")
    usuario = cursor.fetchone()[0]

    cursor.execute("SELECT COUNT(*) FROM PRODUCTO")
    productos = cursor.fetchone()[0]

    print("Conexión exitosa con Oracle")
    print("Usuario:", usuario)
    print("Productos registrados:", productos)

    cursor.close()
    conexion.close()

except oracledb.Error as error:
    print("Error de conexión:", error)