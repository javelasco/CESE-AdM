/*
 * c_func.c
 *
 *  Created on: May 24, 2022
 *      Author: jvelasco
 */


#include <stdio.h>
#include "main.h"

void zeros (uint32_t *vector, uint32_t longitud){
	for(uint32_t i=0; i<longitud; i++){
		vector[i] = 0;
	}
}


void productoEscalar32 (uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar){
    for(u_int32_t i=0; i<longitud; i++){
        vectorOut[i] = vectorIn[i] * escalar;
    }
}
