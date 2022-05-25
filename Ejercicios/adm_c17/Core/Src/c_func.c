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
