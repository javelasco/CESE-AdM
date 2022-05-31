#pragma once

#include <stdint.h>


void asm_svc (void);
uint32_t asm_sum (uint32_t firstOperand, uint32_t secondOperand);
void asm_zeros (uint32_t * vector, uint32_t longitud);
void asm_productoEscalar32b (uint32_t * vectorIn, uint32_t * vectorOut, uint32_t longitud, uint32_t escalar);
void asm_productoEscalar16b (uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitud, uint16_t escalar);
void asm_productoEscalar12b (uint16_t * vectorIn, uint16_t * vectorOut, uint16_t longitud, uint16_t escalar);
