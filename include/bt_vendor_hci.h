/******************************************************************************
 *
 *  Copyright (C) 2009-2012 Broadcom Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at:
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 ******************************************************************************/

/******************************************************************************
 *
 *  Filename:      bt_vendor_hci.h
 *
 *  Description:   A wrapper header file of bt_vendor_lib.h
 *
 *                 Contains definitions specific for interfacing with Broadcom
 *                 Bluetooth chipsets
 *
 ******************************************************************************/

#ifndef BT_VENDOR_HCI_H
#define BT_VENDOR_HCI_H

#include "bt_vendor_lib.h"
#include "vnd_buildcfg.h"

/******************************************************************************
**  Constants & Macros
******************************************************************************/

#ifndef FALSE
#define FALSE  0
#endif

#ifndef TRUE
#define TRUE   (!FALSE)
#endif

/* Run-time configuration file */
#ifndef VENDOR_LIB_CONF_FILE
#define VENDOR_LIB_CONF_FILE "/etc/bluetooth/bt_vendor.conf"
#endif

/* The Bluetooth Device Aaddress source switch:
 *
 * -FALSE- (default value)
 *  Get the factory BDADDR from device's file system. Normally the BDADDR is
 *  stored in the location pointed by the PROPERTY_BT_BDADDR_PATH (defined in
 *  btif_common.h file) property.
 *
 * -TRUE-
 *  If the Bluetooth Controller has equipped with a non-volatile memory, the
 *  factory BDADDR can be stored in there and retrieved by the stack while 
 *  enabling BT.
 */
#ifndef USE_CONTROLLER_BDADDR
#define USE_CONTROLLER_BDADDR   FALSE
#endif


/******************************************************************************
**  Extern variables and functions
******************************************************************************/

extern bt_vendor_callbacks_t *bt_vendor_cbacks;

/*******************************************************************************
**
** Function        userial_set_dev
**
** Description     Configure HCI device to use
**
** Returns         0 : Success
**                 Otherwise : Fail
**
*******************************************************************************/
extern int userial_set_dev(char *p_conf_name, char *p_conf_value, int param);
 
#endif /* BT_VENDOR_ATHEROS_H */

