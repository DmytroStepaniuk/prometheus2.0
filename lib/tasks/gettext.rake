desc "Create mo-files for L10n"
task :makemo do
  require 'gettext_rails/tools'
  GetText.create_mofiles
end

desc "Update pot/po files to match new version."
task :updatepo do
  require 'gettext_rails/tools'
  GetText.update_pofiles("prometheus", Dir.glob("{app,lib}/**/*.{rb,erb}"),
                         "prometheus 0.0.1")
end
