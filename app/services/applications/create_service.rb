module Applications
  class CreateService
    attr_reader :attributes, :application

    def initialize(attributes)
      @attributes  = attributes
      @application = Application.new(application_params)
    end

    def process
      @application.save!
    end

    private

    def application_params
      { account_id: account.id,
        benefit_plan_id: benefit_plan.id,
        membership_id: membership.id,
        selected_by_id: attributes[:selected_by_id],
        declined_by_id: attributes[:declined_by_id],
        applied_by_id: attributes[:applied_by_id],
        selected_on: selected_on_date,
        declined_on: declined_on_date,
        applied_on: applied_on_date,
        properties: attributes[:properties],
        pdf_attachment_url: pdf_attachment_url }
    end

    def account
      @account ||= Account.where(slug: attributes[:account_id]).first
    end

    def group
      @group ||= Group.where(slug: attributes[:group_slug]).first
    end

    def benefit_plan
      @benefit_plan ||= BenefitPlan.where(id: attributes[:benefit_plan_id]).first
    end

    def membership
      @membership ||= Membership.where(id: attributes[:membership_id]).first ||
        Membership.where(group_id: group.id, user_id: attributes[:user_id]).first
    end

    def selected_on_date
      @selected_on_date ||= attributes[:selected_by_id] ? DateTime.now : nil
    end

    def declined_on_date
      @declined_on_date ||= attributes[:declined_by_id] ? DateTime.now : nil
    end

    def applied_on_date
      @appied_on_date ||= attributes[:applied_by_id] ? DateTime.now : nil
    end

    def pdf_attachment_url
      @pdf_attachment_url ||= process_pdf
    end

    def process_pdf
      return nil if attributes[:pdf_attachment].nil?
      pdf_attachment = attributes[:pdf_attachment]
      S3.store(pdf_attachment.original_filename, pdf_attachment.tempfile, "application/pdf")
      S3.public_url(pdf_attachment.original_filename)
    end
  end
end
