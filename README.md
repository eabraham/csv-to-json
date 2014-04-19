#csv-to-json
===========

Simple CSV to JSON parser that does field mapping and handles a "modifier" relationship.  All keys must be enumerated on the first lines of each CSV file.  Each line represents an item and an item's fields are seperated by commas.

'''
id,description,price,cost,price_type,quantity_on_hand,modifier_1_name,modifier_1_price,modifier_2_name,modifier_2_price,modifier_3_name,modifier_3_price
111010,Coffee,$1.25,$0.80,system,100000,Small,-$0.25,Medium,$0.00,Large,$0.30
'''

##Installation Instructions
1. git clone https://github.com/eabraham/csv-to-json.git

##Runtime Instructions
1. ruby 'CSVtoJSON.rb'
2. drop a formatted CSV File into the ./toProcess directory
3. original CSV file is moved to the done folder along with a new JSON file

##Assumptions

1. The parser would need to be robust and sanitize data of poor quality.  In the event that a single CSV line throws a fatal error, catch it and log it for future review before continuing to process the remainder of the file.
2. Considering that ShopKeep interacts with small businesses most of the files will be small (Max 100 lines) and not require a distributed solution to parse large CSV files. Many worker processes would be sufficient to convert thousands of files into JSON
3. This program is a source for a downstream ruby process which imports the JSON into a database

##Notes
1. Before installing in a production environment remove the while(true) block and sleep(1) lines and instead setup a cronjob which runs at the desired interval.
