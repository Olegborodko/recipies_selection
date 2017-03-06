# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170304204631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorite_recipes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "recipe_id"
    t.text     "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_favorite_recipes_on_recipe_id", using: :btree
    t.index ["user_id"], name: "index_favorite_recipes_on_user_id", using: :btree
  end

  create_table "ingredient_categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.string   "href"
    t.integer  "ingredient_category_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "calories"
    t.float    "protein"
    t.float    "fat"
    t.float    "carbohydrate"
    t.index ["ingredient_category_id", "created_at"], name: "index_ingredients_on_ingredient_category_id_and_created_at", using: :btree
  end

  create_table "ingredients_recipes", id: false, force: :cascade do |t|
    t.integer "recipe_id",     null: false
    t.integer "ingredient_id", null: false
    t.index ["ingredient_id", "recipe_id"], name: "index_ingredients_recipes_on_ingredient_id_and_recipe_id", using: :btree
    t.index ["recipe_id", "ingredient_id"], name: "index_ingredients_recipes_on_recipe_id_and_ingredient_id", using: :btree
  end

  create_table "recipe_categories", force: :cascade do |t|
    t.string "title"
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "ingredient_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id", using: :btree
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id", using: :btree
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "recipe_category_id"
    t.string   "cooking_time"
    t.string   "ingredients"
    t.string   "number_of_ingredients"
    t.string   "ccal"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["recipe_category_id"], name: "index_recipes_on_recipe_category_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_roles_on_title", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "name",            null: false
    t.integer  "role_id",         null: false
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "rid"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["rid"], name: "index_users_on_rid", unique: true, using: :btree
    t.index ["role_id"], name: "index_users_on_role_id", using: :btree
  end

end
