# SQL Optimization Scripts

Este repositorio contiene un conjunto de scripts SQL avanzados diseñados para optimizar la gestión de bases de datos empresariales, mejorar la eficiencia en consultas y automatizar procesos comunes relacionados con recursos humanos, ventas, geolocalización y más.

## Características principales

- **Optimización de consultas**: Uso de índices y consultas avanzadas para mejorar el rendimiento.
- **Manejo de empleados**: Tablas y procedimientos almacenados para gestionar empleados y sus datos.
- **Ventas y reportes**: Generación de reportes detallados sobre ventas y rendimiento de empleados.
- **Asistencias y horarios**: Registro de entrada y salida con cálculo automático de horas trabajadas.
- **Geolocalización**: Almacenamiento y consulta de ubicaciones de empleados en tiempo real.
- **Procedimientos almacenados y triggers**: Automatización de procesos para mejorar la eficiencia.

## Tablas incluidas

- `employees`: Información de empleados.
- `sales`: Registro de ventas por empleado.
- `attendance`: Control de asistencias y cálculo de horas trabajadas.
- `employee_locations`: Geolocalización de empleados.

## Consultas y procedimientos avanzados

- **Búsqueda optimizada de empleados** (`SearchEmployees`)
- **Reporte de ventas por fecha** (`GetSalesByDateRange`)
- **Consulta de asistencias por empleado** (`GetEmployeeAttendance`)
- **Cálculo de antigüedad de empleados** (`EmployeeTenure`)
- **Obtención de la última ubicación de un empleado** (`GetLastEmployeeLocation`)

## Uso

1. Clona el repositorio:
   ```sh
   git clone https://github.com/tuusuario/sql-optimization-scripts.git
   ```
2. Importa el archivo SQL en tu base de datos.
3. Ejecuta las consultas y procedimientos almacenados según tus necesidades.

## Contribuciones

Las contribuciones son bienvenidas. Puedes hacer un fork del repositorio, mejorar los scripts y enviar un pull request.

## Licencia

Este proyecto no está bajo licencia. Puedes usarlo y modificarlo libremente.

