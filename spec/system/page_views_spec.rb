require "rails_helper"

RSpec.describe "Welcome Page", type: :system do
  it "shows the number of pageviews" do
    $redis.del("visits")
    visit "/welcome/index"
    expect(page.text).to match(/Welcome/)
    expect(page.text).to match(/1 Visitors so far/)
  end
end
