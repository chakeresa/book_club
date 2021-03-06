require "rails_helper"

RSpec.describe "as a visitor" do
  describe "when I click on a user's name for any book review" do

    before :each do
      @book_1 = Book.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874, thumbnail: "https://images.gr-assets.com/books/1328728986l/1009218.jpg")
      @user_1 = User.create(username: "Chris Davis")
      @review_1 = @book_1.reviews.create!(title: "This book rocks!", rating: 5, text: "Read it!", user: @user_1)
    end

    it "I am taken to a show page for that user." do
      visit book_path(@book_1)

      within("#review-list") do
        click_link(@user_1.username.to_s)
      end

      expect(page.status_code).to eq(200)
      expect(current_path).to eq(user_path(@user_1))
    end
  end

  describe "when I visit a users' show page" do
    before :each do
      @book_1 = Book.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874, thumbnail: "https://images.gr-assets.com/books/1328728986l/1009218.jpg")
      @book_2 = Book.create!(title: "To Kill a Mockingbird", page_count: 281, year_published: 1960, thumbnail: "https://upload.wikimedia.org/wikipedia/en/7/79/To_Kill_a_Mockingbird.JPG")
      author_1 = @book_1.authors.create!(name: "Wilkie Collins")
      author_2 = @book_1.authors.create!(name: "Charles Dickens")
      author_3 = @book_2.authors.create!(name: "Harper Lee")
      @user_1 = User.create(username: "Chris Davis")
      @user_2 = User.create(username: "Alexandra Chakeres")
      @review_1 = @book_1.reviews.create!(title: "This book rocks!", rating: 5, text: "Read it!", user: @user_1)
      @review_2 = @book_2.reviews.create!(title: "This book sucks!", rating: 1, text: "Don't read it!", user: @user_1)
    end

    it "the user page shows all information for all reviews the user has written" do
      visit(user_path(@user_1))

      within("h1") do
        expect(page).to have_content("#{@user_1.username}")
      end


      within("#book-#{@book_1.id}-info") do
        expect(page).to have_css("img[src*='#{@book_1.thumbnail}']")
        expect(page).to have_content(@book_1.title)
      end

      within("#review-#{@review_1.id}-info") do
        expect(page).to have_content(@review_1.title)
        expect(page).to have_content("Written on: #{Date.strptime(@review_1.updated_at.to_s)}")
        within("#review-#{@review_1.id}-bar") do
          expect(page.html).to include("style=\"width:#{@review_1.rating_percentage}%;\"")
        end
        expect(page).to have_content(@review_1.text)
      end

      within("#book-#{@book_2.id}-info") do
        expect(page).to have_css("img[src*='#{@book_2.thumbnail}']")
        expect(page).to have_content(@book_2.title)
      end

      within("#review-#{@review_2.id}-info") do
        expect(page).to have_content(@review_2.title)
        expect(page).to have_content("Written on: #{Date.strptime(@review_2.updated_at.to_s)}")
        within("#review-#{@review_2.id}-bar") do
          expect(page.html).to include("style=\"width:#{@review_2.rating_percentage}%;\"")
        end
        expect(page).to have_content(@review_2.text)
      end
    end

    describe "when I give an invalid user_id" do
      it "redirects me to the book index page" do
        visit user_path(@user_1.id + 50)

        expect(current_path).to eq(books_path)
        expect(page).to have_content("There is no user with that ID")
      end
    end

    describe "when I visit a user page that has no reviews" do
      it "alerts the user that there are no reviews" do
        visit user_path(@user_2.id)

        within("#review-list") do
          expect(page).to have_content("This user has not written any reviews yet.")
        end
      end
    end
  end
end
