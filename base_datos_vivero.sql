
-- CREACIÓN DE LAS TABLAS

DO $$ 
BEGIN
   RAISE NOTICE 'CREACIÓN DE LAS TABLAS';
END $$;

CREATE TABLE Vivero (
	NOMBRE_VIVERO VARCHAR(100) PRIMARY KEY NOT NULL,
	LATITUD_VIVERO NUMERIC(10, 7) NOT NULL CHECK (LATITUD_VIVERO BETWEEN -90 AND 90),
	LONGITUD_VIVERO NUMERIC(10, 7) NOT NULL CHECK (LONGITUD_VIVERO BETWEEN -180 AND 180),
	UNIQUE (LATITUD_VIVERO, LONGITUD_VIVERO)
);


CREATE TABLE Zona (
	NOMBRE_VIVERO VARCHAR(100) NOT NULL,
	NOMBRE_ZONA VARCHAR(100) NOT NULL ,
	LATITUD_ZONA NUMERIC(10, 7) NOT NULL CHECK (LATITUD_ZONA BETWEEN -90 AND 90),
	LONGITUD_ZONA NUMERIC(10, 7) NOT NULL CHECK (LONGITUD_ZONA BETWEEN -180 AND 180),
	PRIMARY KEY (NOMBRE_VIVERO, NOMBRE_ZONA),
	FOREIGN KEY (NOMBRE_VIVERO) REFERENCES Vivero(NOMBRE_VIVERO)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE,
	CHECK (NOMBRE_VIVERO <> NOMBRE_ZONA)
);


CREATE TABLE ClientesPlus (
	DNI CHAR(9) PRIMARY KEY NOT NULL,
	NOMBRE VARCHAR(100) NOT NULL,
	FECHA_INGRESO DATE NOT NULL CHECK (FECHA_INGRESO <= CURRENT_DATE),
	BONIFICACION NUMERIC(3, 2) NOT NULL DEFAULT 0 CHECK (BONIFICACION >= 0)
);


CREATE TABLE Empleado (
	IDENTIFICACION INTEGER PRIMARY KEY NOT NULL CHECK (IDENTIFICACION >= 0 AND IDENTIFICACION <= 999999),
	NOMBRE VARCHAR(100) NOT NULL
);



CREATE TABLE Productos (
	NOMBRE_PRODUCTO VARCHAR(100) PRIMARY KEY NOT NULL,
	CANTIDAD INTEGER NOT NULL CHECK (Cantidad >= 0)
);


CREATE TABLE Pedido (
	NUMERO_PEDIDO INTEGER PRIMARY KEY NOT NULL,
	FECHA DATE NOT NULL CHECK (FECHA <= CURRENT_DATE),
	CANTIDAD INTEGER NOT NULL CHECK (CANTIDAD > 0),
	DNI CHAR(9) NULL,
	IDENTIFICACION INTEGER NULL,
	FOREIGN KEY (DNI) REFERENCES ClientesPlus(DNI)
    	ON DELETE SET NULL
    	ON UPDATE CASCADE,
	FOREIGN KEY (IDENTIFICACION) REFERENCES Empleado(IDENTIFICACION)
    	ON DELETE SET NULL
);

CREATE TABLE Empleado_Trabaja_Zona (
	NOMBRE_VIVERO VARCHAR(100) NOT NULL,
	NOMBRE_ZONA VARCHAR(100) NOT NULL,
	IDENTIFICACION INTEGER NOT NULL,
	EPOCA_AÑO VARCHAR(10) NOT NULL CHECK (EPOCA_AÑO IN ('Primavera', 'Verano', 'Otoño', 'Invierno')),
	PRIMARY KEY (NOMBRE_VIVERO, NOMBRE_ZONA, IDENTIFICACION),
	FOREIGN KEY (NOMBRE_VIVERO, NOMBRE_ZONA) REFERENCES Zona(NOMBRE_VIVERO, NOMBRE_ZONA)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE,
	FOREIGN KEY (IDENTIFICACION) REFERENCES Empleado(IDENTIFICACION)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE,
	UNIQUE (EPOCA_AÑO, NOMBRE_ZONA)
);

CREATE TABLE Zona_Produce_Productos (
	NOMBRE_VIVERO VARCHAR(100) NOT NULL,
	NOMBRE_ZONA VARCHAR(100) NOT NULL,
	NOMBRE_PRODUCTO VARCHAR(100) NOT NULL,
	PRIMARY KEY (NOMBRE_VIVERO, NOMBRE_ZONA, NOMBRE_PRODUCTO),
	FOREIGN KEY (NOMBRE_VIVERO, NOMBRE_ZONA) REFERENCES Zona(NOMBRE_VIVERO, NOMBRE_ZONA)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE,
	FOREIGN KEY (NOMBRE_PRODUCTO) REFERENCES Productos(NOMBRE_PRODUCTO)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE
);

