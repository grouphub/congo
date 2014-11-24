class HomeController < ApplicationController
  def index
    match = request.fullpath.match(/^\/accounts\/(\w+)/)
    match_2 = request.fullpath.match(/^\/admin/)

    if match
      account_slug = match[1]

      return unless account_slug

      unless current_user
        flash[:error] = 'You must be signed in to continue.'
        redirect_to '/users/sign_in'
        return
      end

      current_account = Account.where(slug: account_slug).first
      unless current_account
        flash[:error] = 'We could not find an appropriate account.'
        redirect_to '/'
        return
      end

      is_part_of_account = current_user.roles.any? { |role| role.account_id == current_account.id }
      unless is_part_of_account
        flash[:error] = 'We could not find an appropriate account.'
        redirect_to '/'
        return
      end

      plan_name = current_account.plan_name || ''
      if !Account::PLAN_NAMES.include?(plan_name) && !current_user.invitation
        flash[:error] = 'Please choose a valid plan before continuing.'
        redirect_to '/users/new_plan'
        return
      end
    end

    if match_2
      unless current_user.roles.any? { |role| role.name == 'admin' }
        flash[:error] = 'You must be an admin to continue.'
        redirect_to '/'
        return
      end
    end
  end
end

