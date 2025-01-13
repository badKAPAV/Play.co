# Keep all class names and fields that are referenced from XML
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Keep essential Flutter classes
-keep class io.flutter.** { *; }