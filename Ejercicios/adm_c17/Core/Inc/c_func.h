 /* c_func.h
 *
 *  Created on: May 24, 2022
 *      Author: jvelasco
 */

#include <stdio.h>

#ifndef INC_C_FUNC_H_
#define INC_C_FUNC_H_

/**
  *	@brief	Inicializa un vector de 32 bits con ceros
  * @param	vector: puntero del vector a inicializar
  * @param	longitud: cantidad de elementos del vector
  * @retval	none
  */
void zeros_32 (uint32_t *vector, uint32_t longitud);
void zeros_16 (uint16_t *vector, uint16_t longitud);


/**
  *	@brief	Multiplica un vector de 32 bits con un escalon de 32 bits
  * @param	vectorIn: puntero del vector de entrada
  * @param	vectorOut: puntero del vector de salida
  * @param	longitud: cantidad de elementos del vector de entrada
  * @param	escalar: escalon que multiplicará al vector de entrada
  * @retval	none
  */
void productoEscalar32 (uint32_t vectorIn[], uint32_t vectorOut[], uint32_t longitud, uint32_t escalar);

/**
  *	@brief	Multiplica un vector de 16 bits con un escalon de 16 bits
  * @param	vectorIn: puntero del vector de entrada
  * @param	vectorOut: puntero del vector de salida
  * @param	longitud: cantidad de elementos del vector de entrada
  * @param	escalar: escalon que multiplicará al vector de entrada
  * @retval	none
  */
void productoEscalar16 (uint16_t vectorIn[], uint16_t vectorOut[], uint16_t longitud, uint16_t escalar);

/**
  *	@brief	Multiplica un vector de 12 bits con un escalon de 12 bits
  * @param	vectorIn: puntero del vector de entrada
  * @param	vectorOut: puntero del vector de salida
  * @param	longitud: cantidad de elementos del vector de entrada
  * @param	escalar: escalon que multiplicará al vector de entrada
  * @retval	none
  */
void productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitud, uint16_t escalar);

/**
  *	@brief	Realice una función que implemente un filtro de ventana móvil de 10 valores sobre un vector de muestras.
  * @param	vectorIn: puntero del vector de entrada
  * @param	vectorOut: puntero del vector de salida
  * @param	longitudVectorIn: cantidad de elementos del vector de entrada
  * @retval	none
  */
void filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitudVectorIn);

/**
  *	@brief	Realizar una función que reciba un vector de números signados de 32 bits y los “empaquete” en otro vector de 16 bits.
  *	La función deberá adecuar los valores de entrada a la nueva precisión.
  * @param	vectorIn: puntero del vector de entrada
  * @param	vectorOut: puntero del vector de salida
  * @param	longitudVectorIn: cantidad de elementos.
  * @retval	none
  */
void pack32to16 (int32_t * vectorIn, int16_t *vectorOut, uint32_t longitudVectorIn);

/**
  *	@brief	Realizar una función que reciba un vector de números signados de 32 bits y los “empaquete” en otro vector de 16 bits.
  *	La función deberá adecuar los valores de entrada a la nueva precisión.
  * @param	vectorIn: puntero del vector de entrada
  * @param	longitudVectorIn: cantidad de elementos.
  * @retval	la posición del vector con el valor mas alto.
  */
uint32_t max (int32_t * vectorIn, uint32_t longitudVectorIn);

/**
  *	@brief	Realizar una función que reciba un vector de números signados de 32 bits y los “empaquete” en otro vector de 16 bits.
  *	La función deberá adecuar los valores de entrada a la nueva precisión.
  * @param	vectorIn: puntero del vector de entrada
  * @param	vectorOut: puntero del vector de salida
  * @param	longitudVectorIn: cantidad de elementos.
  * @retval	none
  */
void downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitudVectorIn, uint32_t N);

/**
  *	@brief	Realizar una función que reciba un vector de números signados de 32 bits y los “empaquete” en otro vector de 16 bits.
  *	La función deberá adecuar los valores de entrada a la nueva precisión.
  * @param	vector: puntero del vector de entrada
  * @param	longitud: cantidad de elementos.
  * @retval	none
  */
void invertir (uint16_t * vector, uint16_t longitud);

/**
  *	@brief
  *
  * @param
  * @param
  * @retval
  */
void correla (int16_t * vectorX, int16_t * vectorY, int32_t * vectorCorr, uint32_t longitud);

#endif /* INC_C_FUNC_H_ */
