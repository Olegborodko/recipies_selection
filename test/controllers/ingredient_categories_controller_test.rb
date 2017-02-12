require 'test_helper'

class IngredientCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ingredient_category = ingredient_categories(:one)
  end

  test "should get index" do
    get ingredient_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_ingredient_category_url
    assert_response :success
  end

  test "should create ingredient_category" do
    assert_difference('IngredientCategory.count') do
      post ingredient_categories_url, params: { ingredient_category: { title: @ingredient_category.title } }
    end

    assert_redirected_to ingredient_category_url(IngredientCategory.last)
  end

  test "should show ingredient_category" do
    get ingredient_category_url(@ingredient_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_ingredient_category_url(@ingredient_category)
    assert_response :success
  end

  test "should update ingredient_category" do
    patch ingredient_category_url(@ingredient_category), params: { ingredient_category: { title: @ingredient_category.title } }
    assert_redirected_to ingredient_category_url(@ingredient_category)
  end

  test "should destroy ingredient_category" do
    assert_difference('IngredientCategory.count', -1) do
      delete ingredient_category_url(@ingredient_category)
    end

    assert_redirected_to ingredient_categories_url
  end
end
