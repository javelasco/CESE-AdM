.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros
.global asm_productoEscalar32b
.global asm_productoEscalar16b
.global asm_productoEscalar12b


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@
.thumb_func
    asm_svc:
        svc 0
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint32_t *vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: *vector
@   r1: longitud
@
.thumb_func
    asm_zeros:
        @ Registros usados
        @   r2: valor cero
        mov r2, 0           @ constante cero
    .asm_zeros_loop:
        str r2, [r0], 4     @ sizeof(uint32_t) == 4, *vector++ = r2
        subs r1, 1          @ --longitud
        bne .asm_zeros_loop
        bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void productoEscalar32b (uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);
@
@ Parametros recibidos:
@   r0: *vectorIn
@   r1: *vectorOut
@   r2: longitud
@   r3: escalar
@
.thumb_func
    asm_productoEscalar32b:
 	mov r11, r2						@Guardo la longitud en el registro r11
    .asm_for_loop_32b:				@Bucle 'for' que recorre cada elemento del vector
    	cmp r11, 0					@Si la longitud es 0, quiere decir que ya se recorrio todos los elementos
    	beq .fin					@y debo terminar el programa, salto condicional a fin.
    .asm_while_loop_32b:			@Bucle 'while' que se usa para la suma iterativa
    	mov r10, r3					@Guardo el valor del escalar en el registro r10
    .asm_suma_loop_32b:
    	cmp r10, 0					@Comparo si el valor del escalar es 0, cada iteración se le resta 1
    	beq .asm_sigVector_loop_32b	@si es 0, quiere decir que ya termino de sumar las 'n' veces y debe pasar al siguiente elemento del vector
    	ldr r5, [r0]				@Guardo en el registro r5 el valor del vectorIn[x], comienza en la posición 0.
    	ldr r6, [r1]				@Guardo en el registro r6 el valor del vectorOut[x], comienza en la posición 0.
    	adds r7, r5, r6				@Se guarda en el registro r7 la suma de vectorIn[x] + vectorOut[x].
    	mov r8, 0xffffffff			@Guardo el valor máximo de 32bits (0xffffffff) en el registro r8.
    	subs r8, r5					@Guardo en el registro r8 la resta del registro r8 y r5 (2^32 - vectorIn[x]).
    	cmp r7, r8					@Comparo el registro r7 y r8, si el valor de r7 es mayor o igual a r8
    	bhs  .asm_saturar_loop_32b	@Hago un salto condicional para saturar el valor al máximo posible en 32bits (0xffffffff).
    	str r7, [r1]				@Si el valor de r7 es menor a r8, entonces guardo el valor de r7 en el vectorOut[x] y continuo sumando.
    	subs r10, 1					@Resto 1 al valor de r10 (escalar) y
    	b .asm_suma_loop_32b		@Hago un salto incondicional para continuar con las sumas.
    .asm_saturar_loop_32b:
    	mov r7, 0xffffffff			@Guardo el valor máximo de 32bits (0xffffffff) en el registro r7.
    	str r7, [r1]				@Guardo el valor de r7 en el vectorOut[x] y
    .asm_sigVector_loop_32b:
    	ldr r5, [r0], 4				@Leo y paso al siguiente elemento del vectorIn[x]
    	ldr r6, [r1], 4				@Leo y paso al siguiente elemento del vectorOut[x]
    	subs r11, 1					@Resto 1 al valor de r11 (longitud) y
    	b .asm_for_loop_32b			@Hago un salto incondicional al loop for para continuar con la función.
    .fin:
    	bx lr						@Finalizo la función.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void productoEscalar16b (uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: *vectorIn
@   r1: *vectorOut
@   r2: longitud
@   r3: escalar
@
.thumb_func
    asm_productoEscalar16b:
 	mov r11, r2						@Guardo la longitud en el registro r11
    .asm_for_loop_16b:				@Bucle 'for' que recorre cada elemento del vector
    	cmp r11, 0					@Si la longitud es 0, quiere decir que ya se recorrio todos los elementos
    	beq .fin					@y debo terminar el programa, salto condicional a fin.
    .asm_while_loop_16b:			@Bucle 'while' que se usa para la suma iterativa
    	mov r10, r3					@Guardo el valor del escalar en el registro r10
    .asm_suma_loop_16b:
    	cmp r10, 0					@Comparo si el valor del escalar es 0, cada iteración se le resta 1
    	beq .asm_sigVector_loop_16b	@si es 0, quiere decir que ya termino de sumar las 'n' veces y debe pasar al siguiente elemento del vector
    	ldrh r5, [r0]				@Guardo en el registro r5 el valor del vectorIn[x], comienza en la posición 0.
    	ldrh r6, [r1]				@Guardo en el registro r6 el valor del vectorOut[x], comienza en la posición 0.
    	adds r7, r5, r6				@Se guarda en el registro r7 la suma de vectorIn[x] + vectorOut[x].
    	mov r8, 0xffff				@Guardo el valor máximo de 16bits (0xffff) en el registro r8.
    	subs r8, r5					@Guardo en el registro r8 la resta del registro r8 y r5 (2^32 - vectorIn[x]).
    	cmp r7, r8					@Comparo el registro r7 y r8, si el valor de r7 es mayor o igual a r8
    	bhs  .asm_saturar_loop_16b	@Hago un salto condicional para saturar el valor al máximo posible en 16bits (0xffff).
    	strh r7, [r1]				@Si el valor de r7 es menor a r8, entonces guardo el valor de r7 en el vectorOut[x] y continuo sumando.
    	subs r10, 1					@Resto 1 al valor de r10 (escalar) y
    	b .asm_suma_loop_16b		@Hago un salto incondicional para continuar con las sumas.
    .asm_saturar_loop_16b:
    	mov r7, 0xffff				@Guardo el valor máximo de 16bits (0xffff) en el registro r7.
    	strh r7, [r1]				@Guardo el valor de r7 en el vectorOut[x] y
    .asm_sigVector_loop_16b:
    	ldrh r5, [r0], 2			@Leo y paso al siguiente elemento del vectorIn[x]
    	ldrh r6, [r1], 2			@Leo y paso al siguiente elemento del vectorOut[x]
    	subs r11, 1					@Resto 1 al valor de r11 (longitud) y
    	b .asm_for_loop_16b			@Hago un salto incondicional al loop for para continuar con la función.
    .fin_16b:
    	bx lr						@Finalizo la función.

  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void productoEscalar12b (uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitud, uint16_t escalar);
@
@ Parametros recibidos:
@   r0: *vectorIn
@   r1: *vectorOut
@   r2: longitud
@   r3: escalar
@
.thumb_func
    asm_productoEscalar12b:
 	mov r11, r2						@Guardo la longitud en el registro r11
    .asm_for_loop_12b:				@Bucle 'for' que recorre cada elemento del vector
    	cmp r11, 0					@Si la longitud es 0, quiere decir que ya se recorrio todos los elementos
    	beq .fin					@y debo terminar el programa, salto condicional a fin.
    .asm_while_loop_12b:			@Bucle 'while' que se usa para la suma iterativa
    	mov r10, r3					@Guardo el valor del escalar en el registro r10
    .asm_suma_loop_12b:
    	cmp r10, 0					@Comparo si el valor del escalar es 0, cada iteración se le resta 1
    	beq .asm_sigVector_loop_12b	@si es 0, quiere decir que ya termino de sumar las 'n' veces y debe pasar al siguiente elemento del vector
    	ldrh r5, [r0]				@Guardo en el registro r5 el valor del vectorIn[x], comienza en la posición 0.
    	ldrh r6, [r1]				@Guardo en el registro r6 el valor del vectorOut[x], comienza en la posición 0.
    	adds r7, r5, r6				@Se guarda en el registro r7 la suma de vectorIn[x] + vectorOut[x].
    	mov r8, 0xfff				@Guardo el valor máximo de 12bits (0xfff) en el registro r8.
    	subs r8, r5					@Guardo en el registro r8 la resta del registro r8 y r5 (2^32 - vectorIn[x]).
    	cmp r7, r8					@Comparo el registro r7 y r8, si el valor de r7 es mayor o igual a r8
    	bhs  .asm_saturar_loop_12b	@Hago un salto condicional para saturar el valor al máximo posible en 12bits (0xfff).
    	strh r7, [r1]				@Si el valor de r7 es menor a r8, entonces guardo el valor de r7 en el vectorOut[x] y continuo sumando.
    	subs r10, 1					@Resto 1 al valor de r10 (escalar) y
    	b .asm_suma_loop_12b		@Hago un salto incondicional para continuar con las sumas.
    .asm_saturar_loop_12b:
    	mov r7, 0xfff				@Guardo el valor máximo de 12bits (0xfff) en el registro r7.
    	strh r7, [r1]				@Guardo el valor de r7 en el vectorOut[x] y
    .asm_sigVector_loop_12b:
    	ldrh r5, [r0], 2			@Leo y paso al siguiente elemento del vectorIn[x]
    	ldrh r6, [r1], 2			@Leo y paso al siguiente elemento del vectorOut[x]
    	subs r11, 1					@Resto 1 al valor de r11 (longitud) y
    	b .asm_for_loop_12b			@Hago un salto incondicional al loop for para continuar con la función.
    .fin_12b:
    	bx lr						@Finalizo la función.




