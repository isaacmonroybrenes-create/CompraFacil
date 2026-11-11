
import oracledb
import getpass

# Prueba de conexión entre Python y la base de datos Oracle de CompraFácil.
print("=== CONEXIÓN COMPRAFÁCIL ===")

# Solicita la contraseña sin mostrarla en pantalla.
password = getpass.getpass("Contraseña de Oracle: ")

try:
# Establece la conexión con el usuario COMPRAFACIL.
    conexion = oracledb.connect(
        user="COMPRAFACIL",
        password=password,
        dsn="localhost:1521/FREEPDB1"
    )

    cursor = conexion.cursor()

# Consulta el usuario conectado a Oracle.
    cursor.execute("SELECT USER FROM DUAL")
    usuario = cursor.fetchone()[0]
    
# Consulta la cantidad de productos registrados.
    cursor.execute("SELECT COUNT(*) FROM PRODUCTO")
    productos = cursor.fetchone()[0]

# Muestra los resultados de la conexión.
    print("Conexión exitosa con Oracle")
    print("Usuario:", usuario)
    print("Productos registrados:", productos)
    
 # Cierra el cursor y la conexión.
    cursor.close()
    conexion.close()

except oracledb.Error as error:
    print("Error de conexión:", error)