CREATE TABLE Pedido_Contiene_Productos (
	NUMERO_PEDIDO INTEGER NOT NULL,
	NOMBRE_PRODUCTO VARCHAR(100) NOT NULL,
	PRIMARY KEY (NUMERO_PEDIDO, NOMBRE_PRODUCTO),
	FOREIGN KEY (NUMERO_PEDIDO) REFERENCES Pedido(NUMERO_PEDIDO)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE,
	FOREIGN KEY (NOMBRE_PRODUCTO) REFERENCES Productos(NOMBRE_PRODUCTO)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE
);


-- DISPARADORES

DO $$
BEGIN
   RAISE NOTICE 'CREACIÓN DE LOS DISPARADORES';
END $$;

CREATE OR REPLACE FUNCTION update_bonificacion() RETURNS TRIGGER AS $$
BEGIN
	UPDATE ClientesPlus
	SET BONIFICACION = LEAST((
    	SELECT COALESCE(SUM(p.CANTIDAD), 0) * 0.01
    	FROM Pedido p
    	WHERE p.DNI = NEW.DNI
    	AND date_trunc('month', p.FECHA) = date_trunc('month', CURRENT_DATE)
	), 1.0)
	WHERE DNI = NEW.DNI;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_bonificacion_trigger
AFTER INSERT OR UPDATE ON Pedido
FOR EACH ROW
EXECUTE FUNCTION update_bonificacion();


CREATE OR REPLACE FUNCTION enforce_default_bonificacion() RETURNS TRIGGER AS $$
BEGIN
	NEW.BONIFICACION := 0;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER enforce_default_bonificacion_trigger
BEFORE INSERT ON ClientesPlus
FOR EACH ROW
EXECUTE FUNCTION enforce_default_bonificacion();

CREATE OR REPLACE FUNCTION check_fecha_pedido() RETURNS TRIGGER AS $$
BEGIN
	IF NEW.FECHA < (SELECT FECHA_INGRESO FROM ClientesPlus WHERE ClientesPlus.DNI = NEW.DNI) THEN
    	RAISE EXCEPTION 'Fecha de pedido no puede ser menor que la fecha de ingreso del cliente';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_fecha_pedido_trigger
BEFORE INSERT OR UPDATE ON Pedido
FOR EACH ROW
EXECUTE FUNCTION check_fecha_pedido();


-- INSERCIONES CORRECTAS EN LAS TABLAS

DO $$
BEGIN
   RAISE NOTICE 'INSERCIONES CORRECTA EN LAS TABLAS';
END $$;

INSERT INTO Vivero (NOMBRE_VIVERO, LATITUD_VIVERO, LONGITUD_VIVERO) VALUES
('La Orotava', 28.3905, -16.5231),
('Santa Cruz', 28.4682, -16.2546),
('Adeje', 28.1227, -16.726),
('Puerto de la Cruz', 28.4142, -16.5448),
('La Laguna', 28.4874, -16.3159);

INSERT INTO Zona (NOMBRE_VIVERO, NOMBRE_ZONA, LATITUD_ZONA, LONGITUD_ZONA) VALUES
('La Orotava', 'Zona Norte', 28.3910, -16.5220),
('Santa Cruz', 'Zona Este', 28.4690, -16.2530),
('Adeje', 'Zona Sur', 28.1230, -16.7250),
('Puerto de la Cruz', 'Zona Oeste', 28.4150, -16.5430),
('La Laguna', 'Zona Central', 28.4880, -16.3140),
('La Laguna', 'Patio Exterior', 28.4870, -16.40);

INSERT INTO ClientesPlus (DNI, NOMBRE, FECHA_INGRESO) VALUES
('12345678A', 'Daniel Carvajal', '2024-10-15'),
('87654321B', 'Aday Cuesta', '2024-10-25'),
('11223344C', 'Daniel Azañón', '2021-12-01'),
('44332211D', 'Ana Martínez', '2020-03-25'),
('55667788E', 'Luis Fernández', '2023-10-01');

INSERT INTO Empleado (IDENTIFICACION, NOMBRE) VALUES
(123456, 'Manuel Noda'),
(234567, 'Mario Soto'),
(345678, 'David Matías'),
(456789, 'Elena Ruiz'),
(567890, 'Javier Gómez');

