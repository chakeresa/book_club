require "rails_helper"

RSpec.describe "as a visitor" do
  describe "when there is a book with the id matching the URI" do
    before(:each) do
      @book_1 = Book.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874, thumbnail: "https://images.gr-assets.com/books/1328728986l/1009218.jpg")

      @title = "Good Book"
      @username = "Bob"
      @rating = 4
      @text = "I liked this book"
    end

    it "loads the page" do
      visit new_book_review_path(@book_1)

      expect(page.status_code).to eq(200)
      expect(current_path).to eq(new_book_review_path(@book_1))
    end

    it "shows a form to create a new review for the book" do
      visit new_book_review_path(@book_1)

      expect(page).to have_content("New Review for #{@book_1.title}")

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: @rating
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      new_review = Review.last

      expect(new_review.title).to eq(@title)
      expect(new_review.user.username).to eq(@username.titlecase)
      expect(new_review.rating).to eq(@rating)
      expect(new_review.text).to eq(@text)

      expect(current_path).to eq(book_path(@book_1))
      expect(page).to have_content(@text)
      expect(page).to have_content("The new review was added")
    end

    it "reloads the form if missing an input" do
      visit new_book_review_path(@book_1)

      # no title input
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: @rating
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))

      page.fill_in "Title", with: @title
      # no user input
      page.fill_in "Rating", with: @rating
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      # no rating input
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: @rating
      # no text input

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))
    end

    it "reloads the form if invalid rating input" do
      visit new_book_review_path(@book_1)

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: "zebra"
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))

      visit new_book_review_path(@book_1)

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: 1.5
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))

      visit new_book_review_path(@book_1)

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: 6
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))

      visit new_book_review_path(@book_1)

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: 0
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      expect(current_path).to eq(new_book_review_path(@book_1))
    end

    it "doesn't allow for multiple reviews for the same user on one book" do
      visit new_book_review_path(@book_1)

      page.fill_in "Title", with: @title
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: @rating
      page.fill_in "Text", with: @text

      click_button("Submit Review")

      click_link("Write a review")

      page.fill_in "Title", with: "I'm a new title"
      page.fill_in "User", with: @username
      page.fill_in "Rating", with: @rating + 1
      page.fill_in "Text", with: "new text goes here"

      click_button("Submit Review")

      new_review = Review.last

      expect(current_path).to eq(new_book_review_path(@book_1))
      expect(new_review.title).to eq(@title)
      expect(page).to have_content("#{@username} already submitted a review for this book")
    end
  end

  describe "when there is no book with the id matching the URI" do
    before(:each) do
      @book_1 = Book.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874, thumbnail: "https://images.gr-assets.com/books/1328728986l/1009218.jpg")
    end

    it "redirects to the books index" do
      visit new_book_review_path(@book_1.id + 50)

      expect(current_path).to eq(books_path)
      expect(page).to have_content("There is no book with that ID")
    end
  end
end
