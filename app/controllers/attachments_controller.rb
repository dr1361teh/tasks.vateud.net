class AttachmentsController < ApplicationController

  before_filter :confirm_enabled
  # before_filter :confirm_admin, :only => [:destroy]

  def index
    @attachments = Attachment.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @attachment = Attachment.new
    @task = Task.find(params[:task])
    unless (@task.status_id > 1 && @task.status_id < 6 && @task.status_id != 4 && @task.users.include?(current_user)) or (@task.status_id == 1 && @task.author == current_user)
      flash[:error] = "Insufficient privileges! This action is not available to you!"
      redirect_to "/forbidden"
    end
    @attachment.task_id = @task.id
    @pagetitle = "Add attachment to task #{@task.name}"

    respond_to do |format|
      format.html
    end
  end

  def edit
    @attachment = Attachment.find(params[:id])
    @task = @attachment.task
    unless (@task.status_id > 1 && @task.users.include?(current_user)) or (@task.status_id == 1 && @task.author == current_user)
      flash[:error] = "Insufficient privileges! This action is not available to you!"
      redirect_to "/forbidden"
    end
    @pagetitle = "Edit attachment to task #{@task.name}"
    @edit = true
  end

  def create
    @attachment = Attachment.new(params[:attachment])

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to task_path(@attachment.task), notice: 'Attachment was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to task_path(@attachment.task), notice: 'Attachment was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @task = @attachment.task
    unless (@task.status_id > 1 && @task.users.include?(current_user)) or (@task.status_id == 1 && @task.author == current_user)
      flash[:error] = "Insufficient privileges! This action is not available to you!"
      redirect_to "/forbidden"
    end
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to task_path(@attachment.task), notice: 'Attachment was successfully deleted.' }
    end
  end
end
