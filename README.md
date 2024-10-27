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
    - Ejemplo: 1.0 (Qué es lo mismo que decir 10%)
   
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
