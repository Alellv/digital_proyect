# Proyecto: Muestra de imagenes en matriz de leds dependiendo de la temperatura

Como dice el nombre, este proyecto busca hacer que dependiendo de la temperatura que lea un sensor se muestren diferentes imagenes en una pantalla, para hacer esto posible se usará una matriz de leds de 64x64 en la cual se mostrarán imagenes que contengan 12 bits por pixel y un sensor de temperatura y humedad AHT10 puesto que el protocolo de communicación que usa este sensor es I2C.

A continuación una breve explicación de las bases para el funcionamiento del proyecto.

## Interfaz de conexión HUB75E

![HUB75E](DiagramasProyecto/Imagenes/HUB75E.png)

La interfaz de conexión HUB75E es un conector que consiste de 16 pines utilizado en matrices LED RGB para transmitir datos y señales de control, incluye seis líneas de datos (R0/1, G0/1, B0/1) las cuales envian los bits de color a dos filas simultáneas del panel, además de las líneas de selección (A, B, C, D) que determinan qué grupo de filas se activa en cada ciclo, están las señales de control CLK, LATCH y /OE que permiten sincronizar la carga de datos y el encendido de los LEDs, mientras que los pines GND sirven como referencia a tierra. Es esta combinación de señales la cual permite refrescar la pantalla rápidamente mediante multiplexación por filas.

La imagen sacada fue obtenida del libro proporcionado por el profesor.

## Protocolo de comunicación I2C

![Diagrama de flujo](DiagramasProyecto/Imagenes/DispositivosI2C.png)

En esta imagen se muestra la conección de los dispositivos que se usarán con el protocolo I²C, en esta se puede ver como se establece el bus de comunicación que se compone por dos líneas compartidas: SCL (reloj) y SDA (datos). Ambas líneas son de tipo open-drain/open-collector, por lo que es necesario el uso resistencias de pull-up (Rp) que las mantienen en nivel alto cuando ningún dispositivo las está usando. Todos los dispositivos (tanto el maestro como uno o varios esclavos) se conectan en paralelo a estas dos líneas, lo cual permite una comunicación entre dispositivos sin conflicto mientras solo un maestro controla el reloj.

![Diagrama de flujo](DiagramasProyecto/Imagenes/STSP.png)

Para este protocolo hay condiciones especiales para dar un inicio y un fin a la comunicación. La condición de START (S) ocurre cuando SDA pasa de alto a bajo mientras SCL está alto, indicando a todos los dispositivos que empieza una transmisión. La condición de STOP (P) ocurre cuando SDA pasa de bajo a alto mientras SCL está alto, señalando el final de la comunicación y liberando el bus. Estas dos secuencias son esenciales para enmarcar los mensajes y coordinar el acceso al bus I²C y su forma es la que se muestra en la imagen anterior.

![Diagrama de flujo](DiagramasProyecto/Imagenes/BusCompos.png)

Una vez sabiendo las condiciones de inicio y fin, es necesario ver cómo se transmite un byte en este protocolo: la línea SDA envía los bits desde D7 hasta D0, cambiando su valor únicamente mientras SCL está en nivel bajo, y cada bit es leído en el flanco alto de SCL. Después de los 8 bits de datos, el transmisor libera SDA y el receptor genera el noveno pulso de reloj para enviar el bit ACK (nivel bajo) o NACK (nivel alto), indicando si recibió correctamente el byte, el transmisor o receptor puede cambiar entre maestro y esclavo dependiendo de si el maestro va a escribir o leer sobre un esclabo.

Al iniciar una comunicación lo que suele ocurrir es que tras la condición de incio se envia la dirección del esclavo con el que se quiere comunicar, siendo esta los bits de D7 a D1, mientras que D0 determinará si el esclavo será leido o si se escribira sobre este. Cuando se escribe la dirección para escritura, el maestro enviará lo que quiere escribir byte a byte esperando el correspondiende ACK antes de mandar la condición de parada, mientras que cuando se escribe la dirección para lectura, una vez enciada esta el maestro empezará a leer byte a byte lo que se envia por SDA mientras que manda los correspondientes ACK; cuando no quiera leer más del esclavo el maestro enviará un NACK seguido de la condición de parada. 

Las imagenes usadas fueron sacadas de:
(https://www-robot--electronics-co-uk.translate.goog/i2c-tutorial?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)

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