INSERT INTO Productos (NOMBRE_PRODUCTO, CANTIDAD) VALUES
('Tierra', 50),
('Semillas de Girasol', 200),
('Maceta', 30),
('Abono', 100),
('Amapolas', 75);

INSERT INTO Pedido (NUMERO_PEDIDO, FECHA, CANTIDAD, DNI, IDENTIFICACION) VALUES
(1, '2022-06-05', 15, '44332211D', 456789),
(2, '2023-07-10', 20, '11223344C', 345678),
(3, '2023-10-02', 8, '55667788E', 567890),
(4, '2024-10-17', 10, '12345678A', 123456),
(5, '2024-10-27', 5, '87654321B', 234567),
(6, '2024-10-28', 3, '12345678A', 123456);

INSERT INTO Empleado_Trabaja_Zona (NOMBRE_VIVERO, NOMBRE_ZONA, IDENTIFICACION, EPOCA_AÑO) VALUES
('La Orotava', 'Zona Norte', 123456, 'Primavera'),
('Santa Cruz', 'Zona Este', 123456, 'Invierno'),
('Santa Cruz', 'Zona Este', 234567, 'Verano'),
('Adeje', 'Zona Sur', 345678, 'Otoño'),
('Puerto de la Cruz', 'Zona Oeste', 456789, 'Invierno'),
('La Laguna', 'Zona Central', 567890, 'Primavera'),
('La Laguna', 'Patio Exterior', 567890, 'Primavera');

INSERT INTO Zona_Produce_Productos (NOMBRE_VIVERO, NOMBRE_ZONA, NOMBRE_PRODUCTO) VALUES
('La Orotava', 'Zona Norte', 'Tierra'),
('Santa Cruz', 'Zona Este', 'Semillas de Girasol'),
('Adeje', 'Zona Sur', 'Abono'),
('Puerto de la Cruz', 'Zona Oeste', 'Maceta'),
('La Laguna', 'Zona Central', 'Amapolas');

INSERT INTO Pedido_Contiene_Productos (NUMERO_PEDIDO, NOMBRE_PRODUCTO) VALUES
(1, 'Tierra'),
(2, 'Semillas de Girasol'),
(3, 'Maceta'),
(4, 'Abono'),
(5, 'Amapolas'),
(6, 'Tierra');

-- Contenido de las tablas

DO $$
BEGIN
   RAISE NOTICE 'CONTENIDO DE LAS TABLAS';
END $$;

SELECT * FROM VIVERO;

SELECT * FROM ZONA;

SELECT * FROM CLIENTESPLUS;

SELECT * FROM PEDIDO;

SELECT * FROM PRODUCTOS;

SELECT * FROM EMPLEADO;

SELECT * FROM EMPLEADO_TRABAJA_ZONA;

SELECT * FROM ZONA_PRODUCE_PRODUCTOS;

SELECT * FROM PEDIDO_CONTIENE_PRODUCTOS;

-- ELIMINACIONES

DO $$
BEGIN
   RAISE NOTICE 'ELIMINACIONES';
END $$;

-- Eliminación de un vivero

DO $$
BEGIN
   RAISE NOTICE 'ELIMINACIÓN DE UN VIVERO';
END $$;

SELECT * FROM ZONA_PRODUCE_PRODUCTOS;

SELECT * FROM EMPLEADO_TRABAJA_ZONA;

SELECT * FROM ZONA;

SELECT * FROM VIVERO;

DELETE FROM VIVERO WHERE NOMBRE_VIVERO = 'Puerto de la Cruz';

SELECT * FROM VIVERO;

SELECT * FROM ZONA;

SELECT * FROM ZONA_PRODUCE_PRODUCTOS;

SELECT * FROM EMPLEADO_TRABAJA_ZONA;

-- Eliminación de un producto

DO $$
BEGIN
   RAISE NOTICE 'ELIMINACIÓN DE UN PRODUCTO';
END $$;

SELECT * FROM PEDIDO_CONTIENE_PRODUCTOS;

SELECT * FROM ZONA_PRODUCE_PRODUCTOS;

SELECT * FROM PRODUCTOS;

DELETE FROM PRODUCTOS WHERE NOMBRE_PRODUCTO = 'Tierra';

SELECT * FROM PRODUCTOS;

SELECT * FROM PEDIDO_CONTIENE_PRODUCTOS;

