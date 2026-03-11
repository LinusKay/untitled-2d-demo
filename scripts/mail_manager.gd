extends Node

var next_free_id: int = 0

var mail_bag: Array[MailLetter] = [
	
]


func _ready() -> void:
	var mail1: MailLetter = create_mail(
		"ORANGE",
		"BLUE",
		"▲"
	)
	mail_bag.append(mail1)
	var mail2: MailLetter = create_mail(
		"BLUE",
		"GREEN",
		"■▲■■⬤"
	)
	mail_bag.append(mail2)

	debug_pring_mail()
	delete_mail(1)
	debug_pring_mail()
	

func get_mail_bag() -> Array[MailLetter]:
	return mail_bag


## Raw prints out current mail bag contents
func debug_pring_mail() -> void:
	for mail: MailLetter in mail_bag:
		print(mail.mail_id, mail.mail_from, mail.mail_to, mail.mail_location)
	

## Safely creates a new mail object with a unique ID
##
## Returns the newly created MailLetter object
func create_mail(_mail_from: String, _mail_to: String, _mail_location: String) -> MailLetter:
	var new_mail: MailLetter = MailLetter.new(
		next_free_id,
		_mail_from,
		_mail_to,
		_mail_location
	)
	next_free_id += 1
	return new_mail


## Takes a mail ID and checks the mail bag for it
##  
## If mail is found and deleted, returns true
## Otherwise, returns false
func delete_mail(_mail_id: int) -> bool:
	for mail_index: int in mail_bag.size():
		if mail_bag[mail_index].mail_id == _mail_id:
			mail_bag.remove_at(mail_index)
			return true
	return false
