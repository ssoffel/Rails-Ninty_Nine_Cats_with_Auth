class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user

    mail(to: 'ssoffel@hotmail.com', subject: 'Welcome to 99 Cats')
  end
end
