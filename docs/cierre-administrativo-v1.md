# Cierre administrativo · prueba V1

Sección exclusiva de la vista "Administrador" (NIP) de VerDvida Manager.

## Ingreso de datos
- Seleccionar fecha en horario America/Mexico_City.
- Ingresar efectivo, transferencias y tarjeta/Mercado Pago, incluso si son 0.
- Añadir gastos: concepto, importe y si pagó caja o un tercero; si pagó un tercero registrar el nombre.
- Guardar. El cierre se almacena por (owner_id, day), así que editar una fecha no crea otro cierre.
- El total de venta es la suma de los tres medios. El gasto total incluye tanto caja como terceros, pero se desglosan aparte.
- Comparación con el POS: se muestra un total informativo desde verdvida_sales; jamás se insertan esas ventas de nuevo.
- No se modifica el módulo "Caja" ni los tickets ya existentes.

## Antes de desplegar
1. Revisar el PR y hacer una copia de respaldo del repositorio y de los datos.
2. Aplicar la migración de `supabase/migrations/20261120_admin_daily_closings.sql` en una base de pruebas o en el proyecto cuando se autorice; no está aplicada por este PR.
3. Verificar permisos RLS (usuario propietario puede leer/insertar/actualizar solo filas propias; anon no puede; otro propietario tampoco).
4. Abrir la rama en entorno de prueba; ingresar con NIP administrador y conexión Supabase del propietario.
5. Probar fecha sin cierre, registrar uno, recargar, corregirlo y comprobar que sigue habiendo una fila por fecha.
6. Probar desconexión, importes inválidos, gasto de tercero y error de escritura.
7. Revisar seguridad: la separación entre NIP admin/cajero es hoy una **regla de interfaz**, pues la tablet enlazada usa la sesión Supabase del propietario. Una política RLS por `owner_id` limita por propietario, **no** por NIP. Para aislamiento real entre colaboradores y administrador será necesario diferenciar usuarios autenticados o reforzar el backend.

## Límites V1
No calcula utilidad neta ni punto de equilibrio. El cierre es **manual** hasta que el equipo use el POS. Los registros históricos de papel se capturarán con revisión, no automáticamente. No se guardan cierres sin confirmación exitosa del servidor. La suma de compras no representa consumo de inventario.
