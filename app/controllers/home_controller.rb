class HomeController < ApplicationController
  before_filter :check_maintenance

  def check_maintenance
    if Maintenance.in_progress?
      render :file => 'public/maintenance.html', :layout => false
    end
  end

  def index
    account_match = request.fullpath.match(/^\/accounts\/(\w+)/)
    admin_match = request.fullpath.match(/^\/admin/)

    if account_match
      account_slug = account_match[1]

      # If there is no account slug in the URL, then skip validation.
      return unless account_slug

      # If the user isn't signed in, send them to the signin form.
      unless current_user
        flash[:error] = 'You must be signed in to continue.'
        redirect_to '/users/sign_in'
        return
      end

      # If the user is trying to create a new account, skip the validation.
      if account_slug == 'new'
        return
      end

      # Bounce the user if the account they specify isn't valid.
      current_account = Account.where(slug: account_slug).first
      unless current_account
        flash[:error] = 'We could not find an appropriate account.'
        redirect_to '/'
        return
      end

      # Bounce the user if they aren't part of the account.
      is_part_of_account = current_user.roles.any? { |role| role.account_id == current_account.id }
      unless is_part_of_account
        flash[:error] = 'We could not find an appropriate account.'
        redirect_to '/'
        return
      end

      # If the user doesn't have a valid plan name, and they don't have an
      # invitation, then we need them to enter in a valid plan.
      #
      plan_name = current_account.plan_name || ''
      has_no_valid_plan_name = !Account::PLAN_NAMES.include?(plan_name)
      role = Role
        .where(account_id: current_account.id)
        .where(user_id: current_user.id)
        .where(name: 'broker')
        .first
      has_no_broker_invitation = !role.try(:invitation)
      if has_no_valid_plan_name && has_no_broker_invitation
        flash[:error] = 'Please choose a valid plan before continuing.'
        redirect_to '/users/new_plan'
        return
      end
    end

    # If the user is visiting an admin page, make sure they are actually an
    # admin.
    #
    if admin_match
      unless current_user.roles.any? { |role| role.name == 'admin' }
        flash[:error] = 'You must be an admin to continue.'
        redirect_to '/'
        return
      end
    end
  end
end

