class Api::Internal::Admin::InvitationsController < ApplicationController
  protect_from_forgery

  before_filter :ensure_admin!

  def index
    invitations = Invitation.all.includes(role: :user)

    respond_to do |format|
      format.json {
        render json: {
          invitations: render_invitations(invitations)
        }
      }
    end
  end

  def create
    invitation = Invitation.create({
      description: params[:description]
    })

    respond_to do |format|
      format.json {
        render json: {
          invitation: render_invitation(invitation)
        }
      }
    end
  end

  def destroy
    invitation = Invitation.find(params[:id])
    invitation_payload = render_invitation(invitation)
    invitation.destroy!

    respond_to do |format|
      format.json {
        render json: {
          invitation: invitation_payload
        }
      }
    end
  end

  # Render methods

  def render_invitation(invitation)
    invitation.as_json.merge({
      user: render_user(invitation.role.user)
    })
  end

  def render_invitations(invitations)
    invitations.map { |invitation|
      render_invitation(invitation)
    }
  end
end

