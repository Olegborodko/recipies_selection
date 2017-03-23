class IngredientCategoriesController < ApplicationController
  before_action :set_ingredient_category, only: [:show, :edit, :update, :destroy]

  # GET /ingredient_categories
  # GET /ingredient_categories.json
  def index
    @ingredient_categories = IngredientCategory.all
  end

  # GET /ingredient_categories/1
  # GET /ingredient_categories/1.json
  def show
    @ingredient_category = IngredientCategory.find(params[:id])
    @ingredients = @ingredient_category.ingredients
  end

  # GET /ingredient_categories/new
  def new
    @ingredient_category = IngredientCategory.new
  end

  # GET /ingredient_categories/1/edit
  def edit
  end

  # POST /ingredient_categories
  # POST /ingredient_categories.json
  def create
    @ingredient_category = IngredientCategory.new(ingredient_category_params)

    respond_to do |format|
      if @ingredient_category.save
        format.html { redirect_to @ingredient_category, notice: 'Ingredient category was successfully created.' }
        format.json { render :show, status: :created, location: @ingredient_category }
      else
        format.html { render :new }
        format.json { render json: @ingredient_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ingredient_categories/1
  # PATCH/PUT /ingredient_categories/1.json
  def update
    respond_to do |format|
      if @ingredient_category.update(ingredient_category_params)
        format.html { redirect_to @ingredient_category, notice: 'Ingredient category was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingredient_category }
      else
        format.html { render :edit }
        format.json { render json: @ingredient_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredient_categories/1
  # DELETE /ingredient_categories/1.json
  def destroy
    @ingredient_category.destroy
    respond_to do |format|
      format.html { redirect_to ingredient_categories_url, notice: 'Ingredient category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ingredient_category
    @ingredient_category = IngredientCategory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ingredient_category_params
    params.require(:ingredient_category).permit(:title)
  end
end
