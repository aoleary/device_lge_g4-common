/*
 * Copyright (C) 2018 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG  "WIFI_BT_MAC"
#include <utils/Log.h>

#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

// guid, uid
#include <pwd.h>
#include <grp.h>

// define all paths and files
#define MISC_PARTITION "/dev/block/bootdevice/by-name/misc"

#define WIFI_HEX_ADDR 0x3000
#define WIFI_DATA_PATH "/data/misc/wifi"
#define WIFI_CONFIG_FILE WIFI_DATA_PATH "/config"

#define BT_HEX_ADDR 0x4000
#define BT_DATA_PATH "/data/misc/bluetooth"
#define BT_CONFIG_FILE BT_DATA_PATH "/bdaddr"

int blank(int fd, int offset);

struct stat st = {0};

/* Read plain address from misc partition and set the Wifi and BT mac addresses accordingly.
   If that fails generate a MAC and use that one.
*/

int main() {
    int fd1, fd2;
    char macbyte;
    char macbuf[3];
    int i;

    errno = 0;

    uint8_t btMac[6];
    uint8_t wifiMac[6];
    char bt_macaddr[20];
    char wifi_macaddr[20];

    uid_t          uid;
    gid_t          gid;
    struct passwd *pwd;
    struct group  *grp;

    fd1 = open(MISC_PARTITION, O_RDONLY);

    ALOGI("Starting hwaddrs mac handler\n");

    // WiFi mac handling
    if (stat(WIFI_CONFIG_FILE, &st) == -1) {
	if (stat(WIFI_DATA_PATH, &st) == -1) {
	    pwd = getpwnam("wifi");
	    uid = pwd->pw_uid;
	    grp = getgrnam("wifi");
	    gid = grp->gr_gid;

	    if (mkdir(WIFI_DATA_PATH, 0775) < 0) {
		ALOGE("%s: Error creating %s ! Will not continue! Returncode: %i", __func__, WIFI_DATA_PATH, errno);
		return errno;
	    }
	    if (chown(WIFI_DATA_PATH, uid, gid) < 0) {
		ALOGW("%s: Created missing WiFi data path (%s). Owned by %i:%i.", __func__, WIFI_DATA_PATH, uid, gid);
		return errno;
	    }
	}

	fd2 = open(WIFI_CONFIG_FILE, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
	write(fd2, "cur_etheraddr=", 14);

	if (!blank(fd1, WIFI_HEX_ADDR)) {

	    for(i = 0; i < 6; i++) {
		lseek(fd1, 0x3000 + i, SEEK_SET);
		lseek(fd2, 0, SEEK_END);
		read(fd1, &macbyte, 1);
		sprintf(macbuf, "%02x", macbyte);
		write(fd2, &macbuf, 2);
		if(i != 5) write(fd2, ":", 1);
	    }
	    write(fd2, "\n", 1);
	    ALOGI("%s: WiFi mac parsed from misc partition", __func__);
	} else {
	    srand(time(NULL)+123456789);
	    memset(wifi_macaddr, 0, 20);

	    // LG's MAC range is: 00:34:DA:00:00:00 - 00:34:DA:FF:FF:FF
	    wifiMac[0] = 0x00;
	    wifiMac[1] = 0x34;
	    wifiMac[2] = 0xDA;
	    wifiMac[3] = (uint8_t) rand() % 256;
	    wifiMac[4] = (uint8_t) rand() % 256;
	    wifiMac[5] = (uint8_t) rand() % 256;

	    snprintf(wifi_macaddr, sizeof(wifi_macaddr), "%02X:%02X:%02X:%02X:%02X:%02X\n",
		wifiMac[0], wifiMac[1], wifiMac[2], wifiMac[3], wifiMac[4], wifiMac[5]);

	    ALOGE("%s: The misc partition is corrupt / missing MAC. Generated a random WiFi mac: %s", __func__, wifi_macaddr);
	    write(fd2, wifi_macaddr, strlen(wifi_macaddr));
	    write(fd2, "\n", 1);
	}
	close(fd2); // close config
    } else {
	ALOGI("%s: MAC for WiFi already defined (%s)", __func__, WIFI_CONFIG_FILE);
    }

    // Bluetooth mac handling
    if (stat(BT_CONFIG_FILE, &st) == -1) {
	if (stat(BT_DATA_PATH, &st) == -1) {
	    pwd = getpwnam("bluetooth");
	    uid = pwd->pw_uid;
	    grp = getgrnam("bluetooth");
	    gid = grp->gr_gid;

	    if (mkdir(BT_DATA_PATH, 0775) < 0) {
		ALOGE("%s: Error creating %s ! Will not continue! Returncode: %i", __func__, BT_DATA_PATH, errno);
		return errno;
	    }
	    if (chown(BT_DATA_PATH, uid, gid) < 0) {
		ALOGW("%s: Created missing WiFi data path (%s). Owned by %i:%i.", __func__, BT_DATA_PATH, uid, gid);
		return errno;
	    }
	    ALOGW("%s: Created missing Bluetooth data path (%s). Owned by %i:%i.", __func__, BT_DATA_PATH, uid, gid);
	}

	fd2 = open(BT_CONFIG_FILE, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);

	if (!blank(fd1, BT_HEX_ADDR)) {
	    for(i = 0; i < 6; i++) {
		lseek(fd1, 0x4000 + i, SEEK_SET);
		lseek(fd2, 0, SEEK_END);
		read(fd1, &macbyte, 1);
		sprintf(macbuf, "%02x", macbyte);
		write(fd2, &macbuf, 2);
		if(i != 5) write(fd2, ":", 1);
	    }
	    ALOGI("%s: Bluetooth mac parsed from misc partition", __func__);
	} else {
	    srand(time(NULL));
	    memset(bt_macaddr, 0, 20);
	    // LG's MAC range is: 00:34:DA:00:00:00 - 00:34:DA:FF:FF:FF
	    btMac[0] = 0x00;
	    btMac[1] = 0x34;
	    btMac[2] = 0xDA;
	    btMac[3] = (uint8_t) rand() % 256;
	    btMac[4] = (uint8_t) rand() % 256;
	    btMac[5] = (uint8_t) rand() % 256;

	    snprintf(bt_macaddr, sizeof(bt_macaddr), "%02X:%02X:%02X:%02X:%02X:%02X\n",
		btMac[0], btMac[1], btMac[2], btMac[3], btMac[4], btMac[5]);

	    ALOGE("%s: The misc partition is corrupt / missing MAC. Generated a random Bluetooth mac: %s", __func__, bt_macaddr);
	    write(fd2, bt_macaddr, strlen(bt_macaddr));
	}
	close(fd2); // close bdaddr
    } else {
	ALOGI("%s: MAC for Bluetooth already defined (%s)", __func__, BT_CONFIG_FILE);
    }
    close(fd1); // close misc
    return 0;
}

int blank(int fd, int offset)
{
    char macbyte;
    int i, count = 0;

    for(i = 0; i < 6; i++) {
        lseek(fd, offset + i, SEEK_SET);
        read(fd, &macbyte, 1);

        if (!macbyte)
            count++;
        else
            count = 0;

        if (count > 2)
            return 1;
    }

    return 0;
}
