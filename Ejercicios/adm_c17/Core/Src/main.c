/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2022 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stdio.h"
#include "string.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "asm_func.h"
#include "c_func.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

ETH_TxPacketConfig TxConfig;
ETH_DMADescTypeDef  DMARxDscrTab[ETH_RX_DESC_CNT]; /* Ethernet Rx DMA Descriptors */
ETH_DMADescTypeDef  DMATxDscrTab[ETH_TX_DESC_CNT]; /* Ethernet Tx DMA Descriptors */

ETH_HandleTypeDef heth;
UART_HandleTypeDef huart3;

PCD_HandleTypeDef hpcd_USB_OTG_FS;


/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_ETH_Init(void);
static void MX_USART3_UART_Init(void);
static void MX_USB_OTG_FS_PCD_Init(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
void printVector_32(uint32_t * vector, uint32_t longitud);
void printVector_16(uint16_t * vector, uint16_t longitud);
static void PrivilegiosSVC (void)
{
    // Obtiene valor del registro de 32 bits del procesador llamado "control".
    // El registro guarda los siguientes estados:
    // bit 2: Uso de FPU en el contexto actual. Usado=1, no usado=0.
    // bit 1: Mapeo del stack pointer(sp). MSP=0, PSP=1.
    // bit 0: Modo de ejecucion en Thread. Privilegiado=0, No privilegiado=1.
    //        Recordar que este valor solo se usa en modo Thread. Las
    //        interrupciones siempre se ejecutan en modo Handler con total
    //        privilegio.
    uint32_t x = __get_CONTROL ();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    //__BKPT (0);

    x |= 1;
    // bit 0 a modo No privilegiado.
    __set_CONTROL (x);

    // En este punto se estaria ejecutando en modo No privilegiado.
    // Lectura del registro "control" para confirmar.
    x = __get_CONTROL ();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    //__BKPT (0);

    x &= ~1u;
    // Se intenta volver a modo Privilegiado (bit 0, valor 0).
    __set_CONTROL (x);

    // Confirma que esta operacion es ignorada por estar ejecutandose en modo
    // Thread no privilegiado.
    x = __get_CONTROL ();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    //__BKPT (0);

    // En este punto, ejecutando en modo Thread no privilegiado, la unica forma
    // de volver a modo privilegiado o de realizar cualquier cambio que requiera
    // modo privilegiado, es pidiendo ese servicio a un hipotetico sistema
    // opertivo de tiempo real.
    // Para esto se invoca por software a la interrupcion SVC (Supervisor Call)
    // utilizando la instruccion "svc".
    // No hay intrinsics para realizar esta tarea. Para utilizar la instruccion
    // es necesario implementar una funcion en assembler. Ver el archivo
    // asm_func.S.
    asm_svc ();

    // El sistema operativo (el handler de SVC) deberia haber devuelto el modo
    // de ejecucion de Thread a privilegiado (bit 0 en valor 0).
    x = __get_CONTROL ();

    // Fin del ejemplo de SVC
}
/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_ETH_Init();
  MX_USART3_UART_Init();
  MX_USB_OTG_FS_PCD_Init();
  /* USER CODE BEGIN 2 */
  PrivilegiosSVC ();

  const uint32_t Resultado = asm_sum (5, 3);
  /* USER CODE END 2 */

 /** Ejercicio 1:
   * Realizar una función que inicialice un vector con ceros. La función debe tener el siguiente prototipo
   */
  /*uint32_t myVector_32[10] = {};
  uint32_t myLongitud_32 = sizeof(myVector_32)/sizeof(int32_t);
  uint32_t myVector_16[10] = {};
  uint32_t myLongitud_16 = sizeof(myVector_16)/sizeof(int32_t);
  zeros_32(myVector_32, myLongitud_32);
  zeros_16(myVector_16, myLongitud_16);
  printVector_32(myVector_32, myLongitud_32);
  printVector_16(myVector_16, myLongitud_16);*/

 /** Ejercicio 2:
   * Realizar una función que realice el producto de un vector y un escalar (por ejemplo, podría servir para cambiar el nivel de amplitud de una señal).
   */
  /*uint32_t myVectorIn_32[5] = {1, 34, 5, 34, 12};
  uint32_t myLongitudIn_32 = sizeof(myVectorIn_32)/sizeof(uint32_t);
  uint32_t myVectorOut_32[5];
  uint32_t myLongitudOut_32 = sizeof(myVectorOut_32)/sizeof(uint32_t);
  zeros_32(myVectorOut_32, myLongitudOut_32);
  asm_productoEscalar32b (myVectorIn_32, myVectorOut_32, myLongitudIn_32, 2);
  //productoEscalar32 (myVectorIn_32, myVectorOut_32, myLongitudIn_32, 2);
  HAL_UART_Transmit (&huart3, (uint8_t *)"Vector de 32bits: ", 18, 50);
  printVector_32 (myVectorOut_32, myLongitudOut_32);*/

 /** Ejercicio 3:
   * Adapte la función del ejercicio 2 para realizar operaciones sobre vectores de 16 bits:
   */
  /*uint16_t myVectorIn_16[5] = {1, 34, 5, 34, 12};
  uint16_t myLongitudIn_16 = sizeof(myVectorIn_16)/sizeof(uint16_t);
  uint16_t myVectorOut_16[5];
  uint16_t myLongitudOut_16 = sizeof(myVectorOut_16)/sizeof(uint16_t);
  zeros_16(myVectorOut_16, myLongitudOut_16);
  asm_productoEscalar16b(myVectorIn_16, myVectorOut_16, myLongitudIn_16, 3);
  //productoEscalar16 (myVectorIn_16, myVectorOut_16, myLongitudIn_16, 3);
  HAL_UART_Transmit(&huart3, (uint8_t *)"Vector de 16bits: ", 18, 50);
  printVector_16(myVectorOut_16, myLongitudOut_16);*/

 /** Ejercicio 4:
   * Adapte la función del ejercicio 3 para saturar el resultado del producto a 12 bits:
   */
  /*uint16_t myVectorIn_16[5] = {1, 34, 5, 34, 12};
  uint16_t myLongitudIn_16 = sizeof(myVectorIn_16)/sizeof(uint16_t);
  uint16_t myVectorOut_16[5];
  uint16_t myLongitudOut_16 = sizeof(myVectorOut_16)/sizeof(uint16_t);
  zeros_16(myVectorOut_16, myLongitudOut_16);
  asm_productoEscalar12b (myVectorIn_16, myVectorOut_16, myLongitudIn_16, 5);
  //productoEscalar12 (myVectorIn_16, myVectorOut_16, myLongitudIn_16, 5);
  HAL_UART_Transmit(&huart3, (uint8_t *)"Vector de 12bits: ", 18, 50);
  printVector_16(myVectorOut_16, myLongitudOut_16);*/

 /** Ejercicio 5:
   * Realice una función que implemente un filtro de ventana móvil de 10 valores sobre un vector de muestras.
   */
  /*uint16_t myVectorIn_16[15] = {1, 34, 5, 34, 12, 44, 66, 33, 22, 11, 99, 77, 341, 557, 112};
  uint16_t myLongitudIn_16 = sizeof(myVectorIn_16)/sizeof(uint16_t);
  uint16_t myVectorOut_16[15];
  uint16_t myLongitudOut_16 = sizeof(myVectorOut_16)/sizeof(uint16_t);
  asm_zeros_16(myVectorOut_16, myLongitudOut_16);
  asm_filtroVentana10(myVectorIn_16, myVectorOut_16, myLongitudOut_16);
  //filtroVentana10(myVectorIn_16, myVectorOut_16, myLongitudIn_16);
  printVector_16(myVectorOut_16, myLongitudOut_16);*/


 /** Ejercicio 6:
   * Realizar una función que reciba un vector de números signados de 32 bits y los “empaquete” en otro vector de 16 bits.
   * La función deberá adecuar los valores de entrada a la nueva precisión.
   */
  /*int32_t myVectorIn_32[10] = {4291821568, 4291821468, 4191821568, 4291821518, 4293221568, 4291822168, 4296821568, 4291821563, 4391821568, 4291851568};
  uint32_t myLongitud_32 = sizeof(myVectorIn_32)/sizeof(int32_t);
  int16_t myVectorOut_16[10];
  uint16_t myLongitud_16 = sizeof(myVectorOut_16)/sizeof(uint16_t);
  asm_zeros_16 (myVectorOut_16, myLongitud_16);
  asm_pack32to16 (myVectorIn_32, myVectorOut_16, myLongitud_32);
  //pack32to16 (myVectorIn_32, myVectorOut_16, myLongitud_32);
  printVector_16 (myVectorOut_16, myLongitud_16);*/


 /** Ejercicio 7:
   * Realizar una función que reciba un vector de números signados de 32 bits y devuelva la posición del máximo del vector.
   */
  /*int32_t myVectorIn_32[11] = {10, 2, 6, 8, 200, 500, 43, 50, 33, 52, 312};
  uint32_t myLongitud_32 = sizeof(myVectorIn_32)/sizeof(int32_t);
  uint32_t value = asm_max(myVectorIn_32, myLongitud_32);
  //uint32_t value = max(myVectorIn_32, myLongitud_32);
  HAL_UART_Transmit(&huart3, (uint8_t *)"El indice con el valor maximo es: ", 34, 50);
  uint32_t bufferTx[10]={};
  sprintf(bufferTx, "%i", value);
  HAL_UART_Transmit(&huart3, bufferTx, sizeof(bufferTx)/sizeof(uint32_t), 50);
  HAL_UART_Transmit(&huart3, (uint8_t *)"\n\r", 2, 50);*/

  /** Ejercicio 8:
    * Realizar una función que reciba un vector de muestras signadas de 32 bits y lo decime descartando una cada N muestras.
    */
  /*int32_t myVectorIn_32[10] = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100};
  uint32_t myLongitud_32 = sizeof(myVectorIn_32)/sizeof(int32_t);
  uint16_t n = 3;
  uint32_t a = (myLongitud_32/n)*(n-1) + myLongitud_32%n;
  int32_t myVectorOut2[a];
  uint32_t myLongitud2 = sizeof(myVectorOut2)/sizeof(uint32_t);
  asm_downsampleM(myVectorIn_32, myVectorOut2, myLongitud_32, n);
  //downsampleM(myVectorIn_32, myVectorOut2, myLongitud_32, n);
  printVector_32(myVectorOut2, myLongitud2);*/


 /** Ejercicio 9:
   * Realizar una función que reciba un vector de muestras no signadas de 16 bits e invierta su orden.
   */
  /*uint16_t myVectorIn_16[6] = {1, 0, 10, 5, 34, 6};
  uint16_t myLongitud_16 = sizeof(myVectorIn_16)/sizeof(uint16_t);
  asm_invertir(myVectorIn_16, myLongitud_16);
  //invertir(myVectorIn_16, myLongitud_16);
  printVector_16(myVectorIn_16, myLongitud_16);*/

 /** Ejercicio 11:
   * Realizar una función que calcule la correlación entre dos vectores. Luego optimice utilizando instrucciones SIMD.
   */
  int16_t myVectorX[6] = {1, 0, 10, 5, 34, 6};
  int16_t myVectorY[6] = {14, 12, 1, 5, 21, 67};
  int32_t myVectorCorr[6];
  uint32_t myLongitud_32 = sizeof(myVectorCorr)/sizeof(int32_t);
  asm_zeros_32 (myVectorCorr, myLongitud_32);
  //asm_corr (myVectorIn_16, myLongitud_16);
  corr (myVectorX, myVectorY, myVectorCorr, myLongitud_32);

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    /* USER CODE END WHILE */


    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

void printVector_32(uint32_t * vector, uint32_t longitud){

	HAL_UART_Transmit(&huart3, (uint8_t *)"[", 1, 50);
	for(uint32_t i=0; i<longitud; i++){
		uint32_t bufferTx[12]={};
		sprintf(bufferTx, "%li", vector[i]);
		HAL_UART_Transmit(&huart3, bufferTx, sizeof(bufferTx)/sizeof(uint32_t), 50);
		if(i < longitud -1)
			HAL_UART_Transmit(&huart3, (uint8_t *)",", 1, 50);
	}
	HAL_UART_Transmit(&huart3, (uint8_t *)"] \n\r", 4, 50);
}


void printVector_16(uint16_t * vector, uint16_t longitud){

	HAL_UART_Transmit(&huart3, (uint8_t *)"[", 1, 50);
	for(uint16_t i=0; i<longitud; i++){
		uint16_t bufferTx[10]={};
		sprintf(bufferTx, "%i", vector[i]);
		HAL_UART_Transmit(&huart3, bufferTx, sizeof(bufferTx)/sizeof(uint16_t), 50);
		if(i < longitud -1)
			HAL_UART_Transmit(&huart3, (uint8_t *)",", 1, 50);
	}
	HAL_UART_Transmit(&huart3, (uint8_t *)"] \n\r", 4, 50);
}


/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 4;
  RCC_OscInitStruct.PLL.PLLN = 168;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 7;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
  {
    Error_Handler();
  }
}

