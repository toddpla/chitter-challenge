require 'bcrypt'
require_relative './postgresql_manager'

class User

  def self.create(email:, password:)
    encrypted_password = BCrypt::Password.create(password)
    result = PostgresqlManager.query("INSERT INTO Users(email, password) VALUES('#{email}', '#{encrypted_password}') RETURNING id, email;")
    User.new(
      id: result[0]['id'],
      email: result[0]['email'],
    )
  end

  def self.find(id:)
    return nil unless id
    result = PostgresqlManager.query("SELECT * FROM users WHERE id = #{id}")
    User.new(
      id: result[0]['id'],
      email: result[0]['email'],
    )
  end

  def self.authenticate(email:, password:)
    result = PostgresqlManager.query("SELECT * FROM users WHERE email = '#{email}'")
    return unless result.any?
    return unless BCrypt::Password.new(result[0]['password']) == password
    User.new(id: result[0]['id'], email: result[0]['email'])
  end

  attr_reader :id, :email

  def initialize(id:, email:)
    @id = id
    @email = email
  end
end
