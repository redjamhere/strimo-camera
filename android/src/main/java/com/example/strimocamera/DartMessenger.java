package com.example.strimocamera;

import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import kotlin.jvm.internal.Intrinsics;

public class DartMessenger {
    private EventChannel.EventSink eventSink;

    String event = "";
    public void send(EventType eventType, @NonNull String description) {
        if  (eventSink == null) {
            return;
        }
       event = eventType.toString().toLowerCase();

//        if (!TextUtils.isEmpty(description)) {
//            event.put("errorDescription", description);
//        }
        eventSink.success(event);
    }

    public DartMessenger(@NotNull BinaryMessenger messenger, @NonNull String eventChannelId) {
        super();
        Intrinsics.checkNotNullParameter(messenger, "messenger");
        (new EventChannel(messenger, eventChannelId))
                .setStreamHandler((EventChannel.StreamHandler)(new EventChannel.StreamHandler() {
                    public void onListen(Object arguments, EventChannel.EventSink sink) {
                        Intrinsics.checkNotNullParameter(sink, "sink");
                        DartMessenger.this.eventSink = sink;
                    }
                    public void onCancel(Object arguments) {
                        DartMessenger.this.eventSink = (EventChannel.EventSink)null;
                    }
                }));
    }
    // $FF: synthetic method
    public static EventChannel.EventSink access$getEventSink$p(DartMessenger $this) {
        return $this.eventSink;
    }

    public static enum EventType {
        ERROR,
        RTMP_DISCONNECTED,
        RTMP_CONNECTED,
        RTMP_CONNECTING,
        RTMP_CONNECTION_FAILED
    }
}

