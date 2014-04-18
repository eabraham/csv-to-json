# CSVtoJSON
class CSVtoJSON
  MODIFIER_NAME = "modifier"

  def keys(keys)
    return keys.split(',')
  end

  def defineBaseObject(keys)
    #this method defines the empty base object structure which can be
    #traversed later loading data
    @baseObject = {}
    @keys.each do |key|
      findModifier = key.match(/#{MODIFIER_NAME}(_)(\d+)(_)/)
      if findModifier
	#is a modifier field
        modifier=key[findModifier.offset(0)[1]..-1]
        previousMod=@baseObject[MODIFIER_NAME] 
	modVal = previousMod.append({modifier=>nil})
        @baseObject.merge!(modVal)
      else
        @baseObject.merge!({key=>nil})
      end
    end
    return @baseObject
  end

  def parse(file_contents)
    #inputs: file_contents is the contents of the CSV file without keys
    #outputs: ruby array containing a representation of the CSV file
    parsedArray = []
    lines = file_contents.split("\n")
    lines.each do |line|
      itemDict = {}
      values=line.split(",")
      values.each_with_index do |index,value|
	key = @keys[index]
        modifier = key.match(/(_)(\d+)(_)/)
        field = {}
	#currently handles a single depth of modifier
        if modifier
          modFieldName = key[modifier.offset(0)[1]..-1]
          if field.class==Hash
	    field=[]
	  end
	  field.append({modFieldName=>value})
        end

	   
      end
    end
  end
end
