extends Control


func _on_calisthenics_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Calisthenics Area")


func _on_calisthenics_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()


func _on_group_fitness_class_a_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Group Fitness Class A")


func _on_group_fitness_class_a_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()



func _on_group_fitness_class_b_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Group Fitness Class B")


func _on_group_fitness_class_b_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()


func _on_cardio_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Cardio Area")


func _on_cardio_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()


func _on_pull_down_machines_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Muscle Gain Area")


func _on_pull_down_machines_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()


func _on_bench_presses_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Muscle Gain Area")


func _on_bench_presses_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()


func _on_benches_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Muscle Gain Area")


func _on_benches_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()


func _on_sm_machines_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Muscle Gain Area")


func _on_sm_machines_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()

func _on_megan_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Megan, Dietitian")


func _on_megan_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()


func _on_jody_area_3d_body_entered(body: Node3D) -> void:
	show_elements("Jody, Personal Trainer")


func _on_jody_area_3d_body_exited(body: Node3D) -> void:
	hide_elements()

func show_elements(text:String):
	$BottomPanel/InteractLabel.show()
	$TopPanel/InfoLabel.show()
	$TopPanel/InfoLabel.text = text
	
func hide_elements():
	$BottomPanel/InteractLabel.hide()
	$TopPanel/InfoLabel.hide()
	
