# frozen_string_literal: true

class Order < ApplicationRecord
  acts_as_paranoid

  after_update :update_stock

  enum status: { open: 0, closed: 1, payed: 2 }

  belongs_to :table, optional: true
  belongs_to :organization
  belongs_to :user, optional: true

  has_many :order_items, dependent: :destroy

  monetize :total_cents, :total_with_discount_cents, :discount_cents

  include PgSearch::Model

  pg_search_scope :search,
                  against: %w[created_at total_cents total_with_discount_cents],
                  associated_against: {
                    table: %w[name],
                    user: %w[name]
                  }

  protected

  def update_stock
    return unless status == 'payed'

    order_items.each do |item|
      item.item.update(quantity_stock: item.item.quantity_stock - item.quantity) unless item.item_type == 'Dish'
    end
  end
end
