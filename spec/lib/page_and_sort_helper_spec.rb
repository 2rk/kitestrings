require 'spec_helper'
require 'page_and_sort_helper'
require 'active_record'


describe PageAndSortHelper do

  # TODO: This spec file needs a test database to talk to. We don't have one set up for this gem yet.

  class Record < ActiveRecord::Base
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
        expect(scope.to_sql).to include("ORDER BY `companies`.`name` ASC")
      end
      it "on Record" do
        scope = subject.page_and_sort(Record)
        expect(scope.to_sql).to include("ORDER BY `companies`.`name` ASC")
      end
      it "on Record.where" do
        scope = subject.page_and_sort(Record.where("a = b"))
        expect(scope.to_sql).to include("ORDER BY `companies`.`name` ASC")
        expect(scope.to_sql).to include("a = b")
      end
    end
    context "record sort desc" do
      let(:params) { {sort: "name", sort_direction: "desc"} }
      it "on Record.scoped" do
        scope = subject.page_and_sort(scope_of(Record))
        expect(scope.to_sql).to include("ORDER BY `companies`.`name` DESC")
      end
      it "on Record" do
        scope = subject.page_and_sort(Record)
        expect(scope.to_sql).to include("ORDER BY `companies`.`name` DESC")
      end
      it "on Record.where" do
        scope = subject.page_and_sort(Record.where("a = b"))
        expect(scope.to_sql).to include("ORDER BY `companies`.`name` DESC")
        expect(scope.to_sql).to include("a = b")
      end
    end
    context "record sort asc" do
      let(:params) { {sort: "record_type", sort_direction: "asc"} }
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
      let(:params) { {sort: "record_type", sort_direction: "desc"} }
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
