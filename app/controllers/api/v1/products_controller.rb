class Api::V1::ProductsController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render json: {
          # TODO: Scope products by firm
          products: Product.all
        }
      }
    end
  end

  def create
    name = params[:name]

    unless name
      # TODO: Handle this
    end

    product = Product.create! \
      name: name

    respond_to do |format|
      format.json {
        render json: product
      }
    end
  end

  def destroy
    id = params[:id]

    product = Product.find(id).destroy

    respond_to do |format|
      format.json {
        render json: product
      }
    end
  end
end

