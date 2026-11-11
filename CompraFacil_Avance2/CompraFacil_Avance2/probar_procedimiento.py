
import oracledb
import getpass

# Prueba de ejecución de procedimientos almacenados en CompraFácil.
print("=== PRUEBA DE PROCEDIMIENTOS COMPRAFÁCIL ===")
# Solicita la contraseña de Oracle sin mostrarla en pantalla.
password = getpass.getpass("Contraseña de Oracle: ")

try:
 # Establece la conexión con la base de datos Oracle.
    with oracledb.connect(
        user="COMPRAFACIL",
        password=password,
        dsn="localhost:1521/FREEPDB1"
    ) as conexion:
        
# Crea un cursor para ejecutar el procedimiento.
        with conexion.cursor() as cursor:
            
            # Define una variable para recibir los resultados.
            resultado = cursor.var(oracledb.DB_TYPE_CURSOR)

            # Ejecuta el procedimiento para listar las categorías.
            cursor.callproc(
                "SP_CATEGORIA_LISTAR",
                [resultado]
            )

             # Obtiene los registros devueltos por el procedimiento.
            with resultado.getvalue() as registros:
                categorias = registros.fetchall()

            # Muestra las categorías registradas en Oracle.
            print("Procedimiento ejecutado correctamente")
            print("Categorías registradas:")

            for categoria in categorias:
                print(categoria)

except oracledb.Error as error:
 # Muestra los errores relacionados con la ejecución en Oracle.
    print("Error de Oracle:", error)
