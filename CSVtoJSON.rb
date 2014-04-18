require 'logger'
require 'JSON'

class String
  def numeric?
    return true if self =~ /^\d+$/
    true if Float(self) rescue false
  end
end

class CSVtoJSON
  MODIFIER_NAME = "modifier"

  def initialize
    logFile = File.open('csvtojson.log')
    @logger = Logger.new logFile
  end

  def parse(file_contents)
    #input: 
    #        file_content is the content of the CSV file
    #output: ruby array containing a JSON representation of the CSV file
    parsedArray = []
    lines = file_contents.split("\n")
    keyArr = keys(lines.first)
    lines=lines[1..-1]
    lines.each do |line|
      begin
        itemDict = {}
        values=line.split(",")
        values.each_with_index do |value, index|
          value=sanitizeInputs(value)
          key = keyArr[index]
          findModifier = key.match(/#{MODIFIER_NAME}(_)(\d+)(_)/)
          if findModifier
            modifier=key[findModifier.offset(0)[1]..-1]
            modifierIndex = findModifier[2].to_i-1
            modifierHash = itemDict[MODIFIER_NAME] ? {MODIFIER_NAME=>itemDict[MODIFIER_NAME]} : nil
            itemDict.merge!(parseModifierField(modifier,value,modifierIndex,modifierHash))
          else
            itemDict[key]=value
          end
        end
        parsedArray.push(itemDict)
      rescue Exception => e
	puts "Error: #{e} on the following line - #{line}"
	@logger.error "#{e} on the following line - #{line}"
      end
    end
    return parsedArray
  end
private
  def sanitizeInputs(value)
    value = value.strip
    if value.empty?
      #empty values should be nil instead of an empty string
      return nil                     
    end

    if value.start_with?("$")
      #money is formatted as decimal, drop $ symbol
      return value[1..value.size].to_f
    end

    if value.to_i.to_s==value
      #check to see if numbers can be converted to integers
      return value.to_i
    end

    if value.numeric?
      #check to see if numbers can be converted to floats
      return value.to_f
    end

    return value
  end
  def parseModifierField(modifierKey,modifierValue,modifierIndex,modifierHash)
    if !modifierHash
      modifierHash = {MODIFIER_NAME=>[]}
    end 
    if modifierHash[MODIFIER_NAME][modifierIndex]
      #Add field to existing modifier item
      modifierHash[MODIFIER_NAME][modifierIndex].merge!({modifierKey => modifierValue})
    else
      #Add field to new modifier item
      modifierHash[MODIFIER_NAME].push({modifierKey => modifierValue})
    end
    return modifierHash
  end
  def keys(keys)
    keyArr=keys.split(',').map{|a| a.strip}
    return keyArr
  end
end

if __FILE__ == $0
  while (true)
    ctj=CSVtoJSON.new
    filesToProcess = Dir.entries("./toProcess")
    #remove current dir and parent dir
    filesToProcess = filesToProcess.select{|file| file.match(/\.csv/)}

    filesToProcess.each do |filename|
      filePath = "./toProcess/#{filename}"
      file = File.open(filePath)
      parsedData = ctj.parse(file.read)
      jsonFile= File.write("./done/#{filename}.json", parsedData.to_json)
      File.rename(filePath,"./done/#{filename}")
    end
    #set the frequency to check for file updates
    #In a production system make this a rake task and schedule a cron job
    sleep(1)
  end
end
