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
- **Longitud_Vivero**: 
  - NOT NULL
  - NUMERIC(10, 7)

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
- **Latitud_Zona**:
  - NOT NULL
  - NUMERIC(10, 7)
- **Longitud_Zona**:
  - NOT NULL
  - NUMERIC(10, 7)

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
  - NOT NULL
  - ON DELETE SET NULL
  - ON UPDATE CASCADE
  - CHAR(9)
- **Identificación**:
  - FOREIGN KEY de Empleado(Identificación)
  - NOT NULL
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
  - ON DELETE SET NULL
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
  - ON DELETE SET NULL
  - ON UPDATE CASCADE
  - VARCHAR(100)

## Eliminaciones y restricciones
- **Restricciones de no nulo:** Sólo los atributos que son esenciales para la identidad de las entidades y que no deben perderse con eliminaciones (p. ej., Nombre_Vivero, Nombre_Zona, Identificación) se configuran como NOT NULL.
- **Restricciones de eliminación en cascada:** Útil para las relaciones entre Zona, Zona_Produce_Productos, y Empleado_Trabaja_Zona donde la eliminación de un vivero o zona debe propagar la eliminación.
- **Asignación de valores nulos en caso de eliminación:** Los pedidos pueden perder referencia al cliente o empleado y quedar como históricos.
