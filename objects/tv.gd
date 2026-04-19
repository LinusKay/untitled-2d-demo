extends Sprite2D

enum npc_resource_enum {
	news_anchor = 0,
	gary = 1,
}

var npc_resources: Array[Resource] = [
	 load("res://npcs/npc_news_02/npc_resource_news_02.tres"),
	 load("res://npcs/npc_news_01/npc_resource_news_01.tres"),
]

var tv_lines: Array[Array] = [
	[
		["A news program is on."],
		["...ing back now to the weather - Gary, how are things?", npc_resource_enum.news_anchor],
		["THE SUN. THE SUN IS BLINDING.", npc_resource_enum.gary],
		["Thanks, Gary! Next up, sports!", npc_resource_enum.news_anchor]
	],
	[
		["No TV today, everyone went to the beach :-)"]
	],
	[
		["A news program is on."],
		["...Gary! Weather?", npc_resource_enum.news_anchor],
		["Its still out there!", npc_resource_enum.gary],
		["Amazing. Sports up next.", npc_resource_enum.news_anchor]
	],
	#[
		#"A news program is on.",
		#"...tching now to Gary on location. Gary, how's the weather looking anyway?",
		#"*indistinguishable*",
		#"We can't hear you, Gary, try that again.",
		#"#@@#(*^%#!&#%&)#@%-ornado-##&$**(!@*!#&)",
		#"Speak up, Gary! The people need the weather!",
		#"*indistinguishable*",
		#"It appears we've lost the camera feed there.",
		#"and I've just had word that Gary is now travelling at high speed nearly 1,000 metres above land.",
		#"He is expected to make landfall sometime in the next couple of hours.",
		#"Next up, Sports! How're those Canaries looking, Lisa?"
		#],
	#[
		#"A news program is on.",
		#"...and now Gary with the weather. How's it looking, Gary?",
		#"...",
		#"Gary is on holiday.",
		#"...",
		#"Rainy, I guess."
	#]
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tv_lines.shuffle()
	var todays_lines: Array = tv_lines[0]
	var dialogue_text_tscn: PackedScene = load("res://gui/dialogue_system/dialogue_text.tscn")
	for line: Array in todays_lines:
		var dialogue: Node = dialogue_text_tscn.instantiate()
		dialogue.text = line[0]
		if line.size() > 1:
			if line[1] != null:
				dialogue.npc_info = npc_resources[line[1] as int]
		$InteractionDialogue.add_child(dialogue)
	$InteractionDialogue.collect_dialogue_items() 
