class Api::Internal::SpreadsheetImportsController < Api::ApiController
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

    # TODO: Verify content type? Or at least the suffix.
    # TODO: Make sure we clean up on deletion. Also make a task to handle this for attachments.
    tempfile = file.tempfile
    content_type = file.content_type

    properties = JSON.parse(params[:properties] || '{}')
    title = properties['title']
    name = ThirtySix.generate
    description = properties['description']

    unless title.present?
      error_response('Title must be provided.')
      return
    end

    attributes = {
      account_id: current_account.id,
      role_id: current_role.id,
      title: title,
      filename: name,
      description: description,
      content_type: content_type
    }

    S3.store(name, tempfile, content_type)

    attributes[:url] = S3.public_url(name)

    spreadsheet_import = SpreadsheetImport.create!(attributes)

    respond_to do |format|
      format.json {
        render json: {
          spreadsheet_import: spreadsheet_import.as_json
        }
      }
    end
  end

  def destroy
  end

  def update
  end

  def index
  end
end
