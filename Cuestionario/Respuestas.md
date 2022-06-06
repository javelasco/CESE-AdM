# CESE - AdM / Respuestas al cuestionario

Preguntas orientadoras:
1. Describa brevemente los diferentes perfiles de familias de microprocesadores/microcontroladores de ARM. Explique alguna de sus diferencias características.

Básicamente existen 3 perfiles:
* El perfil CORTEX A que se usa para aplicaciones de alto rendimiento, donde básicamente correrá un sistema operativo como Android, IOS, etc.
* El perfil CORTEX R que se usa para aplicaciones de tiempo real (Real Time), donde lo importante es la baja latencia y la confiabilidad en sistemas críticos, por ejemplo: Sistema ABS de un automóvil donde no hay margen de error y los tiempos de respuestas deben ser "inmediatos".
* El perfil CORTEX M que se usa para desarrollo de sistemas embebidos compactos y de propósito general, para ser usados como baremetal y programación en C.

Cortex M:
1. Describa brevemente las diferencias entre las familias de procesadores Cortex M0, M3 y M4.

La versión más básica son los Cortex M0, los M3 son los CPU mas convencionales con una gama amplia de aplicaciones y los M4 básicamente agrega procesamiento de números de punto flotante.
Otra diferencia importante es que los M0 son de arquitectura Von Neumann y los M3 y M4 son de arquitectura Harvard.


2. ¿Por qué se dice que el set de instrucciones Thumb permite mayor densidad de código? Explique

Los últimos procesadores ARM incluyen la tecnología Thumb, que básicamente es un set de instrucciones de 16bits, al ser de 16 bits se consigue optimizar el uso de la memoria, ya que hay casos donde no necesitamos una instrucción de 32 bits sino bastaría con una de 16bits. Esto provoca tener mayor densidad de código ya que la memoria flash que se utiliza es menor.

3. ¿Qué entiende por arquitectura load-store? ¿Qué tipo de instrucciones no posee este tipo de arquitectura?

La arquitectura Load Store significa que el procesador no puede acceder escribir o leer directamente a la memoria siempre debe pasar por los registros de propósito general del CPU. Las instrucciones que se utilizan son LDR y STR para poder leer y escribir en la memoria.


4. ¿Cómo es el mapa de memoria de la familia?
5. ¿Qué ventajas presenta el uso de los “shadowed pointers” del PSP y el MSP?
6. Describa los diferentes modos de privilegio y operación del Cortex M, sus relaciones y cómo se conmuta de uno al otro. Describa un ejemplo en el que se pasa del modo privilegiado a no privilegiado y nuevamente a privilegiado.

Existen dos modos de operación de los procesadores, el modo usuario o modo no privilegiado y modo supervisor o modo privilegiado.

El modo usuario básicamente es el modo en el que se ejecuta una aplicación y usa un conjunto de instrucciones generales o básicas en un programa.

El modo supervisor o privilegiado ofrece un acceso y control total de las instrucciones del procesador y recursos del sistema. Hay que tener cuidado cuando se usa este modo ya que un fallo en la programación provocaría colgar el sistema.

7. ¿Qué se entiende por modelo de registros ortogonal? Dé un ejemplo
8. ¿Qué ventajas presenta el uso de instrucciones de ejecución condicional (IT)? Dé un ejemplo
9. Describa brevemente las excepciones más prioritarias (reset, NMI, Hardfault).
10. Describa las funciones principales de la pila. ¿Cómo resuelve la arquitectura el llamado a funciones y su retorno?
11. Describa la secuencia de reset del microprocesador.
12. ¿Qué entiende por “core peripherals”? ¿Qué diferencia existe entre estos y el resto de los periféricos?
13. ¿Cómo se implementan las prioridades de las interrupciones? Dé un ejemplo
14. ¿Qué es el CMSIS? ¿Qué función cumple? ¿Quién lo provee? ¿Qué ventajas aporta?
15. Cuando ocurre una interrupción, asumiendo que está habilitada ¿Cómo opera el microprocesador para atender a la subrutina correspondiente? Explique con un ejemplo
16. ¿Cómo cambia la operación de stacking al utilizar la unidad de punto flotante?
17. Explique las características avanzadas de atención a interrupciones: tail chaining y late arrival.
18. ¿Qué es el systick? ¿Por qué puede afirmarse que su implementación favorece la portabilidad de los sistemas operativos embebidos?

Básicamente es un temporizador, se estandarizó ese temporizador de esa manera para que todos los fabricantes de HW puedan trabajar homologados.

19. ¿Qué funciones cumple la unidad de protección de memoria (MPU)?
20. ¿Cuántas regiones pueden configurarse como máximo? ¿Qué ocurre en caso de haber solapamientos de las regiones? ¿Qué ocurre con las zonas de memoria no cubiertas por las regiones definidas?
21. ¿Para qué se suele utilizar la excepción PendSV? ¿Cómo se relaciona su uso con el resto de las excepciones? Dé un ejemplo
22. ¿Para qué se suele utilizar la excepción SVC? Explíquelo dentro de un marco de un sistema operativo embebido.

ISA:
1. ¿Qué son los sufijos y para qué se los utiliza? Dé un ejemplo
2. ¿Para qué se utiliza el sufijo ‘s’? Dé un ejemplo
3. ¿Qué utilidad tiene la implementación de instrucciones de aritmética saturada? Dé un ejemplo con operaciones con datos de 8 bits.
4. Describa brevemente la interfaz entre assembler y C ¿Cómo se reciben los argumentos de las funciones? ¿Cómo se devuelve el resultado? ¿Qué registros deben guardarse en la pila antes de ser modificados?
5. ¿Qué es una instrucción SIMD? ¿En qué se aplican y qué ventajas reporta su uso? Dé un ejemplo.
