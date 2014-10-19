class Api::V1::GroupProductsController < ApplicationController
  def create
    account_slug = params[:account_id]
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    product_id = params[:product_id]

    group_product = GroupProduct.create! \
      group_id: group.id,
      product_id: product_id

    respond_to do |format|
      format.json {
        render json: {
          group_product: group_product
        }
      }
    end
  end

  def destroy
    account_slug = params[:account_id]
    group_slug = params[:group_id]
    group = Group.where(slug: group_slug).first
    product_id = params[:product_id]

    group_products = GroupProduct
      .where(group_id: group.id, product_id: product_id)

    group_products.destroy_all

    respond_to do |format|
      format.json {
        render json: {
          group_product: group_products.first
        }
      }
    end
  end
end

