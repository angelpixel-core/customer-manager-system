# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  email         :citext           not null
#  password_hash :string
#  status        :integer          default(1), not null
#
# Indexes
#
#  index_accounts_on_email  (email) UNIQUE
#

class Account < ApplicationRecord
  include Rodauth::Rails.model
  enum :status, { unverified: 1, verified: 2, closed: 3 }
end
