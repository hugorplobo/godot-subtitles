extends VideoPlayer

export (String, FILE) var subtitle_path
export (NodePath) var label_path

onready var label : Label = get_node(label_path)
var subtitle_file : File
var subtitle_content : PoolStringArray
var parsed_subtitle : Array

func _process(delta) -> void:
	if len(parsed_subtitle) < 1:
		return
	
	if stream_position >= parsed_subtitle[0]["start"]:
		label.text = parsed_subtitle[0]["content"]
	
	if stream_position >= parsed_subtitle[0]["end"]:
		label.text = ""
		parsed_subtitle.pop_front()

func _ready() -> void:
	subtitle_file = File.new()
	subtitle_file.open(subtitle_path, File.READ)
	subtitle_content = subtitle_file.get_as_text().split("\n\n")
	parser()
	play()

func parser() -> void:
	for subtitle in subtitle_content:
		var splitted_subtitle = subtitle.split("\n")
		var num_elements = 3
		
		if len(splitted_subtitle) > num_elements:
			var new_splitted_subtitle = [splitted_subtitle[0], splitted_subtitle[1], ""]
			
			for i in range(num_elements - 1, len(splitted_subtitle)):
				new_splitted_subtitle[-1] += "\n" + splitted_subtitle[i]
			
			splitted_subtitle = new_splitted_subtitle
		
		var time_range = splitted_subtitle[1].split(" --> ")
		var content = splitted_subtitle[2]
		
		parsed_subtitle.append({
			"start": parse_time(time_range[0]),
			"end": parse_time(time_range[1]),
			"content": content
		})

func parse_time(time : String) -> float:
	var splitted_time = time.replace(",", ".").split(":")
	var float_time : PoolRealArray
	for time in splitted_time:
		float_time.append(float(time))
	
	return (float_time[0] * 60 * 60) + (float_time[1] * 60) + float_time[2]
