module Admin
  class ActivitiesController < AdminController
    def index
      @activities = PublicActivity::Activity.all.order(created_at: :desc)
    end
  end
end