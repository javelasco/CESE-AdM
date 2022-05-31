/*
 * c_func.c
 *
 *  Created on: May 24, 2022
 *      Author: jvelasco
 */

#include "c_func.h"

void zeros (uint32_t *vector, uint32_t longitud){
	for(uint32_t i=0; i<longitud; i++){
		vector[i] = 0;
	}
}


void productoEscalar32 (uint32_t vectorIn[], uint32_t vectorOut[], uint32_t longitud, uint32_t escalar){
	//uint32_t array[] = {0,0,0,0,0};
	for(uint32_t i=0; i<longitud; i++){
		uint32_t a = escalar;
		while(a > 0){
			if(vectorOut[i] < (4294967295 - vectorIn[i])){
				vectorOut[i] += vectorIn[i];
				//array[i] = vectorOut[i];
				a--;
			}
			else {
				vectorOut[i] = 4294967295;
				//array[i] = 4294967295;
				break;
			}
		}
	}
}

void productoEscalar16 (uint16_t vectorIn[], uint16_t vectorOut[], uint16_t longitud, uint16_t escalar){
	//uint16_t array[] = {0,0,0,0,0};
	for(uint16_t i=0; i<longitud; i++){
		uint16_t a = escalar;
		while(a > 0){
			if(vectorOut[i] < (65535 - vectorIn[i])){
				vectorOut[i] += vectorIn[i];
				//array[i] = vectorOut_16[i];
				a--;
			}
			else {
				vectorOut[i] = 65535;
				//array[i] = 65535;
				break;
			}
		}
	}
}

void productoEscalar12 (uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitud, uint16_t escalar){
	//uint16_t array[] = {0,0,0,0,0};
	for(uint16_t i=0; i<longitud; i++){
		uint16_t a = escalar;
		while(a > 0){
			if(vectorOut[i] < (4095 - vectorIn[i])){
				vectorOut[i] += vectorIn[i];
				//array[i] = vectorOut_16[i];
				a--;
			}
			else {
				vectorOut[i] = 4095;
				//array[i] = 65535;
				break;
			}
		}
	}
}
