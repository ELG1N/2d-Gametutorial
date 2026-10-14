## 
## Author:
## 	James Huston
##
## Email:
## 	huston@uleth.ca
##
## Description:
## 	Load json files which I am using as a form of dialogue storage. And pass the
## 	parsed file data to which ever scene script calls it.
##

##
## Name:
## 	open_and_read_file
##
## Description:
## 	loads a file from a provided path, and returns the text within it.
##
## Parameters:
## 	path: [String] -> The path to the file
##
## Returns:
## 	content: [String] -> The content within the file
##
## Errors:
## 	Will fail/pause program in debug modes if the file cannot be found or is
## 	inaccessible: "File **name** not found or not accessible".
##
static func open_and_read_file(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	assert(file != null, "File %s not found or not accessible" % path)
	var content: String = file.get_as_text()
	return content

##
## Name:
## 	convert_string_to_json
##
## Description:
## 	Converts a provided string into a JSON object.
##
## Parameters:
## 	dialogue_file_content: [String] -> The content within the file
##
## Returns:
## 	data: [JSON] -> The content of the file parsed to json
##
## Errors:
## 	Will fail/pause the program in debug mode if the string data cannot be
##  parsed to JSON: "JSON is formmatted incorrecly or is null"
##
static func convert_string_to_json(dialogue_file_content: String) -> Dictionary:
	var json = JSON.new()
	var parse_json_result: Error = json.parse(dialogue_file_content)
	assert(parse_json_result != null, "JSON is formatted incorrectly or is null.")
	var data: Dictionary = json.data
	return data

##
## Name:
## 	load_dialogue_from_path
##
## Description:
## 	Wrapper function for the two above, takes in a path to a json file,
## 	and outputs the parsed json.
##
## Parameters:
## 	path: [String] -> The path to the json file
##
## Returns:
## 	parsed_json: [JSON] -> The content of the file parsed to json
##
## Errors:
## 	None
##
static func load_dialogue_from_path(path: String) -> Dictionary:
	var dialogue_file_content: String = open_and_read_file(path)
	var parsed_json: Dictionary = convert_string_to_json(dialogue_file_content)
	return parsed_json
