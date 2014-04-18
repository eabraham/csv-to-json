require './CSVtoJSON'

shared_context "shared_test_data" do
  before do
    begin
      @file = File.open('test_data.csv','r')
      @keys = @file.first
    rescue
      #TODO: Be more specific about the error types
      puts "Test file doesn't exist or is empty"
    end
    @sample_parsed = {
	               "id"=>111010,
		       "description"=>"Coffee",
		       "price"=>1.25,
		       "cost"=>0.8,
		       "price_type"=>"system",
		       "quantity_on_hand"=>100000,
		       "modifier"=>[
			       {"name"=>"Small",
			        "price"=>"-$0.25"},
			       {"name"=>"Medium",
			        "price"=>0.0},
			       {"name"=>"Large",
			        "price"=>0.3}
                               ]
                       }
  end
end

describe CSVtoJSON, "#sanitizeInputs" do
  it "check for money" do
    ctj = CSVtoJSON.new
    t1 = ctj.send(:sanitizeInputs,"$2.43")
    t2 = ctj.send(:sanitizeInputs,"$3.00")
    expect(t1).to eq(2.43)
    expect(t2).to eq(3.00)
  end
  it "check for floats" do
    ctj = CSVtoJSON.new
    t1 = ctj.send(:sanitizeInputs,"2.43")
    t2 = ctj.send(:sanitizeInputs,"3.00")
    expect(t1).to eq(2.43)
    expect(t2).to eq(3.00)
  end
  it "check for integers" do
    ctj = CSVtoJSON.new
    t1 = ctj.send(:sanitizeInputs,"2")
    t2 = ctj.send(:sanitizeInputs,"3")
    expect(t1).to eq(2)
    expect(t2).to eq(3)
  end
  it "check for empty strings" do
    ctj = CSVtoJSON.new
    t1 = ctj.send(:sanitizeInputs,"")
    expect(t1).to eq(nil)
  end
end

describe CSVtoJSON, "#keys" do include_context "shared_test_data"

  it "sets keys of JSON file" do
    ctj = CSVtoJSON.new
    t1 = ctj.send(:keys,@keys)
    expect(["id","description","price","cost","price_type","quantity_on_hand",
	   "modifier_1_name","modifier_1_price","modifier_2_name","modifier_2_price",
	   "modifier_3_name","modifier_3_price"]).to eq(t1)
  end
end

describe CSVtoJSON, "#parse" do include_context "shared_test_data"
  it "convert to ruby dictionary and array" do
     ctj = CSVtoJSON.new
     result = ctj.parse(@keys+@file.read)
     puts result
     expect(result[0]).to eq(@sample_parsed)
  end
end
