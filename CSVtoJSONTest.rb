require './CSVtoJSON'

shared_context "shared_test_data" do
  before do
    begin
      @file = File.open('test_data.csv','r')
      @keys = file.first
    rescue
      #TODO: Be more specific about the error types
      puts "Test file doesn't exist or is empty"
    end
    @sample_parsed = [
	             {
	               "id"=> 111010,
		       "description"=> "Coffee",
                       "price"=> 1.25,
		       "cost"=> 0.8,
		       "price_type"=> "system",
	               "quantity_on_hand"=> 100000,
                       "modifier"=> [
                         {
                           "name"=> "Small",
                           "price"=> -0.25
                         },
                         {
                           "name"=> "Medium",
                           "price"=> 0
                         },
                         {
                           "name"=> "Large",
                           "price"=> 0.3
                         }
                       ]
                     } 
                   ]    
  end
end


describe CSVtoJSON, "#keys" do include_context "shared_test_data"

  it "sets keys of JSON file" do
    ctj = CSVtoJSON.new
    expect(["id","description","price","cost","price_type","quantity_on_hand",
	   "modifier_1_name","modifier_1_price","modifier_2_name","modifier_2_price",
	   "modifier_3_name","modifier_3_price"]).to eq(ctj.keys(@keys))
  end
end

describe CSVtoJSON, "#parse" do include_context "shared_test_data"
  it "convert to ruby dictionary and array" do
     ctj = CSVtoJSON.new
     ctj.keys=@keys
     result = ctj.parse(@file)
     expect([result[0]]).to eq(@sample_parsed)
  end
end
