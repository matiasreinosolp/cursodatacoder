1. Comparación de Resultados (Filas Devueltas)
Al ejecutar las consultas de comparación de resultados obtenemos lo siguiente:

filas_union: Devuelve 11 filas.

filas_union_all: Devuelve 14 filas.

¿Por qué son distintas?
La diferencia radica en cómo procesa cada operador los registros duplicados entre ambas tablas.

UNION ALL simplemente unifica ("pega") todos los registros de ambas tablas tal como vienen. Como la sucursal Norte tiene 7 registros y la sucursal Sur tiene 7 registros, el resultado es la suma exacta de ambos: 14 filas.

UNION unifica las tablas pero realiza un proceso de desduplicación, eliminando filas que sean completamente idénticas en todas las columnas seleccionadas.

Ejemplo concreto de datos eliminados con UNION:
En la consulta de UNION seleccionamos únicamente las columnas id_producto, nombre_producto y categoria. Al omitir la columna stock, el motor de base de datos detecta que los siguientes registros de la sucursal Sur son exactamente iguales a los del Norte y los elimina del resultado final para no duplicarlos:

Monitor 4K 27" (103, 'Monitor 4K 27"', 'Computación')

Teclado Mecánico (104, 'Teclado Mecánico', 'Accesorios')

SSD Externo 1TB (106, 'SSD Externo 1TB', 'Almacenamiento')

Webcam HD 1080p (107 en Norte y 111 en Sur tienen el mismo nombre y categoría, pero al tener IDs distintos no se eliminan; en cambio, el producto 107 / 'Webcam HD 1080p' / 'Accesorios' sí se consolida si se repitiera el ID exacto).

Por esta depuración de duplicados, el resultado se reduce de 14 a 11 filas.

2. Eficiencia y Rendimiento: UNION ALL vs UNION
UNION ALL es significativamente más eficiente que UNION.

¿Por qué?
Para poder eliminar los registros duplicados, UNION no puede simplemente concatenar los datos; internamente el motor de base de datos debe realizar una operación adicional de ordenamiento y comparación (un proceso de Sort o de Hashing).

El motor junta ambas fuentes de datos.

Ordena temporalmente todo el conjunto de resultados para agrupar las filas que son idénticas.

Escanea el conjunto ordenado para eliminar los duplicados (Distinct Scan).

Esta operación de ordenamiento y desduplicación consume CPU y memoria RAM (o incluso espacio en disco si el volumen de datos es gigantesco). En cambio, UNION ALL no realiza ninguna validación de duplicados; toma los datos de la primera consulta, los de la segunda y los entrega directamente en un solo flujo, consumiendo muchísimos menos recursos.

3. Casos de Uso en el Mundo Real
Cuándo usar UNION ALL (Eficiencia y Preservación de Datos)
Se utiliza cuando sabemos de antemano que los datos no se duplican, o cuando los duplicados son válidos y necesarios para el negocio.

Caso 1: Consolidación de Transacciones Históricas. Si queremos juntar la tabla de ventas_2025 y ventas_2026 para calcular el total de ingresos. Al ser períodos distintos, no hay riesgo de registros duplicados idénticos y necesitamos que cada transacción se sume individualmente. Usar UNION aquí sería un desperdicio enorme de recursos.

Caso 2: Reporte de Auditoría de Movimientos.
Si queremos ver todos los depósitos y retiros que hizo un usuario en su cuenta bancaria desde dos tablas distintas (depositos y extracciones). Necesitamos ver absolutamente cada fila (aunque haya dos depósitos idénticos de $10.000 el mismo día), por lo que consolidar con UNION ALL es lo correcto.

Cuándo usar UNION (Garantía de Unicidad)
Se utiliza cuando requerimos un listado limpio, consolidado y sin redundancias visuales o lógicas para el usuario final.

Caso 1: Directorio Unificado de Contactos.
Si queremos armar una lista de distribución para una campaña de email marketing extrayendo correos de la tabla clientes y de la tabla proveedores. Si una persona es cliente y proveedor a la vez, no queremos enviarle el correo dos veces, por lo que UNION nos asegura obtener una lista de correos electrónicos únicos.

Caso 2: Catálogo Global de Atributos.
Al consolidar categorías de productos de múltiples plataformas de e-commerce adquiridas por un holding. Queremos saber qué categorías existen en todo el ecosistema de aplicaciones sin importar de qué plataforma vengan, presentándole al usuario una lista limpia y sin repetir como "Tecnología", "Hogar", etc.

4. Incompatibilidad de Columnas y Errores en SQL
Para que un operador UNION o UNION ALL funcione, se deben cumplir estrictamente dos reglas:

Ambas consultas deben tener el mismo número de columnas.

Las columnas correspondientes deben tener tipos de datos compatibles (o convertibles implícitamente por el motor).

¿Qué pasa si no coinciden?
Si intentamos ejecutar la unión de consultas con diferente número de columnas o tipos incompatibles, el motor de base de datos detendrá la ejecución de inmediato.

Error por diferente número de columnas:
Si la primera consulta tiene 3 columnas y la segunda tiene 4, SQL Server o MySQL devolverán un error como:

Error: Each UNION query must have the same number of columns. (o The used SELECT statements have a different number of columns en MySQL).

Error por tipos de datos incompatibles:
Si la primera columna de la Consulta A es un INT (un ID) y la primera columna de la Consulta B es un VARCHAR (un texto), el motor intentará convertirlos. Si no puede hacer una conversión implícita segura, arrojará un error de conversión:

Error: Conversion failed when converting the varchar value 'Laptop' to data type int. (en SQL Server) o fallará por incompatibilidad de tipos en bases de datos más estrictas como PostgreSQL.
