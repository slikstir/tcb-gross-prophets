module Admin
  class ActivitiesController < AdminController
    def index
      @activities = PublicActivity::Activity.all.order(created_at: :desc)
    end
    
    def destroy_all
      PublicActivity::Activity.destroy_all
      redirect_to admin_activities_path, notice: "All activities have been deleted"
    end
  end
end