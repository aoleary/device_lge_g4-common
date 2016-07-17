/* bson.c */

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
#define LOG_TAG "cpucontrol_android"
#include "cpucontrol.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <cutils/log.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

static void millisleep(unsigned long millisec) {
   struct timespec req = {
      .tv_sec = 0,
      .tv_nsec = millisec * 1000000L
   };
   while(nanosleep(&req,&req)==-1) {
      continue;
   }
}

char *read_f(char *f)
{
    char size[64];
    int fd, ret;
    fd = open(f, O_RDONLY);
    if (fd < 0)return NULL;
    ret = read(fd, size, sizeof(size));
    close(fd);
    if (ret <= 0)return NULL;
    return size;
} 
void write_f(char *f,char *data)
{
    int fd, ret;
    fd = open(f,  O_RDWR);
    if (fd < 0)return;
    ret = write(fd, data, sizeof(data));
    close(fd);
} 


int cpu[6];
int timeout;



void get_online()
{
    char file[128];
    int i=0;
    for(i=0;i<6;i++)
    {
        sprintf(file,"/sys/devices/system/cpu/cpu%d/online",i);
        cpu[i]=atoi(read_f(file));
    }
}


void disable()
{
char file[128];
int i=0;
int n;

    if(read_f(CPU_FILE) != NULL) 
    {
        if(atoi(read_f(CPU_FILE))<=200000)n=0;
        else n=1;
            for(i=5;i>n;i--)
            {
                if(cpu[i]==1)
                {
                    sprintf(file,"/sys/devices/system/cpu/cpu%d/online",i);
                    write_f(file,"0");
                    cpu[i]=0;
                    break;
                }
            }
    }
    else
        ALOGE("CpuControl : read_f(CPU_FILE) == NULL");
}


void enable()
{
    char file[128];
    int i=0;
    for(i=1;i<6;i++)
    {
        if(cpu[i]==0)
        {
            sprintf(file,"/sys/devices/system/cpu/cpu%d/online",i);
            write_f(file,"1");
            cpu[i]=1;
            break;
        }
    }
}


int main()
{
  char *mode;
  timeout=300;
  while(1)
  {
    mode=read_f(STATUS_FILE);
    if(mode[0]=='s')
      timeout=500;
    if(mode[0]=='a')
      timeout=300;
    get_online();
    if(read_f(CPU_FILE) != NULL)
      {
	if(atoi(read_f(CPU_FILE))<=400000)
	  disable();
	else
	  enable();
	millisleep(timeout);
      }
    else 
	return -1;
  }

return 1;

}
