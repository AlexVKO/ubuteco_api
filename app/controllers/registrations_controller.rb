# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    @user = User.new sign_up_params
    @user.save
    if @user.errors.empty?
      if params[:organization_attributes].blank?
        sign_in @user
        render json: @user, include: :role
      else
        create_with_organization
      end
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  protected

  def sign_up_params
    params.require(:user)
          .permit(:name, :password, :email, :avatar)
          .merge(role: params[:organization_attributes].present? ? Role.find_by!(name: 'ADMIN') : Role.find_by!(name: 'CUSTOMER'))
  end

  def organization_params
    params.require(:organization_attributes)
          .permit(:cnpj, :logo, :name, :phone).merge(user_id: @user.id)
  end

  def build_organization
    @organization = Organization.new(organization_params)
    @organization.save
  end

  def create_with_organization
    if build_organization
      @user.update(organization_id: @organization.id)
      sign_in @user
      render json: @user, include: [:role, { organization: { include: [:theme] } }]
    else
      @user.really_destroy!
      render json: @organization.errors, status: :unprocessable_entity
    end
  end
end
