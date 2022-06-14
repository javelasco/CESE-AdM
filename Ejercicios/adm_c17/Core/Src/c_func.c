/*
 * c_func.c
 *
 *  Created on: May 24, 2022
 *      Author: jvelasco
 */

#include "c_func.h"

void zeros_32 (uint32_t *vector, uint32_t longitud){
	for(uint32_t i=0; i<longitud; i++){
		vector[i] = 0;
	}
}

void zeros_16 (uint16_t *vector, uint16_t longitud){
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

void filtroVentana10 (uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitudVectorIn){
	for(uint16_t i=0; i < longitudVectorIn; i++){
		uint16_t a=0, b=i;
		while(a<10){
			if(b+1 > longitudVectorIn){
				b=0;
			}

			vectorOut[i] = vectorOut[i] + vectorIn[b];
			a++;
			b++;
		}
		vectorOut[i] = vectorOut[i]/10;
	}
}

void pack32to16 (int32_t * vectorIn, int16_t * vectorOut, uint32_t longitudVectorIn){
	for(uint32_t i=0; i<longitudVectorIn; i++){
		vectorOut[i] = (vectorIn[i] & 0xFFFF0000)>>16;
	}
}

uint32_t max (int32_t * vectorIn, uint32_t longitudVectorIn){
	uint32_t temporal = 0;
	for(uint32_t i=0; i<longitudVectorIn; i++){
		if(i+1<longitudVectorIn){
			if(vectorIn[temporal] < vectorIn[i+1]){
				temporal = i+1;
			}
		}
	}
	return temporal;
}

void downsampleM (int32_t * vectorIn, int32_t * vectorOut, uint32_t longitudVectorIn, uint32_t N){
	uint32_t n=1;
	uint32_t j=0;

	for(uint32_t i=0; i<longitudVectorIn; i++){
		if(n < N){
			vectorOut[j] = vectorIn[i];
			j++;
			n++;
		}
		else{
			n=1;
		}
	}
}

void invertir (uint16_t * vector, uint16_t longitud){
	/*uint16_t j=0;
	uint16_t temporal[longitud];

	for(int16_t i=longitud-1; i>=0; i--){
		temporal[j] = vector[i];
		j++;
	}

	for(uint16_t i=0; i<longitud; i++){
		vector[i] = temporal[i];
	}*/

	uint16_t temporal;
	uint16_t j=0;
	for(int16_t i=longitud-1; i>=0; i--){
		if(i <= j){
			break;
		}
		else {
			temporal = vector[j];
			vector[j] = vector[i];
			vector[i] = temporal;
			j++;
		}
	}
}

void corr (int16_t * vectorX, int16_t * vectorY, int32_t * vectorCorr, uint32_t longitud){
	int32_t k=0;

	for (k; k<longitud; k++){
		for (int32_t i=0; i<longitud; i++){
			if((i-k) < 0){
				vectorCorr[k] =+ vectorX[i] * 0;
			}
			else {
				vectorCorr[k] += vectorX[i] * vectorY[i-k];
			}
		}
	}
}
