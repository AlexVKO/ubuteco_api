# frozen_string_literal: true

module Abilities
  class SuperAdminAbility
    include CanCan::Ability

    def initialize
      can %i[manage search], Beer
      can %i[manage search], BeerStyle
      can %i[manage search], Dish
      can %i[manage search], DishIngredient
      can %i[manage search], Drink
      can %i[manage search], Food
      can %i[manage search], Maker
      can %i[manage search], Order
      can %i[manage search], OrderItem
      can %i[manage search], Organization
      can %i[manage search], Role
      can %i[manage search], Table
      can %i[manage search], Theme
      can %i[manage search], User
      can %i[manage search], Wine
      can %i[manage search], WineStyle
      cannot %i[update destroy], Order, status: 'payed'
      cannot %i[update destroy create], OrderItem, order: { status: 'payed' }
    end
  end
end
