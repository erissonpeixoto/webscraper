# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    begin
      if @user.save
        start_new_session_for(@user)
        redirect_to root_path, notice: "Usuário registrado com sucesso."
      else
        flash[:alert] = @user.errors.full_messages.join(", ")
        render :new
      end
    rescue ActiveRecord::RecordNotUnique
      flash.now[:alert] = "Este e-mail já está em uso. Escolha outro."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
