class MessageMailer < ActionMailer::Base
  #TODO set default from address
  default from: "noreply@example.com"

  attr :subject

  def prepare_message(message)
    @message = message
    @user = message.user

    # ask the message model if we need any attachments added
    message.add_attachments(self)

    m = mail(to: message.user.email, subject: message.subject, template_name: message.template || :default)
    # allow template to override subject in the view by doing: <% @message.subject = "new subject" %>
    m.subject = message.subject
    m
  end
end
