class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization

  def full_name
    "#{first_name} \"#{nickname.sample.titleize}\" #{last_name}"
  end

  def nickname 
    %w(bones checkers bloodhound the_fish blackbeard gramps rambo calamity_jane lizzy hobbes slugger the_donald)
  end
end