/**
  * @brief ETH Initialization Function
  * @param None
  * @retval None
  */
static void MX_ETH_Init(void)
{

  /* USER CODE BEGIN ETH_Init 0 */

  /* USER CODE END ETH_Init 0 */

   static uint8_t MACAddr[6];

  /* USER CODE BEGIN ETH_Init 1 */

  /* USER CODE END ETH_Init 1 */
  heth.Instance = ETH;
  MACAddr[0] = 0x00;
  MACAddr[1] = 0x80;
  MACAddr[2] = 0xE1;
  MACAddr[3] = 0x00;
  MACAddr[4] = 0x00;
  MACAddr[5] = 0x00;
  heth.Init.MACAddr = &MACAddr[0];
  heth.Init.MediaInterface = HAL_ETH_RMII_MODE;
  heth.Init.TxDesc = DMATxDscrTab;
  heth.Init.RxDesc = DMARxDscrTab;
  heth.Init.RxBuffLen = 1524;

  /* USER CODE BEGIN MACADDRESS */

  /* USER CODE END MACADDRESS */

  if (HAL_ETH_Init(&heth) != HAL_OK)
  {
    Error_Handler();
  }

  memset(&TxConfig, 0 , sizeof(ETH_TxPacketConfig));
  TxConfig.Attributes = ETH_TX_PACKETS_FEATURES_CSUM | ETH_TX_PACKETS_FEATURES_CRCPAD;
  TxConfig.ChecksumCtrl = ETH_CHECKSUM_IPHDR_PAYLOAD_INSERT_PHDR_CALC;
  TxConfig.CRCPadCtrl = ETH_CRC_PAD_INSERT;
  /* USER CODE BEGIN ETH_Init 2 */

  /* USER CODE END ETH_Init 2 */

}

