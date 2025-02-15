# frozen_string_literal: true, encoding: ASCII-8BIT
# frozen_string_literal: true

require File.expand_path('support', __dir__)
require 'set'

class ViewTest < CouchbaseOrm::Base
  attribute :name, type: String
  enum rating: [:awesome, :good, :okay, :bad], default: :okay

  view :vall

  # This generates both:
  # view :by_rating, emit_key: :rating
  # def self.find_by_rating(rating); end  # also provide this helper function
  index_view :rating
end

describe CouchbaseOrm::Views do
  before do
    ViewTest.delete_all
  rescue Couchbase::Error::DesignDocumentNotFound
    # ignore (FIXME: check before merge) mainly because if there is nothing in all we should not have an error
  end

  after do
    ViewTest.delete_all
  rescue Couchbase::Error::InternalServerFailure
  # ignore (FIXME: check before merge)
  rescue Couchbase::Error::DesignDocumentNotFound
    # ignore (FIXME: check before merge) (7.1)
  end

  it 'does not allow n1ql to override existing methods' do
    expect { ViewTest.view :all }.to raise_error(ArgumentError)
  end

  it 'saves a new design document' do
    begin
      ViewTest.bucket.view_indexes.drop_design_document(ViewTest.design_document, :production)
    rescue Couchbase::Error::InternalServerFailure
    # ignore if design document does not exist
    rescue Couchbase::Error::DesignDocumentNotFound
      # ignore if design document does not exist (7.1)
    end
    expect(ViewTest.ensure_design_document!).to be(true)
  end

  it 'does not re-save a design doc if nothing has changed' do
    expect(ViewTest.ensure_design_document!).to be(false)
  end

  it 'returns an empty array when there is no objects' do
    expect(ViewTest.vall).to eq([])
  end

  it 'performs a map-reduce and return the view' do
    ViewTest.ensure_design_document!
    ViewTest.create! name: :bob, rating: :good

    docs = ViewTest.vall.collect do |ob|
      ob.destroy
      ob.name
    end
    expect(docs).to eq(['bob'])
  end

  it 'works with other keys' do
    ViewTest.ensure_design_document!
    ViewTest.create! name: :bob,  rating: :good
    ViewTest.create! name: :jane, rating: :awesome
    ViewTest.create! name: :greg, rating: :bad

    docs = ViewTest.by_rating(order: :descending).collect do |ob|
      ob.destroy
      ob.name
    end
    expect(docs).to eq(%w[greg bob jane])
  end

  it 'returns matching results' do
    ViewTest.ensure_design_document!
    ViewTest.create! name: :bob,  rating: :awesome
    ViewTest.create! name: :jane, rating: :awesome
    ViewTest.create! name: :greg, rating: :bad
    ViewTest.create! name: :mel,  rating: :good

    docs = ViewTest.find_by_rating(1).collect(&:name)

    expect(Set.new(docs)).to eq(Set.new(%w[bob jane]))
  end
end
