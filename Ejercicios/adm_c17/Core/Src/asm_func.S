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
.global asm_filtroVentana10
.global asm_pack32to16
.global asm_max


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







  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitudVectorIn, uint16_t ventana);
@
@ Parametros recibidos:
@   r0: * vectorIn
@	r1: * vectorOut
@	r2: longitudVectorIn
@   r3: ventana
@
.thumb_func
    asm_filtroVentana10:
		mov r10, r2															@Guardo el valor de la longitud(r2) en R10.
		mov r11, r2															@Guardo el valor de la longitud(r2) en R11.
		.asm_filtroVentana10.L1:											@Loop for: i<longitudVectorIn
			mov r11, r2
			cmp r10, 0														@Si la longitud es 0, quiere decir que ya recorrio todos los elementos del vector
			beq .asm_filtroVentana10.fin									@y debe finalizar el programa.
			ldrh r5, [r0]												 	@Guardo en el registro r5 el valor del vectorIn[x], comienza en la posición 0.
    		ldrh r6, [r1]													@Guardo en el registro r6 el valor del vectorOut[x], comienza en la posición 0.
			subs r11, r10													@Resto r11 = r11-r10 para obetener el indice del vector en el que se encuentra.
			push {r11}
			mov r9, r3														@Guardo el valor de la ventana(r3) en R9.
			.asm_filtroVentana10.L2:
				cmp r9, 0													@Comparo si r9 = 0, eso quiere decir que ya se sumaron todos los valores de la ventana,
				beq .asm_filtroVentana10.promediar							@si es 0, entonces tengo que promediar. si es mayor que 0 entonces continuo sumando.
				adds r11, 1													@Le sumo 1 a la longitud para saber si estoy en el indice final.
				cmp r11, r2													@Comparo si r11(nueva longitud) con 0,
				bhi .asm_filtroVentana10.poner0
				.asm_filtroVentana10.continua:
					adds r6, r5												@de lo contrario r6(vectorOut[x]) = r6(vectorOut[x]) + r5(vectorIn[x]).
					ldrh r5, [r0, 2]!
					subs r9, 1												@Resto 1 a r9(ventana)
					b .asm_filtroVentana10.L2								@Salto incondicional a .asm_filtroVentana10.

			.asm_filtroVentana10.promediar:
				udiv r6, r6, r3
				strh r6, [r1], 2
				subs r10, 1
				b .asm_filtroVentana10.aumentaVect


			.asm_filtroVentana10.poner0:
				mov r12, r11
				subs r11, 1
				.asm_filtroVentana10.retrocedeVect:
					cmp r11, 0
					beq .asm_filtroVentana10.retrocedeVect.Fin
					ldrh r5, [r0, -2]!
					subs r11, 1
					b .asm_filtroVentana10.retrocedeVect
				.asm_filtroVentana10.retrocedeVect.Fin:
					mov r11, 0													@Si r11(nueva longitud) es mayor que r2(longitud real) entonces debo regregar al indice 0,
					b .asm_filtroVentana10.continua


		.asm_filtroVentana10.aumentaVect:
			mov r11, r12
			pop {r7}
			mov r7, r11
			subs r7, 1
			cmp r11, r2
			bls .asm_filtroVentana10.a
			mov r7, 1
			.asm_filtroVentana10.b:
				cmp r7, 0
				beq .asm_filtroVentana10.L1
				ldrh r5, [r0, 2]!
				subs r7, 1
				b .asm_filtroVentana10.b

			.asm_filtroVentana10.a:
				cmp r7, 0
				beq .asm_filtroVentana10.L1
				ldrh r5, [r0, -2]!
				subs r7, 1
				b .asm_filtroVentana10.a

		.asm_filtroVentana10.fin:
			bx lr															@finalizo la función



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
		mov r3, r1					@Registro utilizado para recorrer todo el vector, toma la longitud del vector e irá decrementando.
		mov r4, 0					@Registro temporal utilizado para almacenar la posición del vector con mayor número
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
			ble .asm_max.salgo		@R4>R10, salgo
			pop {r4}				@leo la pila y lo guardo en R4
			push {r5}				@Guardo en la pila el valor de R5
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
			bx lr					@Finaliza




