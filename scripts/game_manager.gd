extends Node

var score: int = 0
var highscore: int = 0
var temp_score: int = 0  # score temp sampai waktu game habis

func reset_score():
	score = 0
	temp_score = 0  # reset score temp
	update_score_ui()

func add_score(points: int):
	temp_score += points  # update score temp
	score = temp_score
	update_score_ui()

func finalize_highscore():
	# update highscore jika waktu habis
	if temp_score > highscore:
		highscore = temp_score

func update_score_ui():
	var score_label = get_tree().root.get_node_or_null("DeliveryGame/UI/Panel/ScoreLabel") as Label
	if score_label:
		score_label.text = "Score: " + str(temp_score)  # menampilkan score temp
