require 'redmine'
require_dependency 'redmine_bulk_edit'

Redmine::Plugin.register :redmine_bulk_edit do
  name 'Redmine Bulk Edit plugin'
  author 'Onur Kucuk'
  description 'Enhancements for mass modifications'
  version '0.5.0'
  url 'http://www.ozguryazilim.com.tr'
  author_url 'http://www.ozguryazilim.com.tr'
  requires_redmine :version_or_higher => '3.0.7'
end

Rails.configuration.to_prepare do
  [
    [Issue, RedmineBulkEdit::Patches::IssuePatch]
  ].each do |classname, modulename|
    unless classname.included_modules.include?(modulename)
      classname.send(:include, modulename)
    end
  end
end

