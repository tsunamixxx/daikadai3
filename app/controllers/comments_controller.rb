class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    # Topicをパラメータの値から探し出し,Topicに紐づくcommentsとしてbuildします。
    @comment = current_user.comments.build(comments_params)
    @topic = @comment.topic
    @notification = @comment.notifications.build(user_id: @topic.user.id )
    # ↑(user_id: @topic.user.id )は(キー: 値)
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        # JS形式でレスポンスを返します。
        format.js { render :index }

        unless @comment.topic.user_id == current_user.id
          Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'comment_created', {
            message: 'あなたの作成したトピックにコメントが付きました'
          })
        end
        Pusher.trigger("user_#{@comment.topic.user_id}_channel", 'notification_created', {
          unread_counts: Notification.where(user_id: @comment.topic.user.id, read: false).count
        })
      else
        format.html { render :new }
      end
    end
  end

  def edit
    # @comment = Comment.find(params[:id])
    @topic = @comment.topic
  end

  def update
    # @comment = Comment.find(params[:id])
    @topic = @comment.topic
    if @comment.update(comments_params)
      redirect_to topic_path(@topic), notice: "コメントを編集しました！"
    else
      render 'edit'
    end
  end

  def destroy
    # @comment = Comment.find(params[:id])
    @comment.destroy
    @topic = @comment.topic
    redirect_to topic_path(@topic), notice: "コメントを削除しました！"
  end

  private
    # ストロングパラメーター
    def comments_params
      params.require(:comment).permit(:topic_id, :content)
    end
    def set_comment
      @comment = Comment.find(params[:id])
    end
end
