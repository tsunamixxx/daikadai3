class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def index
    @topics = Topic.all
  end

  def new
    if params[:back]
      @topic = Topic.new(topics_params)
    else
      @topic = Topic.new
    end
  end

  def create
    # Topic.create(topics_params)
    @topic = Topic.new(topics_params)
    @topic.user_id = current_user.id #form_forからuser_idは取得できないからcurrent_user.idでidを取得している（current_userはdeviseのメソッド）
    if @topic.save
      redirect_to topics_path, notice: "トピックを作成しました！"
      NoticeMailer.sendmail_topic(@topic).deliver
    else
      render 'new'
    end
  end

  def edit
    # @topic = Topic.find(params[:id])
  end

  def update
    # @topic = Topic.find(params[:id])
    if @topic.update(topics_params)
      redirect_to topics_path, notice: "トピックを編集しました！"
    else
      render 'new'
    end
  end

  def show
  end

  def destroy
    # @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to topics_path, notice: "トピックを削除しました！"
  end

  def confirm
    @topic = Topic.new(topics_params)
    render :new if @topic.invalid?
  end

  private
    def topics_params
      params.require(:topic).permit(:title, :content)
    end
    def set_topic
      @topic = Topic.find(params[:id])
    end
end
