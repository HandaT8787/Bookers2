class GroupMailer < ApplicationMailer
  def bulk_mail(group, sender, subject, body)
    @group = group
    @sender = sender
    @body = body

    mail(
      bcc: @group.members.pluck(:email_address),
      subject: subject
    )
  end
end
