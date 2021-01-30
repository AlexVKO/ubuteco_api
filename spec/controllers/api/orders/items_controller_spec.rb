# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Orders::ItemsController, type: :request do

  let!(:organization) { create(:organization) }
  let!(:waiter) { create(:user_waiter, organization: organization) }
  let!(:orders) { create_list(:order, 10, :with_items, :open, organization: organization) }
  let!(:maker) { create(:maker, organization: organization) }
  let!(:dishes) { create_list(:dish, 10, organization: organization) }
  let!(:wines) { create_list(:wine, 10, organization: organization, maker: maker) }
  let!(:beers) { create_list(:beer, 10, organization: organization, maker: maker) }
  let!(:drinks) { create_list(:drink, 10, organization: organization, maker: maker) }

  describe '#GET /api/orders/:order_id/items' do
    it 'should request all order items' do
      get api_order_items_path(order_id: orders.sample.id), headers: auth_header(waiter)
      expect(response).to have_http_status(200)
    end
  end

  describe '#POST /api/orders/:order_id/items' do
    let!(:order) { orders.sample }
    it 'should add drink to order' do
      attributes = attributes_for(:order_item).merge(
        item_id: drinks.sample.id,
        item_type: 'Drink',
        quantity: 10
      )
      post api_order_items_path(order_id: order.id), params: attributes.to_json, headers: auth_header(waiter)
      expect(response).to have_http_status(201)
    end
    it 'should add beer to order' do
      attributes = attributes_for(:order_item).merge(
        item_type: 'Beer',
        item_id: beers.sample.id,
        quantity: 10
      )
      post api_order_items_path(order_id: order.id), params: attributes.to_json, headers: auth_header(waiter)
      expect(response).to have_http_status(201)
    end
    it 'should add wines to order' do
      attributes = attributes_for(:order_item).merge(
        item_type: 'Wine',
        item_id: wines.sample.id,
        quantity: 10
      )
      post api_order_items_path(order_id: order.id), params: attributes.to_json, headers: auth_header(waiter)
      expect(response).to have_http_status(201)
    end
    it 'should add wines to order' do
      attributes = attributes_for(:order_item).merge(
        item_id: dishes.sample.id,
        item_type: 'Dish',
        quantity: 10
      )
      post api_order_items_path(order_id: order.id), params: attributes.to_json, headers: auth_header(waiter)
      expect(response).to have_http_status(201)
    end
    it 'should throw error with invalid params' do
      post api_order_items_path(order_id: order.id), headers: auth_header(waiter)
      expect(response).to have_http_status(422)
    end
  end

  describe '#PUT /api/orders/:order_id/items/:id' do
    let!(:order) { orders.sample }
    let!(:item) { order.order_items.sample }
    it 'should update a order item' do
      item.quantity = 10
      put api_order_item_path(order_id: order.id, id: item.id), params: item.to_json, headers: auth_header(waiter)
      expect(response).to have_http_status(200)
    end
    it 'should throw error with invalid params' do
      item.quantity = -99
      put api_order_item_path(order_id: order.id, id: item.id), params: item.to_json, headers: auth_header(waiter)
      expect(response).to have_http_status(422)
    end
  end

  describe '#DELETE /api/orders/:order_id/items/:id' do
    let!(:order) { orders.sample }
    let!(:item) { order.order_items.sample }
    it 'should remove item from order' do
      delete api_order_item_path(order_id: order.id, id: item.id), headers: auth_header(waiter)
      expect(response).to have_http_status(200)
    end
  end
end
