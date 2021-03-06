require 'spec_helper'
require 'yaml'

describe "Multi API" do
  before(:all) do
    credentials = YAML.load(File.read(CREDENTIALS_FILE))
    key = credentials["key"]
    secret = credentials["secret"]
    @factual = Factual.new(key, secret)
  end

  it "should be able to do multi queries" do
    places_query = @factual.table("places").search('food').filters(:postcode => 90067)
    geocode_query = @factual.geocode(34.06021,-118.41828)

    responses = @factual.multi(
      :nearby_food => places_query,
      :factual_inc => geocode_query)

    responses[:nearby_food].rows.length.should == 20
    responses[:nearby_food].rows.each do |row|
      row.class.should == Hash
      row.keys.should_not be_empty
    end

    responses[:factual_inc].first["postcode"].should == "90067"
  end
end
