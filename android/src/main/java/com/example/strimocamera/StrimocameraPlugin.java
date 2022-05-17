package com.example.strimocamera;

import android.app.Activity;
import android.content.Context;
import android.graphics.SurfaceTexture;
import android.hardware.camera2.CaptureRequest;
import android.opengl.GLES20;
import android.opengl.GLUtils;
import android.os.Build;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.TextureView;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.collection.LongSparseArray;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterSurfaceView;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.renderer.FlutterRenderer;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;

//rtmp
import com.pedro.encoder.input.gl.SpriteGestureController;
import com.pedro.encoder.input.gl.render.CameraRender;
import com.pedro.rtmp.utils.ConnectCheckerRtmp;
import com.pedro.rtplibrary.rtmp.RtmpCamera1;
import com.pedro.rtplibrary.rtmp.RtmpCamera2;
import com.pedro.rtplibrary.view.OpenGlView;
import com.pedro.rtplibrary.view.OpenGlViewBase;

import java.util.Map;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLContext;
import javax.microedition.khronos.egl.EGLDisplay;
import javax.microedition.khronos.egl.EGLSurface;

/** StrimocameraPlugin */
@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
public class StrimocameraPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private NativeSurfaceViewFactory nativeSurfaceViewFactory;
  private FlutterPluginBinding binding;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    nativeSurfaceViewFactory= new NativeSurfaceViewFactory();
    flutterPluginBinding
            .getPlatformViewRegistry()
            .registerViewFactory("<platform-view-type>", nativeSurfaceViewFactory);
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "strimocamera");
    channel.setMethodCallHandler(this);
    this.binding = flutterPluginBinding;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result){
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("startStream")) {
      try {
        nativeSurfaceViewFactory.startStream(call.argument("url"));
        result.success(true);
      } catch (Exception e) {
        result.success(false);
      }
    } else if (call.method.equals("switchCamera")) {
      nativeSurfaceViewFactory.switchCamera();
    } else if (call.method.equals("stopStream")) {
      nativeSurfaceViewFactory.stopStream();
    } else if (call.method.equals("enableFlashLight")) {
      try {
        nativeSurfaceViewFactory.enableFlashLight();
        result.success(true);
      } catch (Exception e) {
        result.success(false);
        Log.i("STRIMOCAMERA", "FLASHLIGHT NOT ENABLED");
      }
    } else if (call.method.equals("disableFlashLight")) {
      nativeSurfaceViewFactory.disableFlashLight();
      result.success(false);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

}

