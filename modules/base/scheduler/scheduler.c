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
 *  Revision : $Id: scheduler.c,v 1.9.4.6 2009/11/08 17:33:14 zer0 Exp $
 *
 */

#include <string.h>
#include <stdio.h>
#include <inttypes.h>

#include <aversive/parts.h>
#include <aversive/pgmspace.h>
#include <aversive.h>

#include <scheduler.h>
#include <scheduler_private.h>
#include <scheduler_stats.h>
#include <scheduler_config.h>


/* this file is compiled for AVR version only */

/** declared in scheduler_host.c in case of host version */
struct event_t g_tab_event[SCHEDULER_NB_MAX_EVENT];

#ifdef CONFIG_MODULE_SCHEDULER_STATS
struct scheduler_stats sched_stats;
#endif

void scheduler_init(void)
{
	memset(g_tab_event, 0, sizeof(g_tab_event));

#ifdef CONFIG_MODULE_SCHEDULER_USE_TIMERS
	SCHEDULER_TIMER_REGISTER();
#endif

#ifdef CONFIG_MODULE_SCHEDULER_TIMER0
	/* activation of corresponding interrupt */
	TOIE0_REG |= (1<<TOIE0); /* TIMSK */

	TCNT0 = 0; 
	CS00_REG = SCHEDULER_CK; /* TCCR0 */
#endif
}


#ifdef CONFIG_MODULE_SCHEDULER_TIMER0
SIGNAL(SIG_OVERFLOW0)
{
	scheduler_interrupt();
}
#endif /* CONFIG_MODULE_SCHEDULER_USE_TIMERS */


void scheduler_stats_dump(void)
{
#ifdef CONFIG_MODULE_SCHEDULER_STATS
	uint8_t i;

	printf_P(PSTR("alloc_fails: %"PRIu32"\r\n"), sched_stats.alloc_fails);
	printf_P(PSTR("add_event: %"PRIu32"\r\n"), sched_stats.add_event);
	printf_P(PSTR("del_event: %"PRIu32"\r\n"), sched_stats.del_event);
	printf_P(PSTR("max_stacking: %"PRIu32"\r\n"), sched_stats.max_stacking);
	for (i=0; i<SCHEDULER_NB_MAX_EVENT; i++) {
		printf_P(PSTR("task_delayed[%d]: %"PRIu32"\r\n"), i,
			 sched_stats.task_delayed[i]);
	}
#endif /* CONFIG_MODULE_SCHEDULER_STATS */
}