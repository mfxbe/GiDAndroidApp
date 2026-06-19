"aarch64-.*-linux-android":
{
    switches = [
        "-defaultlib=phobos2-ldc,druntime-ldc",
        "-gcc=/home/manuel/Schreibtisch/tBox/cmdline-tools/sdk/ndk/29.0.14206865/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android31-clang",
        "-link-defaultlib-shared=false",
    ];
    lib-dirs = [
        "%%ldcbinarypath%%/../lib-android_aarch64",
    ];
};


"x86_64-.*-linux-android":
{
    switches = [
        "-defaultlib=phobos2-ldc,druntime-ldc",
        "-gcc=/home/manuel/Schreibtisch/tBox/cmdline-tools/sdk/ndk/29.0.14206865/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android31-clang",
        "-link-defaultlib-shared=false",
    ];
    lib-dirs = [
        "%%ldcbinarypath%%/../lib-android_x86_64",
    ];
};
