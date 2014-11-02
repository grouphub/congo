class Api::V1::ProductsController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render json: {
          # TODO: Scope products by account
          products: Product.all
        }
      }
    end
  end

  def create
    name = params[:name]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    carrier_slug = params[:carrier_slug]
    carrier = Carrier.where(slug: carrier_slug).first

    unless name
      # TODO: Handle this
    end

    unless account
      # TODO: Handle this
    end

    unless carrier
      # TODO: Handle this
    end

    product = Product.create! \
      name: name,
      account_id: account.id,
      carrier_id: carrier.id

    respond_to do |format|
      format.json {
        render json: {
          product: product
        }
      }
    end
  end

  def show
    id = params[:id]
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first
    product = Product.where(id: params[:id]).first

    respond_to do |format|
      format.json {
        render json: {
          product: product.simple_hash
        }
      }
    end
  end

  def destroy
    id = params[:id]

    product = Product.find(id).destroy

    respond_to do |format|
      format.json {
        render json: {
          product: product
        }
      }
    end
  end
end

