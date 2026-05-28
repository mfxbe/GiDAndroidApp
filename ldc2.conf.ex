"aarch64-.*-linux-android":
{
    switches = [
        "-defaultlib=phobos2-ldc,druntime-ldc",
        "-gcc=ANDOIDSDK/Sdk/ndk/30.0.14904198/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android31-clang",
    ];
    lib-dirs = [
        "%%ldcbinarypath%%/../lib-android_aarch64",
    ];
};
