class MessagesController < ApplicationController

  include PageAndSortHelper
  include PageAndSortHelper::Controller
  helper PageAndSortHelper

  before_filter do
    authenticate_user!
    load_and_authorize_if_present :user do
      load_and_authorize :message
    end
    load_and_authorize :message
  end

  def index
    @messages =
        case
          when @user
            @user.messages
          when can?(:index_all, Message)
            Message
          else
            current_user.messages
        end

    @messages = page_and_sort(@messages, default_sort: :created_at, default_direction: :desc)
  end

  # this one controller action has two totally different functions:
  #
  # 1. /users/1/messages/3 => show the message content
  # 2. /messages/3 => mark the message clicked at time and redirect to the link in the message.
  def show
    if @user
      # show
    else
      @message.update_column(:clicked_at, Time.now) if current_user == @message.user
      redirect_to @message.link
    end
  end
end
