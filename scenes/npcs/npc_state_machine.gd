class_name NPCStateMachine extends Node

var states: Array[NPCState]
var prev_state: NPCState
var curr_state: NPCState


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	change_state(curr_state.process(delta))


func _physics_process(delta: float) -> void:
	change_state(curr_state.physics(delta))


func init(_npc: NPC) -> void:
	states = []
	
	for child: Node in get_children():
		if child is NPCState:
			states.append(child)
	
	for state: NPCState in states:
		state.npc = _npc
		state.state_machine = self
		state.init()
	
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state: NPCState) -> void:
	if new_state == null or new_state == curr_state:
		return
		
	if curr_state:
		curr_state.exit()
		
	prev_state = curr_state
	curr_state = new_state
	curr_state.enter()
