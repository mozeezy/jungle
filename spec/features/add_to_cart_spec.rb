require 'rails_helper'

RSpec.feature "Add To Carts", type: :feature do
    
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They see all products" do
    # ACT
    visit root_path
    page.find('.products').first(:button, "Add").click

    # DEBUG / VERIFY

    #VERIFY
    expect(page).to have_content('My Cart (1)')
    save_screenshot
  end
end
