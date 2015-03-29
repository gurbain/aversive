/*  
 *  Copyright Droids Corporation (2009)
 * 
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *  Revision : $Id: encoders_spi.c,v 1.1.2.3 2009-04-07 20:00:46 zer0 Exp $
 *
 *  Olivier MATZ <zer0@droids-corp.org>
 */

/* This modules handles encoders: values are read through a SPI
 * interface. Basically, frames are formatted with 4 words of 16 bits,
 * describing the values of the 4 encoders. */

#ifndef HOST_VERSION

#include <string.h>

#include <aversive.h>
#include <aversive/parts.h>

#include <spi.h>

#include <encoders_spi.h>
#include <encoders_spi_config.h>


#include "../../../../../Arduino.h"


static int32_t  g_encoders_spi_values[ENCODERS_SPI_NUMBER];
/* static  */int32_t g_encoders_spi_previous[ENCODERS_SPI_NUMBER];


/* Initialisation of encoders, variables */
void encoders_spi_init(void)
{
  init();   // initialisation timer arduino si on utilise la fonction delay();
  // Initialisation
    
   DDRA = B00000000;   // sets Arduino Mega (ATMEL ATMEGA) Digital pins 22(PORTA0) to 29(PORTA7) as inputs from HCTL-2032 - D0 to D7
    
   pinMode(XY,   OUTPUT);
   pinMode(OE,   OUTPUT);
   pinMode(EN1,  OUTPUT);
   pinMode(EN2,  OUTPUT);
   pinMode(SEL1, OUTPUT);
   pinMode(SEL2, OUTPUT);
   pinMode(RSTX, OUTPUT);
   pinMode(RSTY, OUTPUT);
   
   // Communicates with a HCTL-2032 IC to set the count mode
   // see Avago/Agilent/HP HCTL-2032 PDF for details
   // Uniquement le mode 4x car les autres modes offrent une précision moindre (useless)
   digitalWrite(EN1, HIGH);
   digitalWrite(EN2, LOW);
   
   // A vérifier (voir datasheet) : 
   digitalWrite(XY, LOW);
   digitalWrite(OE, HIGH); // A quoi sert OE ?
   digitalWrite(SEL1, LOW);
   digitalWrite(SEL2, HIGH);

   
   // Reset encoder 1
   digitalWrite(RSTX, LOW);
   delayMicroseconds(1);
   digitalWrite(RSTX, HIGH);
   delayMicroseconds(1);
   // Reset encodeur 2
   digitalWrite(RSTY, LOW);
   delayMicroseconds(1);
   digitalWrite(RSTY, HIGH);
   delayMicroseconds(1);
   
   // Fin Initialisation
   
   
	memset(g_encoders_spi_previous, 0, sizeof(g_encoders_spi_previous));
	encoders_spi_manage(NULL);
	memset(g_encoders_spi_values, 0, sizeof(g_encoders_spi_values));

}


/* Update encoders values */
void encoders_spi_manage(__attribute__((unused)) void *dummy)
{
 // YOLO

}



/* Extract encoder value */
int32_t encoders_spi_get_value(void *encoder)
{
	int32_t value;
	uint8_t flags;
	int32_t busByte;
	int32_t count;
	int32_t diff;


   digitalWrite(XY,   LOW); // Selection de l'encodeur 1 ou 2 (ici : 1)
   digitalWrite(OE,   LOW); // Début lécture ??
   digitalWrite(SEL1, LOW);
   digitalWrite(SEL2, HIGH); // Pour lecture octet poid faible

   delayMicroseconds(1);
   busByte = PINA;
   count   = busByte;
   count <<= 8;

   digitalWrite(SEL1, HIGH);
   digitalWrite(SEL2, HIGH);
   delayMicroseconds(1);
   busByte = PINA;
   count  += busByte;
   count <<= 8;

   digitalWrite(SEL1, LOW);
   digitalWrite(SEL2, LOW);
   delayMicroseconds(1);
   busByte = PINA;
   count  += busByte;
   count <<= 8;

   digitalWrite(SEL1, HIGH);
   digitalWrite(SEL2, LOW);
   delayMicroseconds(1);
   busByte = PINA;
   count  += busByte;
   
   digitalWrite(OE,  HIGH); // Fin de lécture ??
       

   diff = count - g_encoders_spi_previous[0];
   g_encoders_spi_previous[0] = count;
   IRQ_LOCK(flags);
   g_encoders_spi_values[0] += diff;
   IRQ_UNLOCK(flags);
		

	IRQ_LOCK(flags);
	value = g_encoders_spi_values[(int)encoder];
	IRQ_UNLOCK(flags);
	return value;
}

/* Set an encoder value */
void encoders_spi_set_value(void *encoder, int32_t val)
{
	uint8_t flags;

	IRQ_LOCK(flags);
	g_encoders_spi_values[(int)encoder] = val;
	IRQ_UNLOCK(flags);
}

#endif
