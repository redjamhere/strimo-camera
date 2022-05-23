package com.example.strimocamera;

import android.content.Context;
import android.graphics.Color;
import android.graphics.PointF;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

// rtmp

import com.pedro.encoder.input.gl.SpriteGestureController;
import com.pedro.encoder.input.gl.render.filters.AnalogTVFilterRender;
import com.pedro.encoder.input.gl.render.filters.AndroidViewFilterRender;
import com.pedro.encoder.input.gl.render.filters.BasicDeformationFilterRender;
import com.pedro.encoder.input.gl.render.filters.BeautyFilterRender;
import com.pedro.encoder.input.gl.render.filters.BlackFilterRender;
import com.pedro.encoder.input.gl.render.filters.BlurFilterRender;
import com.pedro.encoder.input.gl.render.filters.BrightnessFilterRender;
import com.pedro.encoder.input.gl.render.filters.CartoonFilterRender;
import com.pedro.encoder.input.gl.render.filters.ChromaFilterRender;
import com.pedro.encoder.input.gl.render.filters.CircleFilterRender;
import com.pedro.encoder.input.gl.render.filters.ColorFilterRender;
import com.pedro.encoder.input.gl.render.filters.ContrastFilterRender;
import com.pedro.encoder.input.gl.render.filters.DuotoneFilterRender;
import com.pedro.encoder.input.gl.render.filters.EarlyBirdFilterRender;
import com.pedro.encoder.input.gl.render.filters.EdgeDetectionFilterRender;
import com.pedro.encoder.input.gl.render.filters.ExposureFilterRender;
import com.pedro.encoder.input.gl.render.filters.FireFilterRender;
import com.pedro.encoder.input.gl.render.filters.GammaFilterRender;
import com.pedro.encoder.input.gl.render.filters.GlitchFilterRender;
import com.pedro.encoder.input.gl.render.filters.GreyScaleFilterRender;
import com.pedro.encoder.input.gl.render.filters.HalftoneLinesFilterRender;
import com.pedro.encoder.input.gl.render.filters.Image70sFilterRender;
import com.pedro.encoder.input.gl.render.filters.LamoishFilterRender;
import com.pedro.encoder.input.gl.render.filters.MoneyFilterRender;
import com.pedro.encoder.input.gl.render.filters.NegativeFilterRender;
import com.pedro.encoder.input.gl.render.filters.NoFilterRender;
import com.pedro.encoder.input.gl.render.filters.PixelatedFilterRender;
import com.pedro.encoder.input.gl.render.filters.PolygonizationFilterRender;
import com.pedro.encoder.input.gl.render.filters.RGBSaturationFilterRender;
import com.pedro.encoder.input.gl.render.filters.RainbowFilterRender;
import com.pedro.encoder.input.gl.render.filters.RippleFilterRender;
import com.pedro.encoder.input.gl.render.filters.RotationFilterRender;
import com.pedro.encoder.input.gl.render.filters.SaturationFilterRender;
import com.pedro.encoder.input.gl.render.filters.SepiaFilterRender;
import com.pedro.encoder.input.gl.render.filters.SharpnessFilterRender;
import com.pedro.encoder.input.gl.render.filters.SnowFilterRender;
import com.pedro.encoder.input.gl.render.filters.SwirlFilterRender;
import com.pedro.encoder.input.gl.render.filters.TemperatureFilterRender;
import com.pedro.encoder.input.gl.render.filters.ZebraFilterRender;
import com.pedro.encoder.input.gl.render.filters.object.GifObjectFilterRender;
import com.pedro.encoder.input.gl.render.filters.object.ImageObjectFilterRender;
import com.pedro.encoder.input.gl.render.filters.object.SurfaceFilterRender;
import com.pedro.encoder.input.gl.render.filters.object.TextObjectFilterRender;
import com.pedro.encoder.input.video.CameraHelper;
import com.pedro.encoder.input.video.CameraOpenException;
import com.pedro.encoder.utils.gl.TranslateTo;
import com.pedro.rtmp.utils.ConnectCheckerRtmp;
import com.pedro.rtplibrary.rtmp.RtmpCamera1;
import com.pedro.rtplibrary.rtmp.RtmpCamera2;
import com.pedro.rtplibrary.view.AspectRatioMode;
import com.pedro.rtplibrary.view.OpenGlView;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterSurfaceView;
import io.flutter.plugin.platform.PlatformView;
import java.util.Map;

