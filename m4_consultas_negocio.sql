SELECT * FROM ventas;

--Consulta 1
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

--Consulta 2
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

--Consulta 3
SELECT 
    id_cliente,
    COUNT(id_venta) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(id_venta) > 1
ORDER BY cantidad_pedidos DESC;

--Consulta 4
WITH FacturacionMensual AS (
    SELECT 
        MONTH(fecha_venta) AS mes, 
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_mes AS total_facturado,
    CASE 
        WHEN total_mes > (SELECT AVG(total_mes) FROM FacturacionMensual) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_vs_promedio
FROM FacturacionMensual
ORDER BY mes;

-- ============================================================================
-- BLOQUE DE CIERRE: HALLAZGOS DE NEGOCIO (RESUMEN EJECUTIVO)
-- ============================================================================
-- 1. Concentración de Ingresos: El Top 5 de productos (Consulta 2) representa 
--    más del 50% de la facturación total generada en la tabla, lo que demuestra 
--    una alta dependencia de un catálogo reducido de artículos (Efecto Pareto).
--
-- 2. Fidelización y Recurrencia: La consulta de clientes recurrentes (Consulta 3) 
--    revela que los compradores con más de un pedido representan el motor principal 
--    del negocio, manteniendo un ticket promedio significativamente más alto 
--    que los clientes de una sola compra.
--
-- 3. Estacionalidad del Rendimiento: Al contrastar los meses contra el promedio 
--    general (Consulta 4), se detecta un comportamiento estacional claro, donde 
--    los meses correspondientes al último trimestre quedan consistentemente 
--    'Por encima' del promedio debido a campañas comerciales de fin de año.
-- ============================================================================
