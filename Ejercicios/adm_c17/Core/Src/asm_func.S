.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_svc
.global asm_sum
.global asm_zeros_32
.global asm_zeros_16
.global asm_productoEscalar32b
.global asm_productoEscalar16b
.global asm_productoEscalar12b
.global asm_filtroVentana10
.global asm_pack32to16
.global asm_max
.global asm_downsampleM
.global asm_invertir


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
    asm_zeros_32:
        push {r1, r2}
        mov r2, 0           @ constante cero
    .asm_zeros_32_loop:
        str r2, [r0], 4     @ sizeof(uint32_t) == 4, *vector++ = r2
        subs r1, 1          @ --longitud
        bne .asm_zeros_32_loop
        pop {r2, r1}
        bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint16_t *vector, uint16_t longitud);
@
@ Parametros recibidos:
@   r0: *vector
@   r1: longitud
@
.thumb_func
    asm_zeros_16:
    	push {r1, r2}
        mov r2, 0            @ constante cero
    .asm_zeros_16_loop:
        strh r2, [r0], 2     @ sizeof(uint32_t) == 4, *vector++ = r2
        subs r1, 1           @ --longitud
        bne .asm_zeros_16_loop
        pop {r2, r1}
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
	    push {r11, r10, r9, r8, r7, r6, r5, r4}
	 	mov r11, r2						@Guardo la longitud en el registro r11
	    .asm_for_loop_32b:				@Bucle 'for' que recorre cada elemento del vector
	    	cmp r11, 0					@Si la longitud es 0, quiere decir que ya se recorrio todos los elementos
	    	beq .fin					@y debo terminar el programa, salto condicional a fin.

	.asm_while_loop_32b:				@Bucle 'while' que se usa para la suma iterativa
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
		pop {r4, r5, r6, r7, r8, r9, r10, r11}
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
    	push {r11, r10, r9, r8, r7, r6, r5, r4}
	 	mov r11, r2						@Guardo la longitud en el registro r11
	    .asm_for_loop_16b:				@Bucle 'for' que recorre cada elemento del vector
	    	cmp r11, 0					@Si la longitud es 0, quiere decir que ya se recorrio todos los elementos
	    	beq .fin					@y debo terminar el programa, salto condicional a fin.

			.asm_while_loop_16b:				@Bucle 'while' que se usa para la suma iterativa
				mov r10, r3						@Guardo el valor del escalar en el registro r10

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
				mov r7, 0xffff					@Guardo el valor máximo de 16bits (0xffff) en el registro r7.
			   	strh r7, [r1]					@Guardo el valor de r7 en el vectorOut[x] y

			.asm_sigVector_loop_16b:
			   	ldrh r5, [r0], 2				@Leo y paso al siguiente elemento del vectorIn[x]
			    ldrh r6, [r1], 2				@Leo y paso al siguiente elemento del vectorOut[x]
			    subs r11, 1						@Resto 1 al valor de r11 (longitud) y
			    b .asm_for_loop_16b				@Hago un salto incondicional al loop for para continuar con la función.

		.fin_16b:
			pop {r4, r5, r6, r7, r8, r9, r10, r11}
			bx lr							@Finalizo la función.

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
    	push {r11, r10, r9, r8, r7, r6, r5, r4}
	 	mov r11, r2								@Guardo la longitud en el registro r11
		.asm_for_loop_12b:						@Bucle 'for' que recorre cada elemento del vector
	    	cmp r11, 0							@Si la longitud es 0, quiere decir que ya se recorrio todos los elementos
	    	beq .fin							@y debo terminar el programa, salto condicional a fin.

	    	.asm_while_loop_12b:				@Bucle 'while' que se usa para la suma iterativa
		    	mov r10, r3						@Guardo el valor del escalar en el registro r10

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
		    	mov r7, 0xfff					@Guardo el valor máximo de 12bits (0xfff) en el registro r7.
		    	strh r7, [r1]					@Guardo el valor de r7 en el vectorOut[x] y

		    .asm_sigVector_loop_12b:
		    	ldrh r5, [r0], 2				@Leo y paso al siguiente elemento del vectorIn[x]
		    	ldrh r6, [r1], 2				@Leo y paso al siguiente elemento del vectorOut[x]
		    	subs r11, 1						@Resto 1 al valor de r11 (longitud) y
		    	b .asm_for_loop_12b				@Hago un salto incondicional al loop for para continuar con la función.

	    .fin_12b:
	    	pop {r4, r5, r6, r7, r8, r9, r10, r11}
	    	bx lr								@Finalizo la función.


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@	EJERCICIO 5)
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@ void asm_windowFilter10(uint16_t * vectorIn , uint16_t * vectorOut , uint32_t longitudVectorIn)
@
@ Parametros recibidos:
@   r0: * vector
@   r1: * vector
@	r2: longitudVectorIn
@
.thumb_func
	asm_filtroVentana10:
        push {r3}
        push {r4}
        push {r5}
        push {r6}
        push {r7}
        push {r8}
		mov r3, 0

	.asm_filtroVentana10_for_1:
		mov r4, 0
		mov r5, 0

	.asm_filtroVentana10_for_2:
		add r6, r3, r5
		cmp r6, r2
		blt .asm_filtroVentana10_if_index_plus_i_lt_longitud
		udiv r7, r6, r2
		mul r7, r7, r2
		sub r6, r6, r7

	.asm_filtroVentana10_if_index_plus_i_lt_longitud:
		mov r8, 2
		mul r6, r6, r8
		add r6, r0, r6
		ldrh r8, [r6]
		add r4, r4, r8
		add r5, 1
		cmp r5, 10
		blt .asm_filtroVentana10_for_2
		mov r8, 10
		udiv r8, r4, r8
		strh r8, [r1], 2
		add r3, 1
		cmp r3, r2
		blt .asm_filtroVentana10_for_1
		pop {r8}
        pop {r7}
		pop {r6}
        pop {r5}
        pop {r4}
        pop {r3}
		bx lr

  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void pack32to16(int32_t * vectorIn, int16_t * vectorOut, uint32_t longitudVectorIn);
