# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Applications/Android Studio.app/sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Field optimizations break e2e tests in unexpected ways, so disabled for now. Likely something
# related to value propagation. We can look at this more in the future.
-optimizations !field/*

## --------------- Begin: Android  ----------
## Note: this is default set of rules with some omissions and modifications
-allowaccessmodification
-dontusemixedcaseclassnames
-verbose

# For runtime annotations
-keepattributes *Annotation*

# For native methods, see http://proguard.sourceforge.net/manual/examples.html#native
-keepclasseswithmembernames class * {
    native <methods>;
}

# For enumeration classes, see http://proguard.sourceforge.net/manual/examples.html#enumerations
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# For Serializable classes, see https://www.guardsquare.com/en/products/proguard/manual/examples#serializable
-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}

# Assume isInEditMode() always return false in release builds so they can be pruned
-assumevalues public class * extends android.view.View {
  boolean isInEditMode() return false;
}

## --------------- End: Android  ----------

# Don't obfuscate the code! We can't see local variables when debugging
-dontobfuscate

# Referenced in error-prone
-dontwarn com.sun.source.tree.**
-dontwarn com.sun.source.util.**
-dontwarn com.sun.tools.javac.code.**
-dontwarn javax.lang.model.element.**
-dontwarn javax.lang.model.type.**
-dontwarn javax.lang.model.util.**

# Referenced in SqlDelight's IntelliJ deps
-dontwarn java.awt.event.**
-dontwarn javax.swing.**

# AndroidX Camera Extensions that aren't actually present
-dontwarn androidx.camera.extensions.impl.InitializerImpl$OnExtensionsDeinitializedCallback
-dontwarn androidx.camera.extensions.impl.InitializerImpl$OnExtensionsInitializedCallback

# FCM references some absent classes
-dontwarn com.google.firebase.messaging.TopicOperation$TopicOperations

# threeten-extras references joda time annotations that aren't present
-dontwarn org.joda.convert.ToString

# Compile-only annotations
-dontwarn android.support.annotation.NonNull
-dontwarn android.support.annotation.Nullable
-dontwarn com.google.android.exoplayer2.source.rtsp.RtspMessageChannel$MessageParser$ReadingState
-dontwarn com.google.auto.service.AutoService
-dontwarn com.google.auto.value.AutoValue$CopyAnnotations
-dontwarn com.google.auto.value.extension.memoized.Memoized

# We reflectively access the MainAppComponent from app-legacy at runtime
# We still want to allow optimization of the code itself though, just need
# the little bit of reflection we do to line up.
-keep,allowoptimization class slack.di.anvil.DaggerMainAppComponent {
  public static slack.di.anvil.MainAppComponent$Factory factory();
}
-keep,allowoptimization interface slack.di.anvil.MainAppComponent$Factory {
}

# Keep ContributesMultibinding as it's used/necessary for SlackAppComponentFactory
-keep @interface com.squareup.anvil.annotations.ContributesMultibinding {
  *;
}

##---------------Begin: Gson  ----------
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.

# R8 requires InnerClasses and EnclosingMethod if you keepattributes Signature
-keepattributes Signature,InnerClasses,EnclosingMethod

# Gson specific classes
# From https://github.com/google/gson/blob/master/examples/android-proguard-example/proguard.cfg
-keep class sun.misc.Unsafe { *; }
#-keep class com.google.gson.stream.** { *; }

-keep class com.google.gson.internal.LinkedTreeMap { *; }

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Keep @JsonAdapter annotations at runtime
-keep interface com.google.gson.annotations.JsonAdapter { *; }

# Keep empty default constructors of GSON adapter types in case they're referenced by @JsonAdapter annotations
-if public class * extends com.google.gson.TypeAdapter
-keepclassmembers class <1> {
  public <init>();
}
-if public class * implements com.google.gson.TypeAdapterFactory
-keepclassmembers class <1> {
  public <init>();
}

# Fixes the problematic common GSON pattern of creating anonymous TypeToken instances on R8
# https://github.com/AzureAD/microsoft-authentication-library-common-for-android/issues/1485
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

##---------------End: Gson  ----------

##---------------Begin: Retrofit  ----------
# R8 removes generic type information unless explicitly kept, this keeps them
# on Retrofit internals.
# Can be removed in Retrofit 2.10.0 https://github.com/square/retrofit/pull/3579

# Keep annotation default values (e.g., retrofit2.http.Field.encoded).
-keepattributes AnnotationDefault

# Keep generic signature of Call (R8 full mode strips signatures from non-kept items).
-keep,allowobfuscation,allowshrinking interface retrofit2.Call

# With R8 full mode generic signatures are stripped for classes that are not
# kept. Suspend functions are wrapped in continuations where the type argument
# is used.
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

# We reflectively access this field in "ResponseBodyAccess"
-keepclassmembers class retrofit2.OkHttpCall$ExceptionCatchingResponseBody {
  private okhttp3.ResponseBody delegate;
}

##---------------End: Retrofit  ----------

##---------------Begin: Guava (https://github.com/google/guava/wiki/UsingProGuardWithGuava) ----------
-dontwarn javax.lang.model.element.Modifier

# Note: We intentionally don't add the flags we'd need to make Enums work.
# That's because the Proguard configuration required to make it work on
# optimized code would preclude lots of optimization, like converting enums
# into ints.

# Throwables uses internal APIs for lazy stack trace resolution
-dontnote sun.misc.SharedSecrets
-keep class sun.misc.SharedSecrets {
  *** getJavaLangAccess(...);
}
-dontnote sun.misc.JavaLangAccess
-keep class sun.misc.JavaLangAccess {
  *** getStackTraceElement(...);
  *** getStackTraceDepth(...);
}

# FinalizableReferenceQueue calls this reflectively
# Proguard is intelligent enough to spot the use of reflection onto this, so we
# only need to keep the names, and allow it to be stripped out if
# FinalizableReferenceQueue is unused.
-keepnames class com.google.common.base.internal.Finalizer {
  *** startFinalizer(...);
}
# However, it cannot "spot" that this method needs to be kept IF the class is.
-keepclassmembers class com.google.common.base.internal.Finalizer {
  *** startFinalizer(...);
}
-keepnames class com.google.common.base.FinalizableReference {
  void finalizeReferent();
}
-keepclassmembers class com.google.common.base.FinalizableReference {
  void finalizeReferent();
}

# Striped64, LittleEndianByteArray, UnsignedBytes, AbstractFuture
-dontwarn sun.misc.Unsafe

# Striped64 appears to make some assumptions about object layout that
# really might not be safe. This should be investigated.
-keepclassmembers class com.google.common.cache.Striped64 {
  *** base;
  *** busy;
}
-keepclassmembers class com.google.common.cache.Striped64$Cell {
  <fields>;
}

-dontwarn java.lang.SafeVarargs

-keep class java.lang.Throwable {
  *** addSuppressed(...);
}

# Futures.getChecked, in both of its variants, is incompatible with proguard.

# Used by AtomicReferenceFieldUpdater and sun.misc.Unsafe
-keepclassmembers class com.google.common.util.concurrent.AbstractFuture** {
  *** waiters;
  *** value;
  *** listeners;
  *** thread;
  *** next;
}
-keepclassmembers class com.google.common.util.concurrent.AtomicDouble {
  *** value;
}
-keepclassmembers class com.google.common.util.concurrent.AggregateFutureState {
  *** remaining;
  *** seenExceptions;
}

# Since Unsafe is using the field offsets of these inner classes, we don't want
# to have class merging or similar tricks applied to these classes and their
# fields. It's safe to allow obfuscation, since the by-name references are
# already preserved in the -keep statement above.
-keep,allowshrinking,allowobfuscation class com.google.common.util.concurrent.AbstractFuture** {
  <fields>;
}

# Futures.getChecked (which often won't work with Proguard anyway) uses this. It
# has a fallback, but again, don't use Futures.getChecked on Android regardless.
-dontwarn java.lang.ClassValue

# MoreExecutors references AppEngine
-dontnote com.google.appengine.api.ThreadManager
-keep class com.google.appengine.api.ThreadManager {
  static *** currentRequestThreadFactory(...);
}
-dontnote com.google.apphosting.api.ApiProxy
-keep class com.google.apphosting.api.ApiProxy {
  static *** getCurrentEnvironment (...);
}
##---------------End: Guava ----------

##---------------Begin: Slack --------------
# Miscellaneous classes referenced by Firebase/FCM but not required
-dontwarn org.conscrypt.ConscryptHostnameVerifier
-dontwarn com.google.firebase.iid.FirebaseInstanceIdService
-dontwarn com.bun.miitmdid.interfaces.IIdentifierListener

# Keep classes that will be serialized/deserialized over Gson
# *** Danger ***
# This works, but it is preferable to annotate classes with @Keep, so class(es) will still be
# kept if they move to another package!
-keep class slack.app.model.** { *; }
-keep class slack.corelib.rtm.msevents.** { *; }
-keep class slack.api.activity.response.** { *; }
-keep class slack.api.apps.actions.response.** { *; }
-keep class slack.api.apps.home.response.** { *; }
-keep class slack.api.apps.info.response.** { *; }
-keep class slack.api.apps.permissions.response.** { *; }
-keep class slack.api.apps.profile.response.** { *; }
-keep class slack.api.blocks.response.** { *; }
-keep class slack.api.bookmarks.response.** { *; }
-keep class slack.api.bots.response.** { *; }
-keep class slack.api.calendar.event.response.** { *; }
-keep class slack.api.calls.response.** { *; }
-keep class slack.api.chat.response.** { *; }
-keep class slack.api.chime.response.** { *; }
-keep class slack.api.commands.response.** { *; }
-keep class slack.api.conversations.authed.response.** { *; }
-keep class slack.api.conversations.unauthed.response.** { *; }
-keep class slack.api.dialog.response.** { *; }
-keep class slack.api.dnd.response.** { *; }
-keep class slack.api.drafts.response.** { *; }
-keep class slack.api.emails.response.** { *; }
-keep class slack.api.emoji.response.** { *; }
-keep class slack.api.eventlog.response.** { *; }
-keep class slack.api.ezsubscribe.response.** { *; }
-keep class slack.api.files.response.** { *; }
-keep class slack.api.missions.workflows.response.** { *; }
-keep class slack.api.pins.response.** { *; }
-keep class slack.api.response.** { *; }
-keep class slack.api.rooms.response.** { *; }
-keep class slack.api.screenhero.response.** { *; }
-keep class slack.api.search.response.** { *; }
-keep class slack.api.sharedinvites.authed.response.** { *; }
-keep class slack.api.sharedinvites.unauthed.response.** { *; }
-keep class slack.api.stars.response.** { *; }
-keep class slack.api.subscriptions.response.** { *; }
-keep class slack.api.team.authed.response.** { *; }
-keep class slack.api.team.unauthed.response.** { *; }
-keep class slack.api.usergroups.response.** { *; }
-keep class slack.api.users.admin.response.** { *; }
-keep class slack.api.users.authed.response.** { *; }
-keep class slack.api.users.workflows.response.** { *; }
-keep class slack.api.usersprofile.response.** { *; }
-keep class slack.api.views.response.** { *; }
-keep class slack.http.api.response.** { *; }
-keep class slack.model.** { *; }
-keep class slack.app.push.PushMessageNotification** { *; }
-keep class slack.services.api.megaphone.model.** { *; }
# SlackThemeValues are serialized with Json. Normally we shouldn't need to protect these
# manually, but due to an unknown R8 behavior its properties appear to get stripped.
-keep class slack.theming.SlackUserThemeValues { *; }
-keep class * extends slack.theming.SlackUserThemeValues { *; }

# Keep classes that native libs use
# includedescriptorclasses may keep more than necessary, but is needed for now
-keep,includedescriptorclasses class slack.app.calls.** { *; }

# Keep this field's name because we reflectively access it.
-keepclassmembernames class com.google.android.material.bottomsheet.BottomSheetBehavior {
    private android.animation.ValueAnimator interpolatorAnimator;
}

# In release builds, isDebuggable() is always false
-assumevalues class * implements slack.commons.configuration.AppBuildConfig {
  boolean isDebuggable() return false;
}

# GMS obfuscates itself in a way that conflicts with R8's remapping of it. This just tells it to
# not try to optimize it. In the future we may want to just not optimize over gms entirely and
# just tree-shake.
-keep class com.google.android.gms.common.internal.BaseGmsClient { *; }

# We have been seeing runtime crashes where the `value` member of our various AppHomeTabType objects
# is null when it should be a hard-coded string. This has been happening only in release builds,
# so this rule resolves that issue by explicitly keeping all class members for these objects.
# I've asked the R8 team if they know anything about why that might be happening here:
#   https://androidstudygroup.slack.com/archives/C6MKCJR8V/p1580515029014500
-keepclassmembers class slack.api.apps.home.request.* {
  !transient <fields>;
}

-dontwarn com.bun.supplier.IIdentifierListener

##---------------End: Slack --------------

##---------------Begin: Android Priority Job Queue---------
-dontwarn com.birbit.android.jobqueue.scheduling.GcmJobSchedulerService
-dontwarn com.birbit.android.jobqueue.scheduling.GcmScheduler

# Jobqueue has some undefined behavior with proguard that we don't want to risk
-keep class com.birbit.android.jobqueue.** { *; }
# Referenced but not used
-dontwarn com.google.android.gms.gcm.GcmTaskService
##---------------End: Android Priority Job Queue---------
##---------------Begin: Protobuf---------

# Javalite runtime uses reflection and does not work with R8. This is a temporary workaround
# that we can remove after https://issuetracker.google.com/issues/144631039 is addressed
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }

# Tink 1.4 RC2 had the generated proto classes stripped by R8. This is a known issue
# and should be addressed before the stable release of Tink 1.4.0
# https://github.com/google/tink/issues/357
# https://github.com/google/tink/issues/361
-keep class * extends com.google.crypto.tink.shaded.protobuf.GeneratedMessageLite { *; }

##---------------End: Protobuf---------

##---------------Begin: OkHttp --------------
# OkHttp references classes not available in android, but that's ok because they're not used
-dontwarn okhttp3.**
##---------------End: OkHttp --------------

##---------------Begin: Coroutines ----------
# Ensure the custom, fast service loader implementation is removed. R8 will fold these for us
-checkdiscard class kotlinx.coroutines.internal.FastServiceLoaderKt

# Used by coroutines's debugging agent but can be ignored.
-dontwarn sun.misc.SignalHandler
-dontwarn java.lang.instrument.ClassFileTransformer

##---------------End: Coroutines ----------

##---------------Begin: Dagger ----------
# Check that Dagger binds methods placeholder methods have been discarded.
#-checkdiscard class * {
#  @dagger.Binds *;
#  @dagger.multibindings.Multibinds *;
#}

# Check that qualifier annotations have been discarded.
# TODO reenable after moving feature-flag bits out of slack.model (which keeps these qualifiers)
#-checkdiscard @javax.inject.Qualifier class *
##---------------End: Dagger ----------

##---------------Begin: Lottie ----------
# Keep motionlayout internal methods
-keep class androidx.constraintlayout.** { *; }

# Keep methods called by MotionLayout via reflection
-keep class com.airbnb.lottie.LottieAnimationView {
    public void setProgress(float);
}
##---------------End: Lottie ----------

##---------------Begin: Guinness ----------
-keep,allowobfuscation,allowshrinking class slack.guinness.ErrorTypeHolder
##---------------End: Guinness ----------
