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
void zeros(uint32_t *vector, uint32_t longitud);

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

#endif /* INC_C_FUNC_H_ */
