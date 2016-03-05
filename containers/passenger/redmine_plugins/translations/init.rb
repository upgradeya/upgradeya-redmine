Redmine::Plugin.register :translations do
  name 'Translations'
  author 'Wesley Jones'
  description 'Fake plugin to fix missing translations.'
  version '1.0.0'

  requires_redmine :version => '3.0'..'3.2'

end
