project('ant', 'd', meson_version: '>=1.9.0')

add_global_arguments('-mtriple=aarch64-un-linux-android31', language : 'd')

dub_exe = find_program('dub', required : false)
run_command('dub', 'run', 'dub-build-deep', '--yes', '--', 'gid:gtk4', '--compiler', 'ldc2', '--arch', 'aarch64-linux-android', check: true)


gid_dep = dependency('gid:gtk4', method: 'dub')

dependency('gtk4')

exe = executable('ant', ['app.d'], dependencies: [
 gid_dep        
], android_exe_type: 'application', install: true, link_args: ['-link-defaultlib-shared=false'])
