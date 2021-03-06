require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
  describe "book index statistics" do
    before(:each) do
      @author_1 = Author.create(name: "Author 1")
      @author_2 = Author.create(name: "Author 2")
      @author_3 = Author.create(name: "Author 3")
      @book_1 = @author_1.books.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874, thumbnail: "https://images.gr-assets.com/books/1328728986l/1009218.jpg")
      @book_2 = @author_2.books.create!(title: "To Kill a Mockingbird", page_count: 600, year_published: 1960, thumbnail: "https://upload.wikimedia.org/wikipedia/en/7/79/To_Kill_a_Mockingbird.JPG")
      @book_3 = @author_2.books.create!(title: "50 Shades of Grey", page_count: 514, year_published: 2011, thumbnail: "https://upload.wikimedia.org/wikipedia/en/5/5e/50ShadesofGreyCoverArt.jpg")
      @book_4 = @author_3.books.create!(title: "Title 4", page_count: 600, year_published: 1960, thumbnail: "https://upload.wikimedia.org/wikipedia/en/5/5e/50ShadesofGreyCoverArt.jpg")
      @book_5 = @author_3.books.create!(title: "Title 5", page_count: 514, year_published: 2011, thumbnail: "https://upload.wikimedia.org/wikipedia/en/5/5e/50ShadesofGreyCoverArt.jpg")
      @user_1 = User.create(username: "Chris Davis")
      @user_2 = User.create(username: "Alexandra Chakeres")
      @user_3 = User.create(username: "User 3")
      @user_4 = User.create(username: "User 4")
      @user_5 = User.create(username: "User 5")
      @review_1 = @book_2.reviews.create!(title: "This book rocks!", rating: 5, text: "Read it!", user: @user_1)
      @review_2 = @book_1.reviews.create!(title: "This book sucks!", rating: 1, text: "Don't read it!", user: @user_2)
      @review_3 = @book_2.reviews.create!(title: "It's OK.", rating: 3, text: "Meh", user: @user_2)
      @review_4 = @book_2.reviews.create!(title: "four stars", rating: 4, text: "Good", user: @user_5)
      @review_5 = @book_4.reviews.create!(title: "two stars", rating: 2, text: "not good", user: @user_2)
      @review_6 = @book_4.reviews.create!(title: "Alright", rating: 3, text: "Not the best", user: @user_5)
      @review_7 = @book_2.reviews.create!(title: "nice", rating: 4, text: "I like it", user: @user_3)
      @review_8 = @book_5.reviews.create!(title: "great", rating: 4, text: "read it!", user: @user_1)
      @review_9 = @book_5.reviews.create!(title: "fantastic", rating: 5, text: "the best book ever", user: @user_5)
      @review_10 = @book_5.reviews.create!(title: "spectacular", rating: 5, text: "spot on", user: @user_2)
    end

    it "shows the 3 highest rated books" do
      visit books_path

      within "#statistics" do
        expect(page).to have_content("Statistics")

        within "#highest-rated" do
          expect(page).to have_content("Highest Rated Books")
          expect(page.all("li")[0]).to have_link(@book_5.title)
          within("#review-#{@book_5.id}-bar") do
            expect(page.html).to include("style=\"width:#{@book_5.rating_percentage}%;\"")
          end
          expect(page.all("li")[1]).to have_link(@book_2.title)
          within("#review-#{@book_2.id}-bar") do
            expect(page.html).to include("style=\"width:#{@book_2.rating_percentage}%;\"")
          end
          expect(page.all("li")[2]).to have_link(@book_4.title)
          within("#review-#{@book_4.id}-bar") do
            expect(page.html).to include("style=\"width:#{@book_4.rating_percentage}%;\"")
          end
          expect(page).to_not have_link(@book_3.title)
        end
      end
    end

    it "shows the 3 lowest rated books" do
      visit books_path

      within "#statistics" do
        within "#lowest-rated" do
          expect(page).to have_content("Lowest Rated Books")
          expect(page.all("li")[0]).to have_link(@book_1.title)
          within("#review-#{@book_1.id}-bar") do
            expect(page.html).to include("style=\"width:#{@book_1.rating_percentage}%;\"")
          end
          expect(page.all("li")[1]).to have_link(@book_4.title)
          within("#review-#{@book_4.id}-bar") do
            expect(page.html).to include("style=\"width:#{@book_4.rating_percentage}%;\"")
          end
          expect(page.all("li")[2]).to have_link(@book_2.title)
          within("#review-#{@book_2.id}-bar") do
            expect(page.html).to include("style=\"width:#{@book_2.rating_percentage}%;\"")
          end
          expect(page).to_not have_link(@book_3.title)
        end
      end
    end

    it "shows the 3 users with the most reviews" do
      visit books_path

      within "#statistics" do
        within "#most-reviews" do
          expect(page).to have_content("Users with Most Reviews Written")
          expect(page.all("li")[0]).to have_link(@user_2.username)
          expect(page.all("li")[0]).to have_content(@user_2.reviews_count)
          expect(page.all("li")[1]).to have_link(@user_5.username)
          expect(page.all("li")[1]).to have_content(@user_5.reviews_count)
          expect(page.all("li")[2]).to have_link(@user_1.username)
          expect(page.all("li")[2]).to have_content(@user_1.reviews_count)
          expect(page).to_not have_link(@user_4.username)
        end
      end
    end

    it "shows the 3 top authors" do
      visit books_path

      within "#statistics" do
        within "#highest_rated_authors" do
          expect(page).to have_content("Highest Rated Authors")
          expect(page.all("li")[0]).to have_link(@author_2.name)
          within("#review-#{@author_2.id}-bar") do
            expect(page.html).to include("style=\"width:#{@author_2.rating_percentage}%;\"")
          end
          expect(page.all("li")[1]).to have_link(@author_3.name)
          within("#review-#{@author_3.id}-bar") do
            expect(page.html).to include("style=\"width:#{@author_3.rating_percentage}%;\"")
          end
          expect(page.all("li")[2]).to have_link(@author_1.name)
          within("#review-#{@author_1.id}-bar") do
            expect(page.html).to include("style=\"width:#{@author_1.rating_percentage}%;\"")
          end
        end
      end
    end
  end

  describe "book index statistics with partial data" do
    before(:each) do
      @book_1 = Book.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874, thumbnail: "https://images.gr-assets.com/books/1328728986l/1009218.jpg")
      @book_2 = Book.create!(title: "To Kill a Mockingbird", page_count: 600, year_published: 1960, thumbnail: "https://upload.wikimedia.org/wikipedia/en/7/79/To_Kill_a_Mockingbird.JPG")
      @user_1 = User.create(username: "Chris Davis")
      @user_2 = User.create(username: "Alexandra Chakeres")
      @review_1 = @book_1.reviews.create!(title: "This book rocks!", rating: 5, text: "Read it!", user: @user_1)
    end

    it "highest rated books only shows books that have been reviewed" do
      visit books_path

      within "#statistics" do
        within "#highest-rated" do
          expect(page).to have_link(@book_1.title)
          expect(page).to_not have_link(@book_2.title)
          expect(page.all("li").count).to eq(1)
        end
      end
    end

    it "highest rated books only shows books that have been reviewed" do
      visit books_path

      within "#statistics" do
        within "#lowest-rated" do
          expect(page).to have_link(@book_1.title)
          expect(page).to_not have_link(@book_2.title)
          expect(page.all("li").count).to eq(1)
        end
      end
    end

    it "shows the 3 users with the most reviews" do
      visit books_path

      within "#statistics" do
        within "#most-reviews" do
          expect(page).to have_link(@user_1.username)
          expect(page).to_not have_link(@user_2.username)
          expect(page.all("li").count).to eq(1)
        end
      end
    end
  end

  describe "book index statistics with no data" do
    it "shows a message when no books have reviews" do
      visit books_path

      within "#statistics" do
        expect(page).to have_content("No books have reviews yet.")
        expect(page).to_not have_content("Highest Rated Books")
        expect(page).to_not have_content("Highest Rated Books")
        expect(page).to_not have_content("Users with Most Reviews Written")
      end
    end
  end
end
