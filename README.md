# P03_ADBD - Modelo relacional. Viveros
## Aday Cuesta Correa y Manuel José Sebastián Noda

Hemos realizado bastantes cambios respecto a nuestro modelo entidad/relacion de la práctica anterior así que vemos necesario explicar aquí como funciona este nuevo modelo:

## Descripción de cada una de las entidades definidas y sus atributos.
**Vivero**
- Descripción: Representa un vivero donde se cultivan y gestionan productos agrícolas. Posee el atributo compuesto de Georreferenciación
vivero.
- Atributos:
  - Nombre Vivero: Nombre identificativo del vivero.
    - Ejemplo: "La Laguna"
  - Latitud Vivero: Coordenada de latitud para la geolocalización del vivero.
    - Ejemplo: -34.6037
  - Longitud Vivero: Coordenada de longitud para la geolocalización del vivero.
    - Ejemplo: -58.3816

**Zona**
- Descripción: Áreas dentro del vivero dedicadas a diferentes tipos de cultivos o procesos de producción. Posee el atributo compuesto de Georreferenciación zona. Es una entidad débil.
- Atributos:
  - Nombre Zona: Nombre que identifica a la zona dentro del vivero.
    - Ejemplo: "Patio Exterior"
  - Latitud Zona: Coordenada de latitud para geolocalizar la zona dentro del vivero.
    - Ejemplo: -34.6050
  - Longitud Zona: Coordenada de longitud para geolocalizar la zona dentro del vivero.
    - Ejemplo: -58.3840
   
**Producto**
- Descripción: Elementos cultivados o producidos dentro de cada zona del vivero.
- Atributos:
  - Nombre Producto: Nombre del producto cultivado en el vivero.
    - Ejemplo: "Rosas"
  - Cantidad: Número de unidades disponibles del producto.
    - Ejemplo: 200 (indica 200 unidades de rosas)

**Pedido**
- Descripción: Registro de pedidos realizados para adquirir productos del vivero.
- Atributos:
  - Número Pedido: Identificador único del pedido.
    - Ejemplo: 15
  - Fecha: Fecha en la que se realizó el pedido.
    - Ejemplo: 2023-10-15

**Empleado**
- Descripción: Personal que trabaja en las zonas del vivero, según la época del año puede trabajar en otro vivero.
- Atributos:
  - Identificación: Identificador único del empleado.
    - Ejemplo: 31254
  - Nombre: Nombre del empleado.
    - Ejemplo: "Manuel Noda"
   
**Cliente Plus**
- Descripción: Clientes que tienen una membresía premium y pueden recibir bonificaciones.
- Atributos:
  - DNI: Documento Nacional de Identidad del cliente.
    - Ejemplo: 12345678A
  - Nombre: Nombre del cliente.
    - Ejemplo: "Daniel Carvajal"
  - Fecha de Ingreso: Fecha en que el cliente se registró como cliente plus.
    - Ejemplo: 2022-05-20
  - Bonificación: Porcentaje de descuento aplicable por ser cliente plus, es un **atributo calculado**.
    - Ejemplo: 1.0 (Qué es lo mismo que decir 100%)
   
## Descripción de cada una de las relaciones definidas
**Tiene**
- Descripción: Relaciona al vivero con la zona, de tal manera que un vivero posee 1 o más zonas (1:N) y una zona pertenece solo a un vivero (1:1)

**Producen**
- Descripción: Relaciona la zona con los productos, de tal forma que la zona crea 1 o más productos (1:N) y los productos son creados en las zonas (1:N)

**Trabaja**
- Descripción: Relaciona la zona con el empleado, además de poseer el atributo **Época del año** con el que limita al empleado a trabajar en un vivero a la vez dependiendo de la época (Primavera, Verano, Otoño, Invierno). En una zona trabajan 1 o más empleados (1:N) y en las zonas trabajan 1 o más empleados (1:N)

**Contiene**
- Descripción: Relaciona los productos con los pedidos, puede ser que en un pedido haya 0 o más cantidades de un producto (0:N), y un pedido contiene 1 o más productos (1:N)

