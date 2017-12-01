class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    # Topicをパラメータの値から探し出し,Topicに紐づくcommentsとしてbuildします。
    @comment = current_user.comments.build(comments_params)
    @topic = @comment.topic
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        # JS形式でレスポンスを返します。
        format.js { render :index }
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
