require "spec_helper"
require "rails_helper"
require "database_cleaner"
require "email_spec"

include SessionHelper
include UserHelpers

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe "Favorite recipes" do
  include ActiveJob::TestHelper
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before do

  end

  after do
    clear_enqueued_jobs
  end




end