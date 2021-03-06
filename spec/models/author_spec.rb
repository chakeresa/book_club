require "rails_helper"

RSpec.describe Author, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
  end

  describe "relationships" do
    it {should have_many :book_authors}
    it {should have_many(:books).through(:book_authors)}
  end

  describe "class methods" do
    describe "when destroying an author" do
      before(:each) do
        @book_1 = Book.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874, thumbnail: "https://images.gr-assets.com/books/1328728986l/1009218.jpg")
        @book_2 = Book.create!(title: "To Kill a Mockingbird", page_count: 281, year_published: 1960, thumbnail: "https://upload.wikimedia.org/wikipedia/en/7/79/To_Kill_a_Mockingbird.JPG")
        @author_1 = @book_1.authors.create!(name: "Wilkie Collins")
        @author_2 = @book_1.authors.create!(name: "Charles Dickens")
        @author_3 = @book_2.authors.create!(name: "Harper Lee")
        @book_3 = @author_1.books.create!(title: "The Moonstone", page_count: 528, year_published: 1868, thumbnail: "https://upload.wikimedia.org/wikipedia/commons/2/26/The_Moonstone_1st_ed.jpg")
        user_1 = User.create(username: "Chris Davis")
        user_2 = User.create(username: "Alexandra Chakeres")
        @review_1 = @book_1.reviews.create!(title: "This book rocks!", rating: 5, text: "Read it!", user: user_1)
        @review_2 = @book_2.reviews.create!(title: "This book sucks!", rating: 1, text: "Don't read it!", user: user_2)
        @review_3 = @book_1.reviews.create!(title: "It's OK.", rating: 3, text: "Meh", user: user_2)
      end

      it "destroys the author" do
        @author_1.destroy

        expect(Author.all).to include(@author_2)
        expect(Author.all).to include(@author_3)
        expect(Author.all).to_not include(@author_1)
      end

      it "sorts by highest rated author" do
        expect(Author.highest_rated(3).to_a).to eq([@author_2, @author_1, @author_3])
        expect(Author.highest_rated(2).to_a).to eq([@author_2, @author_1])
        expect(Author.highest_rated(1).to_a).to eq([@author_2])
      end
    end
  end

  describe "instance methods" do
    before(:each) do
      @author_1 = Author.create!(name: "Wilkie Collins")
      @author_2 = Author.create!(name: "Charles Dickens")
      @book_1 = @author_1.books.create!(title: "The Frozen Deep", page_count: 106, year_published: 1874)
      @book_2 = @author_1.books.create!(title: "To Kill a Mockingbird", page_count: 281, year_published: 1960)
      user_1 = User.create(username: "Chris Davis")
      user_2 = User.create(username: "Alexandra Chakeres")
      @review_1 = @book_1.reviews.create!(title: "This book rocks!", rating: 5, text: "Read it!", user: user_1)
      @review_2 = @book_2.reviews.create!(title: "This book sucks!", rating: 1, text: "Don't read it!", user: user_2)
      @review_3 = @book_1.reviews.create!(title: "It's OK.", rating: 3, text: "Meh", user: user_2)
    end

    it "counts books" do
      expect(@author_1.book_count).to eq(2)
      expect(@author_2.book_count).to eq(0)
    end

    it "calcuates ratings" do
      expect(@author_1.rating_percentage).to eq(60)
    end
  end
end
