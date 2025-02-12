class Users::SessionsController < Devise::SessionsController
  layout 'minimum'

  skip_before_action :check_if_live
  skip_before_action :check_chud_checkpoint_time
  skip_before_action :check_if_logged_in

end