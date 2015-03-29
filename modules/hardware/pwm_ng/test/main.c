/*  
 *  Copyright Droids Corporation, Microb Technology, Eirbot (2009)
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
 *  Revision : $Id: main.c,v 1.1.2.1 2009-01-23 23:04:16 zer0 Exp $
 *
 */

#include <pwm_ng.h>

/* this program tests pwm output */

int main(void)
{
	
	
	
	struct pwm_ng pwm1_4A;
	struct pwm_ng pwm2_4B;

	
	PWM_NG_TIMER_16BITS_INIT(4, TIMER_16_MODE_PWM_PC_10, TIMER4_PRESCALER_DIV_8);
	
	PWM_NG_TIMER_16BITS_INIT(1, TIMER_16_MODE_PWM_PC_10, TIMER1_PRESCALER_DIV_8);

	PWM_NG_INIT16(&pwm1_4A, 1, A, 10,PWM_NG_MODE_SPECIAL_SIGN | PWM_NG_MODE_SIGNED, &PORTA, 4);
	PWM_NG_INIT16(&pwm2_4B, 1, B, 10,PWM_NG_MODE_SPECIAL_SIGN | PWM_NG_MODE_SIGNED, &PORTA, 5);

	pwm_ng_set(&pwm1_4A, 1000);
	pwm_ng_set(&pwm2_4B, -2000);
	

	while(1);
	return 0;
}


