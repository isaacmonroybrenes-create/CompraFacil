
import oracledb
import getpass

print("=== PRUEBA DE PROCEDIMIENTOS COMPRAFÁCIL ===")

password = getpass.getpass("Contraseña de Oracle: ")

try:
    with oracledb.connect(
        user="COMPRAFACIL",
        password=password,
        dsn="localhost:1521/FREEPDB1"
    ) as conexion:

        with conexion.cursor() as cursor:
            resultado = cursor.var(oracledb.DB_TYPE_CURSOR)

            cursor.callproc(
                "SP_CATEGORIA_LISTAR",
                [resultado]
            )

            with resultado.getvalue() as registros:
                categorias = registros.fetchall()

            print("Procedimiento ejecutado correctamente")
            print("Categorías registradas:")

            for categoria in categorias:
                print(categoria)

except oracledb.Error as error:
    print("Error de Oracle:", error)