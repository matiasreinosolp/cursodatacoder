-- ══════════════════════════════════════════
-- RetailPro — Consultas con JOINs para el proyecto
-- Título: Cruzando tablas para enriquecer el análisis
-- Entregable M5
-- ══════════════════════════════════════════

-- ── CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN) ────────────────────
-- Pregunta de negocio: Vista única enriquecida para Power BI.
-- Combina ventas, clientes, productos y categorías.
-- Nota: Como no hay una tabla explícita de "territorios", usamos "ciudad" de clientes.

SELECT 
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    -- c.ciudad AS region, -- Opcional: puedes mapear la ciudad como región/ubicación
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c   ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p  ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria;


-- ── CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN) ────────────────────────
-- Pregunta de negocio (CRM): ¿Qué clientes registrados aún no compraron?
-- Aísla los casos usando WHERE ... IS NULL.

SELECT 
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;


-- ── CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN) ───────────────────────
-- Pregunta de negocio (Producto): ¿Qué artículos del catálogo no tienen movimiento?
-- Aísla los casos usando WHERE ... IS NULL.

SELECT 
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v        ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;


-- ── CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL + GROUP BY) ───────────
-- Pregunta de negocio: Usar UNION ALL para simular la combinación de canales 
-- (Online vs Presencial) basándonos en la estructura unificada de ventas.

SELECT 
    resultado_consolidado.canal,
    SUM(resultado_consolidado.total_venta) AS total_facturado
FROM (
    -- Simulación de Canal Online (por ejemplo, ventas con IDs pares o un criterio de negocio)
    SELECT 
        id_venta,
        (cantidad * precio_unitario) AS total_venta,
        'Online' AS canal
    FROM ventas
    WHERE id_venta % 2 = 0 -- Reemplazar por tu columna/filtro real de canal si existiera
    
    UNION ALL
    
    -- Simulación de Canal Presencial
    SELECT 
        id_venta,
        (cantidad * precio_unitario) AS total_venta,
        'Presencial' AS canal
    FROM ventas
    WHERE id_venta % 2 <> 0
) AS resultado_consolidado
GROUP BY resultado_consolidado.canal;
