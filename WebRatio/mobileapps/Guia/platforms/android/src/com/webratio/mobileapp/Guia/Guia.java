
package com.webratio.mobileapp.Guia;

import android.os.Bundle;
import org.apache.cordova.*;

public class Guia extends CordovaActivity 
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        super.init();
        // Set by <content src="index.html" /> in config.xml
        super.loadUrl(Config.getStartUrl());
    }
}