/**
  * @brief USART3 Initialization Function
  * @param None
  * @retval None
  */
static void MX_USART3_UART_Init(void)
{

  /* USER CODE BEGIN USART3_Init 0 */

  /* USER CODE END USART3_Init 0 */

  /* USER CODE BEGIN USART3_Init 1 */

  /* USER CODE END USART3_Init 1 */
  huart3.Instance = USART3;
  huart3.Init.BaudRate = 115200;
  huart3.Init.WordLength = UART_WORDLENGTH_8B;
  huart3.Init.StopBits = UART_STOPBITS_1;
  huart3.Init.Parity = UART_PARITY_NONE;
  huart3.Init.Mode = UART_MODE_TX_RX;
  huart3.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  huart3.Init.OverSampling = UART_OVERSAMPLING_16;
  if (HAL_UART_Init(&huart3) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USART3_Init 2 */

  /* USER CODE END USART3_Init 2 */

}

/**
  * @brief USB_OTG_FS Initialization Function
  * @param None
  * @retval None
  */
static void MX_USB_OTG_FS_PCD_Init(void)
{

  /* USER CODE BEGIN USB_OTG_FS_Init 0 */

  /* USER CODE END USB_OTG_FS_Init 0 */

  /* USER CODE BEGIN USB_OTG_FS_Init 1 */

  /* USER CODE END USB_OTG_FS_Init 1 */
  hpcd_USB_OTG_FS.Instance = USB_OTG_FS;
  hpcd_USB_OTG_FS.Init.dev_endpoints = 4;
  hpcd_USB_OTG_FS.Init.speed = PCD_SPEED_FULL;
  hpcd_USB_OTG_FS.Init.dma_enable = DISABLE;
  hpcd_USB_OTG_FS.Init.phy_itface = PCD_PHY_EMBEDDED;
  hpcd_USB_OTG_FS.Init.Sof_enable = ENABLE;
  hpcd_USB_OTG_FS.Init.low_power_enable = DISABLE;
  hpcd_USB_OTG_FS.Init.lpm_enable = DISABLE;
  hpcd_USB_OTG_FS.Init.vbus_sensing_enable = ENABLE;
  hpcd_USB_OTG_FS.Init.use_dedicated_ep1 = DISABLE;
  if (HAL_PCD_Init(&hpcd_USB_OTG_FS) != HAL_OK)
  {
    Error_Handler();
  }
  /* USER CODE BEGIN USB_OTG_FS_Init 2 */

  /* USER CODE END USB_OTG_FS_Init 2 */

}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void MX_GPIO_Init(void)
{
  GPIO_InitTypeDef GPIO_InitStruct = {0};

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOC_CLK_ENABLE();
  __HAL_RCC_GPIOH_CLK_ENABLE();
  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_GPIOB_CLK_ENABLE();
  __HAL_RCC_GPIOD_CLK_ENABLE();
  __HAL_RCC_GPIOG_CLK_ENABLE();

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOB, LD1_Pin|LD3_Pin|LD2_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(USB_PowerSwitchOn_GPIO_Port, USB_PowerSwitchOn_Pin, GPIO_PIN_RESET);

  /*Configure GPIO pin : USER_Btn_Pin */
  GPIO_InitStruct.Pin = USER_Btn_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_IT_RISING;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(USER_Btn_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pins : LD1_Pin LD3_Pin LD2_Pin */
  GPIO_InitStruct.Pin = LD1_Pin|LD3_Pin|LD2_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

  /*Configure GPIO pin : USB_PowerSwitchOn_Pin */
  GPIO_InitStruct.Pin = USB_PowerSwitchOn_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(USB_PowerSwitchOn_GPIO_Port, &GPIO_InitStruct);

  /*Configure GPIO pin : USB_OverCurrent_Pin */
  GPIO_InitStruct.Pin = USB_OverCurrent_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  HAL_GPIO_Init(USB_OverCurrent_GPIO_Port, &GPIO_InitStruct);

}

/* USER CODE BEGIN 4 */

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
