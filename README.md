# GiDAndroidApp

This repo documents an minimal example how to create a GTK app for Android using the D programming language and [giD](https://github.com/Kymorphia/gid). As of now there are some hurdles.

## Prepare

* Look at https://github.com/sp1ritCS/gtk-android-builder for the background information and install pixiewood.
* Set up Android Studio and within it download the SDK (tested Platform 36) and the NDK (tested Version 29).¹
* Prepare [LCD2 for Android](https://wiki.dlang.org/Build_D_for_Android)² (also see ldc2.conf.ex, remebere to set the correct path to the ndk)
* Have Meson installed in a way that allows you to edit parts of it to "patch" Meson (see below).
* Make sure to use at least giD version 0.9.13.

¹ Instead of the complete Androud studio you can use [command line tools](https://developer.android.com/studio?hl=de#command-line-tools-only) (for downloading sdk and ndk) and [mini-studio](https://github.com/sp1ritCS/mini-studio).

² I highly recommend using https://dlang.org/install.html to install LCD2 (or build/install manually), as the compiler version must fit the downloaded aarch64 library perfectly. The binaries provided in the Linux distribution repositories are not close enough, even if they have the same version number.

## Build with

Use the following commands to build the APK. Replace `~/cmdline-tools/sdk/` with the path to the Android SDK and `~/mini-studio/` with the path to the Studio (or mini-studio).

```
$ dub build --deep --arch=aarch64-linux-android --compiler=ldc2 --build=debug

$ pixiewood prepare -s ~/cmdline-tools/sdk/ -a ~/mini-studio/ pixiewood.xml

$ pixiewood generate

$ pixiewood build

```

After a successful build, you should find the resulting APKs in `.pixiewood/android/app/build/outputs/apk/debug/`. You can use adb or Android Studio to install it on an Android device. The resulting APK is also available [here](https://github.com/mfxbe/GiDAndroidApp/releases/tag/0.1).

To build a Linux version of the app, you can simply run `dub build`.

## Meson patch

For this to work, Meson needs an addition. Add the following in `mesonbuild/compilers/d.py` below the `get_pic_args` function:

```
def get_pie_args(self):
    return ['--relocation-model=pic']

def get_pie_link_args(self):
    return ['-L-pie']
```

Also in `mesonbuild/dependencies/dub.py`, replace `dub_arch = self.compiler.arch` with:

```
host_machine = self.env.machines.host
dub_arch = f'{host_machine.cpu_family}-linux-{host_machine.system}'
```


## Still to do

* Make it possible to build x86_64 APKs (usefull for emulator)
* Get fixes directly into meson to avoid the patching

---

Big thanks to [elementgreen](https://github.com/elementgreen) for giD and [sp1ritCS](https://github.com/sp1ritCS) for the GTK Android backend and the GTK Android Builder and everybody else involved in any way.


```
$ dub build --deep --arch=aarch64-linux-android --compiler=ldc2 --build=debug

$ pixiewood prepare -s ~/cmdline-tools/sdk/ -a ~/mini-studio/ pixiewood.xml

$ pixiewood generate

$ pixiewood build

```

After a successful build, you should find the resulting APKs in `.pixiewood/android/app/build/outputs/apk/debug/`. You can use adb or Android Studio to install it on an Android device. The resulting APK is also available [here](https://github.com/mfxbe/GiDAndroidApp/releases/tag/0.1).

To build an Linux version of the app you can just run dub build.

## Meson patch

For this to work Meson needs an addition. Add the following in `mesonbuild/compilers/d.py` below the `get_pic_args` function

```
def get_pie_args(self):
    return ['--relocation-model=pic']

def get_pie_link_args(self):
    return ['-L-pie']
```

Also in `mesonbuild/dependencies/dub.py` replace `dub_arch = self.compiler.arch` with

```
host_machine = self.env.machines.host
dub_arch = f'{host_machine.cpu_family}-linux-{host_machine.system}'
```

## Still to do

* Make it possible to build x86_64 APKs (useful for emulator)
* Get fixes directly into Meson to avoid patching

---

Big thanks to [elementgreen](https://github.com/elementgreen) for giD and [sp1ritCS](https://github.com/sp1ritCS) for the GTK Android backend and the GTK Android Builder and everybody else involved in any way.
