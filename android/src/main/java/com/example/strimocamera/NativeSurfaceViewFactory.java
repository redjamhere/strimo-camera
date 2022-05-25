package com.example.strimocamera;

import android.content.Context;

import androidx.annotation.NonNull;

import com.example.strimocamera.NativeSurfaceView;

import org.jetbrains.annotations.NotNull;

import io.flutter.Log;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;

class NativeSurfaceViewFactory extends PlatformViewFactory {

    private NativeSurfaceView view;
    private DartMessenger dartMessenger;

    public NativeSurfaceViewFactory(DartMessenger dartMessenger) {
        super(StandardMessageCodec.INSTANCE);
        this.dartMessenger = dartMessenger;
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @NonNull Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        view = new NativeSurfaceView(context, id, creationParams, dartMessenger);
        return view;
    }

    public void switchCamera() {
        view.switchCamera();
    }

    public void startStream(String url) {
        view.startStream(url);
    }

    public void stopStream() {
        view.stopStream();
    }

    public void enableFlashLight() throws Exception{
        view.enableFlashLight();
    }

    public void disableFlashLight() {
        view.disableFlashLight();
    }

}