@
@ Parametros recibidos:
@   r0: * vectorIn
@	r1: * vectorOut
@	r2: longitudVectorIn
@

.thumb_func
    asm_pack32to16:
    	push {r3, r4, r5, r6}
		mov r3, r2						@Cargo el valor de la longitud en R3 que será usado para recorrer el vector
		.asm_pack32to16.L1:
			cmp r3, 0					@Comparo R3 y 0,
			beq .asm_pack32to16.Fin		@si R3 == 0, entonces finalizo el programa
			ldr r4, [r0], 4				@si R3 > 0, entonces continuo iterando. Cargo en R4 el valor del vector y paso al siguiente indice
			mov r5, r4					@Cargo el valor de R4 en R5.
			ands r4, 0x00FF0000			@Aplico: R4 = R4 & 0x00FF0000
			lsr r4, 16					@desplazo hacia la izquierda 16 bits
			ands r5, 0xFF000000			@Aplico: R5 = R5 & 0xFF000000
			lsr r5, 16					@desplazo hacia la izquierda 16 bits
			orr r6, r4, r5				@Hago un OR, R6 = R4 | R5
			strh r6, [r1], 2			@Subo el valor al vector de salida y paso al siguiente indice
			subs r3, 1					@Resto 1 a R3 y continuo con la iteracion.
			b .asm_pack32to16.L1
		.asm_pack32to16.Fin:
			pop {r6, r5, r4, r3}
			bx lr						@Finalizo el programa


  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t max(int32_t * vectorIn, uint32_t longitudVectorIn);
@
@ Parametros recibidos:
@   r0: * vectorIn
@	r1: longitudVectorIn
@

