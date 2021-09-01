project('valdo-gtk', 'vala', 'c',
  version: '0.1.0',
  license: 'GPL-3.0-or-later'
)
application_id  = 'cz.pervoj.valdo-gtk'

templates_dir = get_option('prefix') / get_option('datadir') / 'valdo-gtk' / 'templates'

add_project_arguments ('-DGETTEXT_PACKAGE=@0@'.format(meson.project_name ()),
  language: 'c'
)

# Check the profile for this build
if get_option('profile') == 'development'
  profile = '.Devel'
  add_project_arguments('-D', 'DEVEL',
    language: 'vala'
  )
else
  profile = ''
endif

add_project_arguments([
    '--vapidir', join_paths(meson.current_source_dir(), 'vapi'),
    '--pkg', 'config',
  ],
  language: 'vala',
)

set_defines = [
  ['TEMPLATES', templates_dir],
  ['APPLICATION_ID', application_id],
  ['ICON_NAME', '@0@@1@'.format(application_id, profile)],
  ['VERSION', meson.project_version()],
  ['SANDBOX', get_option('sandbox')],
  ['LOCALEDIR', join_paths(get_option('prefix'), get_option('localedir'))],
  ['GETTEXT_PACKAGE', meson.project_name()]
]
config_h = configuration_data()
foreach define: set_defines
  config_h.set_quoted(define[0], define[1])
endforeach
config_file = configure_file(
  output: 'config.h',
  configuration: config_h
)
project_config_dep = declare_dependency(
  sources: config_file,
  include_directories: include_directories('.')
)

deps = [
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('gio-2.0'),
  dependency('json-glib-1.0'),
  dependency('gtk+-3.0'),
  project_config_dep
]

i18n = import('i18n')

subdir('data')
subdir('ui')
subdir('src')
subdir('po')
subdir('modules/valdo/templates')

valdo_conf_data = configuration_data()
valdo_conf_data.set('DATA_DIR', templates_dir)
valdo_conf_data.set('VCS_TAG', '@VCS_TAG@')
valdo_config_vala = configure_file(
  input: 'modules/valdo/src/config.vala.in',
  output: 'config.vala',
  configuration: valdo_conf_data
)
valdo_files = [
  valdo_config_vala,
  'modules/valdo/src/templateengine.vala',
  'modules/valdo/src/template.vala',
  'modules/valdo/src/variable.vala',
  'modules/valdo/src/value.vala'
]

executable('valdo-gtk',
           [src, valdo_files, resources],
           dependencies: deps,
           vala_args: [resource_args],
           gui_app: true,
           install: true)

meson.add_install_script('build-aux/meson/postinstall.py')
