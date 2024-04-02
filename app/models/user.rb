class User < ApplicationRecord
  enum :role, [:admin, :seller, :buyer]
  has_many :stores
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  JWT_SECRET = Rails.application.credentials.secret_key_base
  
  # def self.from_token(token)  
  #   decoded = JWT.decode(token, "muito.secreto", true, {algorithm: "HS256"})
  #   user_data = decoded[0].with_indifferent_access
  #   User.find(user_data[:id])
  # end

  def self.from_token(token)
    decoded = JWT.decode(token, "muito.secreto", true, {algorithm: "HS256"})
    user_data = decoded[0].with_indifferent_access
    # User.find(user_data[:id])
    User.new(id: user_data[:id], email: user_data[:email], role: user_data[:role])
  rescue JWT::ExpiredSignature
    raise InvalidToken.new
  end

  class InvalidToken < StandardError; end

  def self.token_for(user)
    jwt_headers = {exp: 1.hour.from_now.to_i}
    # jwt_headers = {exp: 1.second.from_now.to_i}
    payload = { 
      id: user.id,
      email: user.email,
      role: user.role
    }
    JWT.encode(payload.merge(jwt_headers),"muito.secreto","HS256")
  end

  # def self.token_for(user)
  #   payload = {id: user.id, email: user.email, role: user.role}
  #   JWT.encode payload, "muito.secreto", "HS256"
  # end
end