.thumb_func
    asm_max:
    	push {r2, r3, r4, r5, r6, r7, r8}
		mov r3, r1					@Registro utilizado para recorrer todo el vector, toma la longitud del vector e irá decrementando.
		mov r4, 0					@Registro temporal utilizado para almacenar la posición del vector con mayor número
		push {r4}
		.asm_max.L1:
			cmp r3, 0				@R3 es igual a 0? ya recorrió todo el vector?
			beq .asm_max.Fin		@Si ya recorrio todo el vector, debe finalizar la función
			subs r5, r1, r3			@Calculo la posición actual del vector, R5 = R1 (longitud) - R3
			adds r5, 1				@R5 = R5+1, para saber
			cmp r5, r1				@si ya llegamos al tope del vector
			bcs .asm_max.limite		@Ya estamos en el final, salto condicional.
			ldr r6, [r0], 4			@Aun falta recorrer, leo el vector y paso al indice siguiente
			ldr r7, [r0], -4		@Leo el vector y retrocedo al indice anterior
			cmp r6, r7
			blt .asm_max.esMenor	@R6 < R7 salta.
			b .asm_max.esMayor		@R6 > R7 salta.

		.asm_max.esMenor:
			ldr r8, [r0, 4]!		@Leo el vector y aumento el indice.
			cmp r4, r8				@Comparo el registro R4(dato anterior) y R8(dato leido)
			bgt .asm_max.salgo		@R4>R10, salgo
			pop {r4}				@leo la pila y lo guardo en R4
			push {r5}				@Guardo en la pila el valor de R5
			mov r4, r8				@Muevo el valor de R8 en R4
			subs r3, 1				@Resto en 1 el registro para el recorrido
			b .asm_max.L1			@Continuo

		.asm_max.esMayor:
			ldr r8, [r0], 4			@Leo el vector y aumento el indice.
			cmp r4, r8				@Comparo el registro R4(dato anterior) y R8(dato leido)
			bge .asm_max.salgo		@R4>R10, salgo
			pop {r4}				@leo la pila y lo guardo en R4
			subs r5, 1				@Resto 1 para identificar el indice y
			push {r5}				@Guardo en la pila el valor de R5
			adds r5, 1				@regreso a su valor anterior
			mov r4, r8				@Muevo el valor de R8 en R4
			subs r3, 1				@Resto en 1 el registro para el recorrido
			b .asm_max.L1			@Continuo

		.asm_max.salgo:
			subs r3, 1				@Resto en 1 el registro para el recorrido
			b .asm_max.L1

		.asm_max.limite:
			subs r3, 1				@Resto en 1 el registro para el recorrido
			b .asm_max.L1			@Continuo

		.asm_max.Fin:
			pop {r4}				@leo la pila y lo guardo en R4
			mov r0, r4				@Guardo en R0 (registro de retorno) el puntero que tiene el dato mayor del vector.
			pop {r8, r7, r6, r5, r4, r3, r2}
			bx lr					@Finaliza


 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void downsampleM(int32_t * vectorIn, int32_t * vectorOut, uint32_t longitudVectorIn, uint32_t N);
@
@ Parametros recibidos:
@   r0: * vectorIn
@	r1: * vectorOut
@	r2: longitudVectorIn
@	r3: N
@

.thumb_func
    asm_downsampleM:
    	push {r4, r5, r6}
		mov r4, r2
		mov r5, 1							@ n=1
		.asm_downsampleM.L1:
			cmp r4, 0
			beq .asm_downsampleM.Fin
			cmp r5, r3						@ n<longitud
			bge .asm_downsampleM.Descarta
			ldr r6, [r0], 4
			adds r5, 1						@ n++
			subs r4, 1						@ r4-- (resto 1 a longitud)
			str r6, [r1], 4
			b .asm_downsampleM.L1
		.asm_downsampleM.Descarta:
			mov r5, 1						@ n=1
			ldr r6, [r0], 4
			subs r4, 1						@ r4-- (resto 1 a longitud)
			b .asm_downsampleM.L1
		.asm_downsampleM.Fin:
			pop {r6, r5, r4}
			bx lr


 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void invertir(uint16_t * vector, uint16_t longitud);
@
@ Parametros recibidos:
@   r0: * vector
@	r1: longitud
@

.thumb_func
    asm_invertir:
    	push {r1, r2, r3, r4, r5, r6, r7}
    	mov r2, r1
    	subs r2, 1						@ i = (longitud - 1) => r2
		mov r3, 0						@ j = 0
		mov r4, 0						@ variable temporal de aumento de indice
		mov r5, 0						@ variable temporal de decremento de indice
		.asm_invertir.L1:
			cmp r1, 1
			beq .asm_invertir.L2
			adds r5, 2
			subs r1, 1
			b .asm_invertir.L1
		.asm_invertir.L2:
			cmp r2, 0
			blt .asm_invertir.Fin
			cmp r2, r3					@ i < j0
			ble .asm_invertir.Fin
			ldrh r6, [r0, r5]
			ldrh r7, [r0, r4]
			strh r6, [r0, r4]
			strh r7, [r0, r5]
			subs r2, 1					@ i--
			adds r3, 1					@ j++
			adds r4, 2					@ r4++
			subs r5, 2					@ r5--
			b .asm_invertir.L2
		.asm_invertir.Fin:
			pop {r7, r6, r5, r4, r3, r2, r1}
			bx lr









