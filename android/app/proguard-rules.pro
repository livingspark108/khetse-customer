# --- Keep Google Credentials API ---


# --- Keep Google Pay wallet classes ---
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# --- Keep SplitCompat (Play Core) ---
-keep class com.google.android.play.core.splitcompat.** { *; }
-dontwarn com.google.android.play.core.splitcompat.**

# --- Keep Razorpay required classes ---
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# --- Flutter safe rules ---
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
