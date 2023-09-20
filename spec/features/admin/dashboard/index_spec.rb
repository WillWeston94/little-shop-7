require "rails_helper"

RSpec.describe "the admin index" do
  it "displays a header at the top of the dashboard" do
    
    visit "/admin"

    expect(page).to have_content("Admin Dashboard")
  
  end

  it "has links to the admin merchant's index and the admin invoices index" do
    visit "/admin"
    
    within("#admin_merchants_index") do
      expect(page).to have_link("Merchants")
    end
    
    within("#admin_invoices_index") do
      expect(page).to have_link("Invoices")
    end
  end

  it "displays the top 5 customers" do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)
    customer_4 = create(:customer)
    customer_5 = create(:customer)
    customer_6 = create(:customer)
    

    invoice_1 = create(:invoice, customer: customer_1)
    invoice_2 = create(:invoice, customer: customer_2)
    invoice_3 = create(:invoice, customer: customer_3)
    invoice_4 = create(:invoice, customer: customer_4)
    invoice_5 = create(:invoice, customer: customer_5)
    invoice_6 = create(:invoice, customer: customer_6)

    transactions_for_invoice_1 = create_list(:transaction, 4, invoice: invoice_1)
    transactions_for_invoice_2 = create_list(:transaction, 5, invoice: invoice_2)
    transactions_for_invoice_3 = create_list(:transaction, 6, invoice: invoice_3)
    transactions_for_invoice_4 = create_list(:transaction, 1, invoice: invoice_4)
    transactions_for_invoice_5 = create_list(:transaction, 2, invoice: invoice_5)
    transactions_for_invoice_6 = create_list(:transaction, 3, invoice: invoice_6)
    
    visit "/admin"

    expect(customer_3.first_name).to appear_before(customer_2.first_name)
    expect(customer_2.first_name).to appear_before(customer_1.first_name)
    expect(customer_1.first_name).to appear_before(customer_6.first_name)
    expect(customer_6.first_name).to appear_before(customer_5.first_name)
    expect(page).to have_content(customer_5.first_name)
    expect(page).not_to have_content("#{customer_4.first_name} #{customer_4.last_name}")

    expect(page).to have_content("#{customer_1.first_name} #{customer_1.last_name}: #{customer_1.amount_of_transactions} Transactions")
  end

  it "will display all incomplete invoices" do
    customer_1 = create(:customer)

    invoice_1 = create(:invoice, customer: customer_1, status: 0)
    invoice_2 = create(:invoice, customer: customer_1, status: 1)
    invoice_3 = create(:invoice, customer: customer_1, status: 0)

    visit "/admin"

    expect(page).to have_content("#{invoice_1.id}")
    expect(page).to_not have_content("#{invoice_2.id}")
    expect(page).to have_content("#{invoice_3.id}")
  end

  it "displays a link to each incomplete invoice" do
    customer_1 = create(:customer)

    invoice_1 = create(:invoice, customer: customer_1, status: 0)
    invoice_2 = create(:invoice, customer: customer_1, status: 0)

    visit "/admin"

    expect(page).to have_link("Show Invoice: #{invoice_1.id}")
    expect(page).to have_link("Show Invoice: #{invoice_2.id}")
  end

  it "displays the date when the invoice was created with the correct formatted date" do
    customer_1 = create(:customer)

    invoice_1 = create(:invoice, customer: customer_1, status: 0)
    invoice_2 = create(:invoice, customer: customer_1, status: 0)

    visit "/admin"

    expect(page).to have_content(invoice_1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(invoice_2.created_at.strftime("%A, %B %d, %Y"))
  end

  it "orders the invoices form oldest to newest" do
    customer_1 = create(:customer)

    invoice_1 = create(:invoice, customer: customer_1, status: 0, created_at: DateTime.now)
    invoice_2 = create(:invoice, customer: customer_1, status: 1)
    invoice_3 = create(:invoice, customer: customer_1, status: 0)

    visit "/admin"

    expect(invoice_3.created_at.strftime("%A, %B %d, %Y")).to appear_before(invoice_1.created_at.strftime("%A, %B %d, %Y"))
  end

end