**Realiza**
- Descripción: Relaciona los pedidos con los clientes, de tal manera que un pedido solo pertenece a un cliente (1:1) y un cliente puede haber realizado 0 o más pedidos (0:N)

**Gestión**
- Descripción: Relaciona al empleado con el pedido, de tal manera que un empleado puede haber gestionado 0 o más pedidos (0:N) y un pedido es gestionado por un solo empleado (1:1)

## Imagen del modelo E/R
![modelo_er](https://github.com/AdayCuestaCorrea/P03_ADBD/blob/main/Modelo_ER/DiagramaER_Viveros_2.png)

## Modelo Relaciona
En cuanto al modelo relacional, hemos convertido el modelo Entidad/Relación paso a paso y hemos conseguido lo siguiente:

**Vivero**
- **Nombre_Vivero**: 
  - PRIMARY KEY
  - NOT NULL
  - VARCHAR(100)
- **Latitud_Vivero**: 
  - NOT NULL
  - NUMERIC(10, 7)
  - CHECK (LATITUD_VIVERO BETWEEN -90 AND 90)
- **Longitud_Vivero**: 
  - NOT NULL
  - NUMERIC(10, 7)
  -  CHECK (LONGITUD_VIVERO BETWEEN -180 AND 180)

---

**Zona**
- **Nombre_Vivero**: 
  - PRIMARY KEY, UNIQUE
  - FOREIGN KEY de Vivero(Nombre_Vivero)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - VARCHAR(100)
- **Nombre_Zona**:
  - PRIMARY KEY, UNIQUE
  - NOT NULL
  - VARCHAR(100)
  - CHECK (NOMBRE_VIVERO <> NOMBRE_ZONA)
- **Latitud_Zona**:
  - NOT NULL
  - NUMERIC(10, 7)
  - CHECK (LATITUD_ZONA BETWEEN -90 AND 90)
- **Longitud_Zona**:
  - NOT NULL
  - NUMERIC(10, 7)
  - CHECK (LONGITUD_ZONA BETWEEN -180 AND 180)

---

**ClientesPlus**
- **DNI**:
  - PRIMARY KEY
  - NOT NULL
  - CHAR(9)
- **Nombre**:
  - NOT NULL
  - VARCHAR(100)
- **Fecha_Ingreso**:
  - NOT NULL
  - DATE
- **Bonificación**:
  - NOT NULL
  - NUMERIC(3, 2)
  - DEFAULT 0
  - CHECK (Bonificación >= 0)

---

**Pedido**
- **Número_Pedido**:
  - PRIMARY KEY
  - NOT NULL
  - INTEGER
- **Fecha**:
  - NOT NULL
  - DATE
  - CHECK (Fecha <= CURRENT_DATE)
- **Cantidad**:
  - NOT NULL
  - INTEGER
  - CHECK (Cantidad > 0)
- **DNI**:
  - FOREIGN KEY de ClientesPlus(DNI)
  - NULL
  - ON DELETE SET NULL
  - ON UPDATE CASCADE
  - CHAR(9)
- **Identificación**:
  - FOREIGN KEY de Empleado(Identificación)
  - NULL
  - ON DELETE SET NULL
  - INTEGER

---

**Productos**
- **Nombre_Producto**:
  - PRIMARY KEY
  - NOT NULL
  - VARCHAR(100)
- **Cantidad**:
  - NOT NULL
  - INTEGER
  - CHECK (Cantidad >= 0)

---

**Empleado**
- **Identificación**:
  - PRIMARY KEY
  - NOT NULL
  - INTEGER
  - CHECK (Identificación >= 0 AND Identificación <= 999999)
- **Nombre**:
  - NOT NULL
  - VARCHAR(100)

---

**Empleado_Trabaja_Zona**
- **Nombre_Vivero**:
  - PRIMARY KEY
  - FOREIGN KEY de Zona(Nombre_Vivero)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - VARCHAR(100)
- **Nombre_Zona**:
  - PRIMARY KEY
  - FOREIGN KEY de Zona(Nombre_Zona)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - VARCHAR(100)
- **Identificación**:
  - PRIMARY KEY
  - FOREIGN KEY de Empleado(Identificación)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - INTEGER
- **Época_Año**:
  - NOT NULL
  - VARCHAR(10)
  - CHECK (Época_Año IN ('Primavera', 'Verano', 'Otoño', 'Invierno'))

---

**Zona_Produce_Productos**
- **Nombre_Vivero**:
  - PRIMARY KEY
  - FOREIGN KEY de Zona(Nombre_Vivero)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - VARCHAR(100)
- **Nombre_Zona**:
  - PRIMARY KEY
  - FOREIGN KEY de Zona(Nombre_Zona)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - VARCHAR(100)
- **Nombre_Producto**:
  - PRIMARY KEY
  - FOREIGN KEY de Productos(Nombre_Producto)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - VARCHAR(100)

---

**Pedido_Contiene_Productos**
- **Número_Pedido**:
  - PRIMARY KEY
  - FOREIGN KEY de Pedido(Número_Pedido)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - INTEGER
- **Nombre_Producto**:
  - PRIMARY KEY
  - FOREIGN KEY de Productos(Nombre_Producto)
  - NOT NULL
  - ON DELETE CASCADE
  - ON UPDATE CASCADE
  - VARCHAR(100)

## Eliminaciones y restricciones
- **Restricciones de no nulo:** Sólo los atributos que son esenciales para la identidad de las entidades y que no deben perderse con eliminaciones (p. ej., Nombre_Vivero, Nombre_Zona, Identificación) se configuran como NOT NULL.
- **Restricciones de eliminación en cascada:** Útil para las relaciones entre Zona, Zona_Produce_Productos, y Empleado_Trabaja_Zona donde la eliminación de un vivero o zona debe propagar la eliminación.
- **Asignación de valores nulos en caso de eliminación:** Los pedidos pueden perder referencia al cliente o empleado y quedar como históricos.
- **Checks:** A la hora de crear las tablas hemos tenido en cuenta varias restricciones para algunos atributos que hemos cumplido gracias al uso de checks, por ejemplo la bonificación tiene que ser un valor mayor que 0, así como la cantidad en los pedidos o productos. Por otro lado tenemos también checks para que las fechas no puedan ser posteriores a la fecha del sistema. Otro caso es el check de la Época del año, que solo puede tomar como valores Primavera, Verano, Otoño e Invierno. Por último la identificación es un número entre 0 y 999999
- **Disparadores:** Para el **atributo calculado** he creado un disparador que calcula la suma de los pedidos realizados por el cliente el mes en el que nos encontramos (el del sistema) y lo multiplica por 0.01, siendo el máximo valor un 1.0 (que es lo mismo que un 100% de bonificación). Cada vez que se añade una nueva entrada a la tabla de pedido se ejecuta este disparador. También creé un disparador que pone la bonificación de los nuevos cliente a 0, independientemente de si el usuario ha creado al cliente con una bonificación inicial de 1. Por último creé otro disparador que obliga a que la fecha del pedido no pueda ser menor a la fecha de ingreso del cliente en la base de datos.

## Eliminaciones en la base de Datos

- En la base de datos hemos eliminado uno de los viveros y vemos como esta eliminación se propaga hacia las demás tablas debido a la eliminación en cascada, como esto provoca que se elimine una zona, la eliminación de la zona también se propaga en cascada.

**Eliminación de un vivero:**

```postgresql
vivero=# SELECT * FROM ZONA_PRODUCE_PRODUCTOS;
   nombre_vivero   | nombre_zona  |   nombre_producto   
-------------------+--------------+---------------------
 La Orotava        | Zona Norte   | Tierra
 Santa Cruz        | Zona Este    | Semillas de Girasol
 Adeje             | Zona Sur     | Abono
 Puerto de la Cruz | Zona Oeste   | Maceta
 La Laguna         | Zona Central | Amapolas
(5 rows)

vivero=# SELECT * FROM EMPLEADO_TRABAJA_ZONA;
   nombre_vivero   |  nombre_zona   | identificacion | epoca_aÑo 
-------------------+----------------+----------------+-----------
 La Orotava        | Zona Norte     |         123456 | Primavera
 Santa Cruz        | Zona Este      |         123456 | Invierno
 Santa Cruz        | Zona Este      |         234567 | Verano
 Adeje             | Zona Sur       |         345678 | Otoño
 Puerto de la Cruz | Zona Oeste     |         456789 | Invierno
 La Laguna         | Zona Central   |         567890 | Primavera
 La Laguna         | Patio Exterior |         567890 | Primavera
(7 rows)

vivero=# SELECT * FROM ZONA;
   nombre_vivero   |  nombre_zona   | latitud_zona | longitud_zona 
-------------------+----------------+--------------+---------------
 La Orotava        | Zona Norte     |   28.3910000 |   -16.5220000
 Santa Cruz        | Zona Este      |   28.4690000 |   -16.2530000
 Adeje             | Zona Sur       |   28.1230000 |   -16.7250000
 Puerto de la Cruz | Zona Oeste     |   28.4150000 |   -16.5430000
 La Laguna         | Zona Central   |   28.4880000 |   -16.3140000
 La Laguna         | Patio Exterior |   28.4870000 |   -16.4000000
(6 rows)

vivero=# SELECT * FROM VIVERO;
   nombre_vivero   | latitud_vivero | longitud_vivero 
-------------------+----------------+-----------------
 La Orotava        |     28.3905000 |     -16.5231000
 Santa Cruz        |     28.4682000 |     -16.2546000
 Adeje             |     28.1227000 |     -16.7260000
 Puerto de la Cruz |     28.4142000 |     -16.5448000
 La Laguna         |     28.4874000 |     -16.3159000
(5 rows)

vivero=# DELETE FROM VIVERO WHERE NOMBRE_VIVERO = 'Puerto de la Cruz';
DELETE 1
vivero=# SELECT * FROM VIVERO;
 nombre_vivero | latitud_vivero | longitud_vivero 
---------------+----------------+-----------------
 La Orotava    |     28.3905000 |     -16.5231000
 Santa Cruz    |     28.4682000 |     -16.2546000
 Adeje         |     28.1227000 |     -16.7260000
 La Laguna     |     28.4874000 |     -16.3159000
(4 rows)

vivero=# SELECT * FROM ZONA;
 nombre_vivero |  nombre_zona   | latitud_zona | longitud_zona 
---------------+----------------+--------------+---------------
 La Orotava    | Zona Norte     |   28.3910000 |   -16.5220000
 Santa Cruz    | Zona Este      |   28.4690000 |   -16.2530000
 Adeje         | Zona Sur       |   28.1230000 |   -16.7250000
 La Laguna     | Zona Central   |   28.4880000 |   -16.3140000
 La Laguna     | Patio Exterior |   28.4870000 |   -16.4000000
(5 rows)

vivero=# SELECT * FROM ZONA_PRODUCE_PRODUCTOS;
 nombre_vivero | nombre_zona  |   nombre_producto   
---------------+--------------+---------------------
 La Orotava    | Zona Norte   | Tierra
 Santa Cruz    | Zona Este    | Semillas de Girasol
 Adeje         | Zona Sur     | Abono
 La Laguna     | Zona Central | Amapolas
(4 rows)

vivero=# SELECT * FROM EMPLEADO_TRABAJA_ZONA;
 nombre_vivero |  nombre_zona   | identificacion | epoca_aÑo 
---------------+----------------+----------------+-----------
 La Orotava    | Zona Norte     |         123456 | Primavera
 Santa Cruz    | Zona Este      |         123456 | Invierno
 Santa Cruz    | Zona Este      |         234567 | Verano
 Adeje         | Zona Sur       |         345678 | Otoño
 La Laguna     | Zona Central   |         567890 | Primavera
 La Laguna     | Patio Exterior |         567890 | Primavera
(6 rows)
```

- Ahora vamos a eliminar uno de los productos para ver como esta eliminación se propaga por todas las tablas en cascada.

**Eliminación de un producto:**

```postgresql
vivero=# SELECT * FROM PEDIDO_CONTIENE_PRODUCTOS;
 numero_pedido |   nombre_producto   
---------------+---------------------
             1 | Tierra
             2 | Semillas de Girasol
             3 | Maceta
             4 | Abono
             5 | Amapolas
             6 | Tierra
(6 rows)

vivero=# SELECT * FROM ZONA_PRODUCE_PRODUCTOS;
 nombre_vivero | nombre_zona  |   nombre_producto   
---------------+--------------+---------------------
 La Orotava    | Zona Norte   | Tierra
 Santa Cruz    | Zona Este    | Semillas de Girasol
 Adeje         | Zona Sur     | Abono
 La Laguna     | Zona Central | Amapolas
(4 rows)

vivero=# SELECT * FROM PRODUCTOS;
   nombre_producto   | cantidad 
---------------------+----------
 Tierra              |       50
 Semillas de Girasol |      200
 Maceta              |       30
 Abono               |      100
 Amapolas            |       75
(5 rows)

vivero=# DELETE FROM PRODUCTOS WHERE NOMBRE_PRODUCTO = 'Tierra';
DELETE 1
vivero=# SELECT * FROM PRODUCTOS;
   nombre_producto   | cantidad 
---------------------+----------
 Semillas de Girasol |      200
 Maceta              |       30
 Abono               |      100
 Amapolas            |       75
(4 rows)

vivero=# SELECT * FROM PEDIDO_CONTIENE_PRODUCTOS;
 numero_pedido |   nombre_producto   
---------------+---------------------
             2 | Semillas de Girasol
             3 | Maceta
             4 | Abono
             5 | Amapolas
(4 rows)

vivero=# SELECT * FROM ZONA_PRODUCE_PRODUCTOS;
 nombre_vivero | nombre_zona  |   nombre_producto   
---------------+--------------+---------------------
 Santa Cruz    | Zona Este    | Semillas de Girasol
 Adeje         | Zona Sur     | Abono
 La Laguna     | Zona Central | Amapolas
(3 rows)
```

- Ahora vamos a eliminar a uno de los empleados para que veamos como en pedidos se mantiene el histórico del pedido, es decir, que no se elimina.

**Eliminación de un Empleado:**

```postgresql
vivero=# SELECT * FROM PEDIDO;
 numero_pedido |   fecha    | cantidad |    dni    | identificacion 
---------------+------------+----------+-----------+----------------
             1 | 2022-06-05 |       15 | 44332211D |         456789
             2 | 2023-07-10 |       20 | 11223344C |         345678
             3 | 2023-10-02 |        8 | 55667788E |         567890
             4 | 2024-10-17 |       10 | 12345678A |         123456
             5 | 2024-10-27 |        5 | 87654321B |         234567
             6 | 2024-10-28 |        3 | 12345678A |         123456
(6 rows)

vivero=# SELECT * FROM EMPLEADO;
 identificacion |    nombre    
----------------+--------------
         123456 | Manuel Noda
         234567 | Mario Soto
         345678 | David Matías
         456789 | Elena Ruiz
         567890 | Javier Gómez
(5 rows)

vivero=# DELETE FROM EMPLEADO WHERE IDENTIFICACION = 456789;
DELETE 1
vivero=# SELECT * FROM EMPLEADO;
 identificacion |    nombre    
----------------+--------------
         123456 | Manuel Noda
         234567 | Mario Soto
         345678 | David Matías
         567890 | Javier Gómez
(4 rows)

vivero=# SELECT * FROM PEDIDO;
 numero_pedido |   fecha    | cantidad |    dni    | identificacion 
---------------+------------+----------+-----------+----------------
             2 | 2023-07-10 |       20 | 11223344C |         345678
             3 | 2023-10-02 |        8 | 55667788E |         567890
             4 | 2024-10-17 |       10 | 12345678A |         123456
             5 | 2024-10-27 |        5 | 87654321B |         234567
             6 | 2024-10-28 |        3 | 12345678A |         123456
             1 | 2022-06-05 |       15 | 44332211D |               
(6 rows)
```

También pasa lo mismo con la tabla de Empleado_Trabaja_Zona

```postgresql
vivero=# SELECT * FROM EMPLEADO_TRABAJA_ZONA;
 nombre_vivero |  nombre_zona   | identificacion | epoca_aÑo 
---------------+----------------+----------------+-----------
 La Orotava    | Zona Norte     |         123456 | Primavera
 Santa Cruz    | Zona Este      |         123456 | Invierno
 Santa Cruz    | Zona Este      |         234567 | Verano
 Adeje         | Zona Sur       |         345678 | Otoño
 La Laguna     | Zona Central   |         567890 | Primavera
 La Laguna     | Patio Exterior |         567890 | Primavera
(6 rows)

vivero=# SELECT * FROM EMPLEADO;
 identificacion |    nombre    
----------------+--------------
         123456 | Manuel Noda
         234567 | Mario Soto
         345678 | David Matías
         567890 | Javier Gómez
(4 rows)

vivero=# DELETE FROM EMPLEADO WHERE IDENTIFICACION = 123456;
DELETE 1
vivero=# SELECT * FROM EMPLEADO;
 identificacion |    nombre    
----------------+--------------
         234567 | Mario Soto
         345678 | David Matías
         567890 | Javier Gómez
(3 rows)

vivero=# SELECT * FROM EMPLEADO_TRABAJA_ZONA;
 nombre_vivero |  nombre_zona   | identificacion | epoca_aÑo 
---------------+----------------+----------------+-----------
 Santa Cruz    | Zona Este      |         234567 | Verano
 Adeje         | Zona Sur       |         345678 | Otoño
 La Laguna     | Zona Central   |         567890 | Primavera
 La Laguna     | Patio Exterior |         567890 | Primavera
(4 rows)
```

- Por último veamos como si eliminamos a un cliente, su DNI pasa a ser nulo en la tabla de pedidos pues de esta manera mantenemos el registro de que se realizó una compra

**Eliminación de un cliente:**

```postgresql
vivero=# SELECT * FROM CLIENTESPLUS;
    dni    |     nombre      | fecha_ingreso | bonificacion 
-----------+-----------------+---------------+--------------
 11223344C | Daniel Azañón   | 2021-12-01    |         0.00
 55667788E | Luis Fernández  | 2023-10-01    |         0.00
 87654321B | Aday Cuesta     | 2024-10-25    |         0.05
 44332211D | Ana Martínez    | 2020-03-25    |         0.00
 12345678A | Daniel Carvajal | 2024-10-15    |         0.13
(5 rows)

vivero=# SELECT * FROM PEDIDO;
 numero_pedido |   fecha    | cantidad |    dni    | identificacion 
---------------+------------+----------+-----------+----------------
             2 | 2023-07-10 |       20 | 11223344C |         345678
             3 | 2023-10-02 |        8 | 55667788E |         567890
             5 | 2024-10-27 |        5 | 87654321B |         234567
             1 | 2022-06-05 |       15 | 44332211D |               
             4 | 2024-10-17 |       10 | 12345678A |               
             6 | 2024-10-28 |        3 | 12345678A |               
(6 rows)

vivero=# DELETE FROM CLIENTESPLUS WHERE NOMBRE = 'Ana Martínez';
DELETE 1
vivero=# SELECT * FROM CLIENTESPLUS;
    dni    |     nombre      | fecha_ingreso | bonificacion 
-----------+-----------------+---------------+--------------
 11223344C | Daniel Azañón   | 2021-12-01    |         0.00
 55667788E | Luis Fernández  | 2023-10-01    |         0.00
 87654321B | Aday Cuesta     | 2024-10-25    |         0.05
 12345678A | Daniel Carvajal | 2024-10-15    |         0.13
(4 rows)

vivero=# SELECT * FROM PEDIDO;
 numero_pedido |   fecha    | cantidad |    dni    | identificacion 
---------------+------------+----------+-----------+----------------
             2 | 2023-07-10 |       20 | 11223344C |         345678
             3 | 2023-10-02 |        8 | 55667788E |         567890
             5 | 2024-10-27 |        5 | 87654321B |         234567
             4 | 2024-10-17 |       10 | 12345678A |               
             6 | 2024-10-28 |        3 | 12345678A |               
             1 | 2022-06-05 |       15 |           |               
(6 rows)
```
