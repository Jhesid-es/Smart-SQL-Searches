-- Crea una tabla de empleados con índices optimizados
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    last_promotion DATE
);

-- Índice compuesto para acelerar búsquedas por nombre y departamento
CREATE INDEX idx_employees_name_department 
ON employees (name, department);

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    product VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de asistencias en Recursos Humanos
CREATE TABLE IF NOT EXISTS attendance (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    check_in TIMESTAMP NOT NULL,
    check_out TIMESTAMP,
    worked_hours DECIMAL(5,2) GENERATED ALWAYS AS (TIMESTAMPDIFF(HOUR, check_in, check_out)) STORED
);

-- Tabla de geolocalización de empleados
CREATE TABLE IF NOT EXISTS employee_locations (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(id),
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    location_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Procedimiento almacenado para búsqueda optimizada
DELIMITER $$
CREATE PROCEDURE SearchEmployees (
    IN search_name VARCHAR(100),
    IN search_department VARCHAR(50)
)
BEGIN
    SELECT * FROM employees
    WHERE name LIKE CONCAT('%', search_name, '%')
    AND department LIKE CONCAT('%', search_department, '%');
END $$
DELIMITER ;

-- Consulta optimizada con paginación
SELECT * FROM employees
WHERE department = 'IT'
ORDER BY hire_date DESC
LIMIT 10 OFFSET 0;

-- Vista para agilizar reportes de salarios
CREATE VIEW employee_salaries AS
SELECT department, AVG(salary) AS avg_salary, COUNT(*) AS employee_count
FROM employees
GROUP BY department;

-- Vista para reportes de ventas por empleado
CREATE VIEW sales_summary AS
SELECT employee_id, SUM(amount) AS total_sales, COUNT(*) AS total_transactions
FROM sales
GROUP BY employee_id;

-- Búsqueda con índice full-text (para bases de datos como MySQL)
ALTER TABLE employees ADD FULLTEXT(name, department);

SELECT * FROM employees WHERE MATCH(name, department) AGAINST ('developer' IN NATURAL LANGUAGE MODE);

-- Trigger para actualizar la última promoción cuando se actualiza el salario
DELIMITER $$
CREATE TRIGGER update_last_promotion
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary > OLD.salary THEN
        SET NEW.last_promotion = CURDATE();
    END IF;
END $$
DELIMITER ;

-- Procedimiento almacenado avanzado para obtener empleados con salario superior al promedio de su departamento
DELIMITER $$
CREATE PROCEDURE HighEarningEmployees()
BEGIN
    SELECT e.* FROM employees e
    JOIN (
        SELECT department, AVG(salary) AS avg_salary
        FROM employees
        GROUP BY department
    ) dept_avg ON e.department = dept_avg.department
    WHERE e.salary > dept_avg.avg_salary;
END $$
DELIMITER ;

-- Función para calcular la antigüedad en años de un empleado
DELIMITER $$
CREATE FUNCTION EmployeeTenure(hire_date DATE) RETURNS INT DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, hire_date, CURDATE());
END $$
DELIMITER ;

-- Procedimiento almacenado para obtener asistencias por empleado
DELIMITER $$
CREATE PROCEDURE GetEmployeeAttendance(IN emp_id INT)
BEGIN
    SELECT * FROM attendance WHERE employee_id = emp_id ORDER BY check_in DESC;
END $$
DELIMITER ;

-- Procedimiento almacenado para obtener ventas en un rango de fechas
DELIMITER $$
CREATE PROCEDURE GetSalesByDateRange(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT * FROM sales WHERE sale_date BETWEEN start_date AND end_date;
END $$
DELIMITER ;

-- Procedimiento para obtener la última ubicación de un empleado
DELIMITER $$
CREATE PROCEDURE GetLastEmployeeLocation(IN emp_id INT)
BEGIN
    SELECT * FROM employee_locations WHERE employee_id = emp_id ORDER BY location_time DESC LIMIT 1;
END $$
DELIMITER ;
