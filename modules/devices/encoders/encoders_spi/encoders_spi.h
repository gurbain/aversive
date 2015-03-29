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
 *  Revision : $Id: encoders_spi.h,v 1.1.2.1 2009-02-20 20:24:21 zer0 Exp $
 *
 *  Olivier MATZ <zer0@droids-corp.org>
 */

#ifndef _ENCODERS_SPI_H_
#define _ENCODERS_SPI_H_

#define XY   37
#define OE   36 // Active LOW
#define EN1  35
#define EN2  34
#define SEL1 33
#define SEL2 32
#define RSTX 31 // Active LOW
#define RSTY 30



/** 
 * Initialisation of encoders, variables
 */
void encoders_spi_init(void);

/** 
 * Update encoders values, need to be done quite often
 */
void encoders_spi_manage(void *dummy);

/** 
 * Extract encoder value.
 */
int32_t encoders_spi_get_value(void *encoder);

/** 
 * Set an encoder value
 */
void encoders_spi_set_value(void *encoder, int32_t val);

#endif
