/* bson.h */

/*    Copyright 2009, 2010 10gen Inc.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#ifndef _CPUCONTROL_H_
#define _CPUCONTROL_H_


#define STATUS_FILE "/sys/class/graphics/fb0/mdp/power/runtime_status"
#define CPU_FILE "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq"



#define ERROR -1
#define SLEEP 0
#define WAKE 1




static void millisleep(unsigned long millisec);
char *read_f(char *f);

#endif
