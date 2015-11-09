/*
 * Copyright (C) 2015 The CyanogenMod Project
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

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Message;
import android.os.Parcel;
import android.os.SystemProperties;
import android.util.Log;

import com.android.internal.telephony.RILConstants;

/**
 * Custom Qualcomm RIL for G4
 *
 * {@hide}
 */
public class LgeLteRIL extends RIL implements CommandsInterface {

    static final String LOG_TAG = "LgeLteRIL";

    public LgeLteRIL(Context context, int preferredNetworkType,
            int cdmaSubscription, Integer instanceId) {
        this(context, preferredNetworkType, cdmaSubscription);
        mQANElements = 5;
    }

    public LgeLteRIL(Context context, int networkMode, int cdmaSubscription) {
        super(context, networkMode, cdmaSubscription);
    }

}
