module RedmieBulkEdit
  module Hooks
    class IssuesBulkEditHook < Redmine::Hook::ViewListener
      render_on :view_issues_bulk_edit_details_bottom, :partial => 'hooks/redmine_bulk_edit/view_issues_bulk_edit_details_bottom'

      # params: "relation"=>{"relation_type"=>"relates", "issue_to_id"=>"", "delay"=>""}
      def controller_issues_bulk_edit_before_save(context = {})
        begin
          relation_params = context[:params][:relation] || {}
          issue_to_id = relation_params[:issue_to_id]
        rescue => e
          Rails.logger.error "Could not bulk update for context: #{context.inspect}"
          Rails.logger.error e
          return
        end

        return if issue_to_id.blank?

        relation = IssueRelation.where(:issue_from_id => context[:issue].id)
                                .where(:issue_to_id => issue_to_id)
                                .first_or_initialize

        # manually init journal of only issue_to because issue_from is stale now
        relation.issue_to.init_journal(User.current)

        relation.safe_attributes = relation_params.slice(:relation_type, :delay)
        relation.save!

        # build journals manually, and different for different issues
        context[:issue].current_journal.journalize_relation(relation, :added)
        # override private block the way Redmine does
        relation.issue_to.send :relation_added, relation
      end

    end
  end
end