SELECT * FROM ZONA_PRODUCE_PRODUCTOS;

-- Eliminación de un empleado

DO $$
BEGIN
   RAISE NOTICE 'ELIMINACIÓN DE UN EMPLEADO';
END $$;

SELECT * FROM PEDIDO;

SELECT * FROM EMPLEADO;

DELETE FROM EMPLEADO WHERE IDENTIFICACION = 456789;

SELECT * FROM EMPLEADO;

SELECT * FROM PEDIDO;

SELECT * FROM EMPLEADO_TRABAJA_ZONA;

SELECT * FROM EMPLEADO;

DELETE FROM EMPLEADO WHERE IDENTIFICACION = 123456;

SELECT * FROM EMPLEADO;

SELECT * FROM EMPLEADO_TRABAJA_ZONA;

-- Eliminación de un cliente

DO $$
BEGIN
   RAISE NOTICE 'ELIMINACIÓN DE UN CLIENTE';
END $$;

SELECT * FROM CLIENTESPLUS;

SELECT * FROM PEDIDO;

DELETE FROM CLIENTESPLUS WHERE NOMBRE = 'Ana Martínez';

SELECT * FROM CLIENTESPLUS;

SELECT * FROM PEDIDO;

-- Inserciones erróneas

DO $$
BEGIN
   RAISE NOTICE 'INSERCIONES ERRÓNEAS';
END $$;

-- Viveros:

DO $$
BEGIN
   RAISE NOTICE 'TABLA VIVERO';
END $$;

SELECT * FROM VIVERO;

INSERT INTO VIVERO (NOMBRE_VIVERO, LATITUD_VIVERO, LONGITUD_VIVERO) VALUES ('Adeje', 14.8653, 79.312);

INSERT INTO VIVERO (NOMBRE_VIVERO, LATITUD_VIVERO, LONGITUD_VIVERO) VALUES ('Los Andenes', 28.3905, -16.5231);

INSERT INTO VIVERO (NOMBRE_VIVERO, LATITUD_VIVERO, LONGITUD_VIVERO) VALUES ('Los Andenes', -90.3905, -16.5231);

INSERT INTO VIVERO (NOMBRE_VIVERO, LATITUD_VIVERO, LONGITUD_VIVERO) VALUES ('Los Andenes', 28.3905, -180.5231);

-- Zona:

DO $$
BEGIN
   RAISE NOTICE 'TABLA ZONA';
END $$;

SELECT * FROM ZONA;

INSERT INTO ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, LATITUD_ZONA, LONGITUD_ZONA) VALUES ('La Orotava', 'Zona Norte', 28.15, 15);

INSERT INTO ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, LATITUD_ZONA, LONGITUD_ZONA) VALUES ('La Orotava', 'Zona Sur', -90.15, 15);

INSERT INTO ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, LATITUD_ZONA, LONGITUD_ZONA) VALUES ('La Orotava', 'Zona Sur', 90,
 -180.1);

INSERT INTO ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, LATITUD_ZONA, LONGITUD_ZONA) VALUES ('La Orotava', 'Zona Sur', 28.3910000, -16.5220000);

INSERT INTO ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, LATITUD_ZONA, LONGITUD_ZONA) VALUES ('Las Galletas', 'Zona Norte',
 28.15, 15);

-- ClientesPlus:

DO $$
BEGIN
   RAISE NOTICE 'TABLA CLIENTESPLUS';
END $$;

SELECT * FROM CLIENTESPLUS;

INSERT INTO CLIENTESPLUS (DNI, NOMBRE, FECHA_INGRESO) VALUES ('11223344C', 'Juan', '2021-12-01');

INSERT INTO CLIENTESPLUS (DNI, NOMBRE, FECHA_INGRESO) VALUES ('11223344D', 'Juan', '2025-01-01');

INSERT INTO CLIENTESPLUS (DNI, NOMBRE, FECHA_INGRESO, BONIFICACION) VALUES ('11223344D', 'Juan', '2021-12-01', -
1);

SELECT * FROM CLIENTESPLUS;

-- Pedido:

DO $$
BEGIN
   RAISE NOTICE 'TABLA PEDIDO';
END $$;

