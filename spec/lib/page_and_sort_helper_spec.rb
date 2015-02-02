require 'rails_helper'
require 'page_and_sort_helper'

describe PageAndSortHelper do

  class Record < ActiveRecord::Base
    def self.order_by_genre(direction)
      order("CASE genre_id WHEN 1 THEN 2 ELSE 3 END #{direction == :asc ? 'ASC' : 'DESC'}")
    end
  end

  context "page_and_sort" do
    let(:params) { {} }
    let(:klass) do
      Struct.new :params do
        include PageAndSortHelper
        include PageAndSortHelper::Controller
      end
    end
    subject { klass.new(params) }

    def scope_of(klass)
      if ActiveRecord::VERSION::MAJOR >= 4
        klass.all
      else
        klass.scoped
      end
    end
    
    context "record sort" do
      let(:params) { {sort: "name", sort_direction: "asc"} }
      it "on Record.scoped" do
        scope = subject.page_and_sort(scope_of(Record))
        expect(scope.to_sql).to include("ORDER BY \"records\".\"name\" ASC")
      end
      it "on Record" do
        scope = subject.page_and_sort(Record)
        expect(scope.to_sql).to include("ORDER BY \"records\".\"name\" ASC")
      end
      it "on Record.where" do
        scope = subject.page_and_sort(Record.where("a = b"))
        expect(scope.to_sql).to include("ORDER BY \"records\".\"name\" ASC")
        expect(scope.to_sql).to include("a = b")
      end
    end
    context "record sort desc" do
      let(:params) { {sort: "name", sort_direction: "desc"} }
      it "on Record.scoped" do
        scope = subject.page_and_sort(scope_of(Record))
        expect(scope.to_sql).to include("ORDER BY \"records\".\"name\" DESC")
      end
      it "on Record" do
        scope = subject.page_and_sort(Record)
        expect(scope.to_sql).to include("ORDER BY \"records\".\"name\" DESC")
      end
      it "on Record.where" do
        scope = subject.page_and_sort(Record.where("a = b"))
        expect(scope.to_sql).to include("ORDER BY \"records\".\"name\" DESC")
        expect(scope.to_sql).to include("a = b")
      end
    end
    context "record sort asc" do
      let(:params) { {sort: "genre", sort_direction: "asc"} }
      it "on Record.scoped" do
        scope = subject.page_and_sort(scope_of(Record))
        expect(scope.to_sql).to match(/ORDER BY CASE genre_id .* END ASC/)
      end
      it "on Record" do
        scope = subject.page_and_sort(Record)
        expect(scope.to_sql).to match(/ORDER BY CASE genre_id .* END ASC/)
      end
      it "on Record.where" do
        scope = subject.page_and_sort(Record.where("a = b"))
        expect(scope.to_sql).to match(/ORDER BY CASE genre_id .* END ASC/)
        expect(scope.to_sql).to include("a = b")
      end
    end
    context "record sort desc" do
      let(:params) { {sort: "genre", sort_direction: "desc"} }
      it "on Record.scoped" do
        scope = subject.page_and_sort(scope_of(Record))
        expect(scope.to_sql).to match(/ORDER BY CASE genre_id .* END DESC/)
      end
      it "on Record" do
        scope = subject.page_and_sort(Record)
        expect(scope.to_sql).to match(/ORDER BY CASE genre_id .* END DESC/)
      end
      it "on Record.where" do
        scope = subject.page_and_sort(Record.where("a = b"))
        expect(scope.to_sql).to match(/ORDER BY CASE genre_id .* END DESC/)
        expect(scope.to_sql).to include("a = b")
      end
    end
  end
end
