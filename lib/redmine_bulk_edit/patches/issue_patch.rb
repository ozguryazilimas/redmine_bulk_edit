require_dependency 'issue'

module RedmineBulkEdit
  module Patches
    module IssuePatch
      def self.included(base)
        # base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          before_validation :redmine_bulk_edit_validate

          attr_accessor :redmine_bulk_edit_validation_error
        end
      end

      module InstanceMethods

        def redmine_bulk_edit_validate
          return true if @redmine_bulk_edit_validation_error.blank?

          errors.add :base, @redmine_bulk_edit_validation_error
          @redmine_bulk_edit_validation_error = nil

          false
        end

      end

    end
  end
end

