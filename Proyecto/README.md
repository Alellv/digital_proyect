# Muestra de imagenes en matriz de leds dependiendo de la temperatura

Como dice el nombre, este proyecto busca hacer que dependiendo de la temperatura que lea un sensor se muestren diferentes imagenes en una pantalla, para hacer esto posible se usará una matriz de leds de 64x64 en la cual se mostrarán imagenes que contengan 12 bits por pixel y un sensor de temperatura y humedad AHT10 puesto que el protocolo de communicación que usa este sensor es I2C.

## Diagramas de matriz de leds 12bpp

### Diagrama de flujo

![Diagrama de flujo](DiagramasProyecto/DiagramasPantalla_12bpp/Flujo.png)

### Camino de datos

![Camino de datos](DiagramasProyecto/DiagramasPantalla_12bpp/Datos.png)
	
### Diagrama de estados

![Diagrama de estados](DiagramasProyecto/DiagramasPantalla_12bpp/Estados.png)


## Diagramas sensor de temperatura AHT10

### Diagramas de flujo

#### Diagrama de flujo para protocolo I2C

![Diagrama de flujo](DiagramasProyecto/DiagramasSensor/FlujoI2C.png)

#### Diagrama de flujo para protocolo I2C

![Diagrama de flujo](DiagramasProyecto/DiagramasSensor/FlujoSensor.png)

### Camino de datos

![Camino de datos](DiagramasProyecto/DiagramasSensor/Datos.png)
	
### Diagrama de estados

![Diagrama de estados](DiagramasProyecto/DiagramasSensor/Estados.png)

