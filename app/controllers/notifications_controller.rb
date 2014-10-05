class NotificationsController < ApplicationController
  filter_resource_access
  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.my_notifications(current_user.id).order('id desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notifications }
    end
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show

    @notification.read
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notification }
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update

    respond_to do |format|
      if @notification.update_attributes(permitted_params(@notification).notification)
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.mobile { redirect_to notifications_path }
      format.json { head :no_content }
    end
  end

end