INSERT INTO PEDIDO (NUMERO_PEDIDO, FECHA, CANTIDAD, DNI, IDENTIFICACION) VALUES (2, '2023-07-05', 17, '11223344D
', 345678);

INSERT INTO PEDIDO (NUMERO_PEDIDO, FECHA, CANTIDAD, DNI, IDENTIFICACION) VALUES (7, '2025-07-05', 17, '11223344D
', 345678);

INSERT INTO PEDIDO (NUMERO_PEDIDO, FECHA) VALUES (7, '2023-07-05');

INSERT INTO PEDIDO (NUMERO_PEDIDO, FECHA, CANTIDAD, DNI, IDENTIFICACION) VALUES (7, '2023-07-05', 17, '11223344Z', 345678);

INSERT INTO PEDIDO (NUMERO_PEDIDO, FECHA, CANTIDAD, DNI, IDENTIFICACION) VALUES (7, '2023-07-05', 17, '11223344D', 11111);

-- Productos:

DO $$
BEGIN
   RAISE NOTICE 'TABLA PRODUCTOS';
END $$;

INSERT INTO PRODUCTOS (NOMBRE_PRODUCTO, CANTIDAD) VALUES ('Maceta', 15);

INSERT INTO PRODUCTOS (NOMBRE_PRODUCTO) VALUES ('Maiz');

-- Empleado:

DO $$
BEGIN
   RAISE NOTICE 'TABLA EMPLEADO';
END $$;

SELECT * FROM EMPLEADO;

INSERT INTO EMPLEADO (IDENTIFICACION, NOMBRE) VALUES (234567, 'Antonio');
INSERT INTO EMPLEADO (IDENTIFICACION, NOMBRE) VALUES (1000000, 'Antonio');

-- Empleado_Trabaja_Zona:

DO $$
BEGIN
   RAISE NOTICE 'TABLA EMPLEADO_TRABAJA_ZONA';
END $$;

SELECT * FROM EMPLEADO_TRABAJA_ZONA;

INSERT INTO EMPLEADO_TRABAJA_ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, IDENTIFICACION, EPOCA_AÑO) VALUES ('Santa Cruz', 'Zona Este', 234567, 'Invierno');

INSERT INTO EMPLEADO_TRABAJA_ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, IDENTIFICACION, EPOCA_AÑO) VALUES ('Las Chafiras', 'Zona Este', 234567, 'In
vierno');

INSERT INTO EMPLEADO_TRABAJA_ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, IDENTIFICACION, EPOCA_AÑO) VALUES ('Santa Cruz', 'Zona Este', 1111, 'Invier
no');

INSERT INTO EMPLEADO_TRABAJA_ZONA (NOMBRE_VIVERO, NOMBRE_ZONA, IDENTIFICACION, EPOCA_AÑO) VALUES ('Santa Cruz', 'Zona Este', 567890, 'Inviersi');

-- Zona_Produce_Productos:

DO $$
BEGIN
   RAISE NOTICE 'TABLA ZONA_PRODUCE_PRODUCTOS';
END $$;

SELECT * FROM ZONA_PRODUCE_PRODUCTOS;

INSERT INTO ZONA_PRODUCE_PRODUCTOS (NOMBRE_VIVERO, NOMBRE_ZONA, NOMBRE_PRODUCTO) VALUES ('Adeje', 'Zona Sur', 'Abono');

INSERT INTO ZONA_PRODUCE_PRODUCTOS (NOMBRE_VIVERO, NOMBRE_ZONA, NOMBRE_PRODUCTO) VALUES ('Adeje', 'Zona Norte', 'Abono');

INSERT INTO ZONA_PRODUCE_PRODUCTOS (NOMBRE_VIVERO, NOMBRE_ZONA, NOMBRE_PRODUCTO) VALUES ('Las Galletas', 'Zona Norte', 'Abono');

INSERT INTO ZONA_PRODUCE_PRODUCTOS (NOMBRE_VIVERO, NOMBRE_ZONA, NOMBRE_PRODUCTO) VALUES ('Adeje', 'Zona Sur', 'Claveles');

-- Pedido_Contiene_Productos:

DO $$
BEGIN
   RAISE NOTICE 'TABLA PEDIDO_CONTIENE_PRODUCTOS';
END $$;

SELECT * FROM PEDIDO_CONTIENE_PRODUCTOS;

INSERT INTO PEDIDO_CONTIENE_PRODUCTOS (NUMERO_PEDIDO, NOMBRE_PRODUCTO) VALUES (4, 'Abono');

INSERT INTO PEDIDO_CONTIENE_PRODUCTOS (NUMERO_PEDIDO, NOMBRE_PRODUCTO) VALUES (15, 'Abono');

INSERT INTO PEDIDO_CONTIENE_PRODUCTOS (NUMERO_PEDIDO, NOMBRE_PRODUCTO) VALUES (2, 'Girasol');
