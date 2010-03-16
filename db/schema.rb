# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100316050953) do

  create_table "patterns", :force => true do |t|
    t.string   "pattern"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statements", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tag_assignments", :force => true do |t|
    t.integer  "transaction_id"
    t.integer  "tag_id"
    t.integer  "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_info"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.date     "date"
    t.float    "amount"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "statement_id"
    t.integer  "currtagid"
  end

  create_table "uploads", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
