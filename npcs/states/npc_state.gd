class_name NPCState extends Node

var npc: NPC
var state_machine: NPCStateMachine
@export var next_state: NPCState

func init() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> NPCState:
	return null


func physics(_delta: float) -> NPCState:
	return null
