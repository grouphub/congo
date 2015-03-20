class Api::Internal::AttachmentsController < ApplicationController
  include ApplicationHelper

  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!

  def create
    file = params[:file]

    unless file
      error_response('File object must be provided.')
      return
    end

    tempfile = file.tempfile
    content_type = file.content_type

    properties = JSON.parse(params[:properties] || '{}')
    title = properties['title']
    name = SecureRandom.uuid
    description = properties['description']

    unless title.present?
      error_response('Title must be provided.')
      return
    end

    attributes = {
      title: title,
      filename: name,
      description: description,
      content_type: content_type
    }

    group_slug = params[:group_id]
    group = Group.where(account_id: current_account.id, slug: group_slug).first
    benefit_plan_id = params[:benefit_plan_id]
    benefit_plan = BenefitPlan.where(account_id: current_account.id, id: benefit_plan_id).first

    if group
      attributes[:group_id] = group.id
    elsif benefit_plan
      attributes[:benefit_plan_id] = benefit_plan.id
    else
      error_response('Could not find an object to attach to')
      return
    end

    S3.store(name, tempfile, content_type)

    attributes[:url] = S3.public_url(name)

    attachment = Attachment.create!(attributes)

    respond_to do |format|
      format.json {
        render json: {
          attachment: attachment.as_json
        }
      }
    end
  end

  def destroy
    group_slug = params[:group_id]
    group = Group.where(account_id: current_account.id, slug: group_slug).first
    benefit_plan_id = params[:benefit_plan_id]
    benefit_plan = BenefitPlan.where(account_id: current_account.id, id: benefit_plan_id).first
    attributes = {
      id: params[:id]
    }

    if group
      attributes[:group_id] = group.id
    elsif benefit_plan
      attributes[:benefit_plan_id] = benefit_plan.id
    else
      error_response('Could not find an object to attach to')
      return
    end

    attachment = Attachment.where(attributes).first

    unless attachment
      error_response('Could not find a matching attachment to delete.')
      return
    end

    S3.delete(attachment.filename)

    attachment.destroy!

    respond_to do |format|
      format.json {
        render json: {
          attachment: attachment.as_json
        }
      }
    end
  end
end

