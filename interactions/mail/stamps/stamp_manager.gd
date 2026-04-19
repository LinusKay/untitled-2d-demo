extends Node

@warning_ignore("unused_signal")
signal stamp_collected

var collected_stamps: Array[MailStamp] = []


func collect_stamp(new_stamp: MailStamp) -> bool:
	if not collected_stamps.has(new_stamp):
		collected_stamps.append(new_stamp)
		stamp_collected.emit()
		return true
	return false


func get_stamp_count() -> int:
	return collected_stamps.size()
