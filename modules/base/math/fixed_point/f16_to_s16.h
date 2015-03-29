/*  
 *  Copyright Droids Corporation, Microb Technology, Eirbot (2005)
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
 *  Revision : $Id: f16_to_s16.h,v 1.3.6.2 2008-05-10 15:06:26 zer0 Exp $
 *
 */

#ifndef _F16_TO_S16_H_
#define _F16_TO_S16_H_

#ifdef HOST_VERSION
/* not optimized, but will work with any endianness */
static inline int16_t f16_to_s16(f16 f)
{
	return ( ((int16_t)(f.f16_integer))<<8 ) |  ((int16_t)(f.f16_decimal));
}

#else
/* only for AVR, faster */
static inline int16_t f16_to_s16(f16 f)
{
	return f.u.s16;
}

#endif


#endif
