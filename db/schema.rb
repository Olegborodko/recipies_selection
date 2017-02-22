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

ActiveRecord::Schema.define(version: 20170222125003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredient_categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "ingredient_category_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "calories"
    t.float    "protein"
    t.float    "fat"
    t.float    "carbohydrate"
    t.index ["ingredient_category_id", "created_at"], name: "index_ingredients_on_ingredient_category_id_and_created_at", using: :btree
  end

  create_table "recipe_categories", force: :cascade do |t|
    t.string "title"
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "recipes_category_id"
    t.string   "cooking_time"
    t.string   "ingredients"
    t.string   "number_of_ingredients"
    t.integer  "ccal"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["recipes_category_id"], name: "index_recipes_on_recipes_category_id", using: :btree
  end

end