public class NativeSurfaceView implements PlatformView, SurfaceHolder.Callback, ConnectCheckerRtmp{
    @NonNull private final FlutterSurfaceView surfaceView;
    private RtmpCamera1 rtmpCamera1;
    private OpenGlView openGlView;
    private RtmpCamera2 rtmpCamera2;
    private TextView waterMark;

    NativeSurfaceView (@NonNull Context context, int id, @NonNull Map<String, Object> creationParams) {
        surfaceView = new FlutterSurfaceView(context);
        openGlView = new OpenGlView(surfaceView.getContext());
        openGlView.setAspectRatioMode(AspectRatioMode.Fill);
        openGlView.getHolder().addCallback(this);
        waterMark = new TextView(context);
        waterMark.setText("Joyvee Camera");
        waterMark.setTextColor(Color.LTGRAY);
//        surfaceCreated(surfaceView.getHolder());
//        openGlView = new OpenGlView(surfaceView.getContext());
//        rtmpCamera1 = new RtmpCamera1(openGlView, this);
//        openGlView.getHolder().addCallback(this);
//        rtmpCamera1.startPreview();
//        textView = new TextView(context);
//        textView.setTextSize(72);
//        textView.setBackgroundColor(Color.rgb(255, 255, 255));
//        textView.setText("Rendered on a natiov Android view (id: " + id + ")");
    }

    @NonNull
    @Override
    public View getView() {
        return openGlView;
    }

    @Override
    public void dispose() {
        rtmpCamera1.pauseRecord();
        openGlView.surfaceDestroyed(openGlView.getHolder());
    }

    @Override
    public void surfaceCreated(SurfaceHolder surfaceHolder) {}

    @Override
    public void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i1, int i2) {
        rtmpCamera1 = new RtmpCamera1(openGlView, this);

        TextObjectFilterRender textObjectFilterRender = new TextObjectFilterRender();
        rtmpCamera1.getGlInterface().setFilter(textObjectFilterRender);
        textObjectFilterRender.setText("Joyvee Camera", 70, Color.LTGRAY);
        textObjectFilterRender.setDefaultScale(1920,
               1080);
        textObjectFilterRender.setPosition(TranslateTo.TOP_RIGHT);
        rtmpCamera1.startPreview(1920, 1080);
        Log.i("STRIMOCAMERA", "SurfaceViewCreated ASUSUSUSUS");
    }

    public void switchCamera() {
        rtmpCamera1.switchCamera();
    }

    public void startStream(String url) {
            rtmpCamera1.prepareVideo(1920, 1080, 5000);
            rtmpCamera1.startStream(url);
            rtmpCamera1.getGlInterface().setRotation(0);
    }

    public void stopStream() {
        rtmpCamera1.stopStream();
    }

    public void enableFlashLight() throws Exception {
        rtmpCamera1.enableLantern();
    }

    public void disableFlashLight() {
        rtmpCamera1.disableLantern();
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        if (rtmpCamera1.isStreaming()) {
            rtmpCamera1.stopStream();
        }
        rtmpCamera1.stopPreview();
    }

    @Override
    public void onConnectionStartedRtmp(String rtmpUrl) {
    }

    @Override
    public void onConnectionSuccessRtmp() {}

    @Override
    public void onConnectionFailedRtmp(final String reason) {}

    @Override
    public void onNewBitrateRtmp(long bitrate) {}

    @Override
    public void onDisconnectRtmp() {}

    @Override
    public void onAuthErrorRtmp() {}

    @Override
    public void onAuthSuccessRtmp() {}

    //return view size adapted to stream resolution to fix aspectRatio
    private PointF calculateOriginalSize(float originalWidth, float originalHeight, float streamWidth, float streamHeight, boolean isPortrait) {
        //The stream size is reverted if you are in portrait due to rotation. Fix it
        float w = isPortrait ? streamHeight : streamWidth;
        float h = isPortrait ? streamWidth : streamHeight;
        PointF point = new PointF();
        //Calculate real view value with: originalSize * 100 / streamSize
        point.x = originalWidth * 100f / w;
        point.y = originalHeight * 100f / h;
        return point;
    }
}
