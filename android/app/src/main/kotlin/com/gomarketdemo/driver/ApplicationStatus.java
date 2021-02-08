package com.gomarketdemo.driver;

import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

public class ApplicationStatus extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {

    @Override
    public void onCreate() {
        super.onCreate();
        FirebaseOptions options = new FirebaseOptions.Builder()
                .setApplicationId("com.gomarketdemo.driver") // Required for Analytics.
                .setProjectId("gomarketdemo") // Required for Firebase Installations.
                .setApiKey("AIzaSyABZbNP_hhpEAV68wieDiO3jOSBJVZKvGI") // Required for Auth.
                .build();
        FirebaseApp.initializeApp(this,options,"gomarketdemo");
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        FirebaseCloudMessagingPluginRegistrant.registerWith(registry);
    }
}
