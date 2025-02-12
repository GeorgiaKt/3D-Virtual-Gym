class_name Player extends CharacterBody3D

@onready var general_progress_bar: ProgressBar = $UI/TopPanel/ScorePanel/ProgressBar

@export_category("Player")
@export_range(1, 35, 1) var speed: float = 10 # m/s
@export_range(10, 400, 1) var acceleration: float = 100 # m/s^2

@export_range(0.1, 3.0, 0.1) var jump_height: float = 1 # m
@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

@onready var camera: Camera3D = $PlayerCamera


#flags to determine whether the player interacted or has entered in specific area
var has_interacted:bool =  false
var has_entered:bool = false
var minigame_isVisible = false
var calisthenics_entered:bool = false
var groupFitnessClassA_entered:bool = false
var groupFitnessClassB_entered:bool = false
var cardio_entered:bool = false
var pullDownMachines_entered:bool = false
var benchPresses_entered:bool = false
var benches_entered:bool = false
var smMachines_entered:bool = false
var megan_dietitian_entered:bool = false
var jody_trainer_entered:bool = false


func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()
#	if Input.is_action_just_pressed("jump"): jumping = true
	if Input.is_action_just_pressed("exit"): handle_exit()
	if Input.is_action_just_pressed("interact"): handle_interaction()

func _physics_process(delta: float) -> void:
	if not has_interacted:
		velocity = _walk(delta) + _gravity(delta) #+ _jump(delta)
		move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

#func _jump(delta: float) -> Vector3:
	#if jumping:
		#if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * jump_height * gravity), 0)
		#jumping = false
		#return jump_vel
	#jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	#return jump_vel

func _process(delta: float) -> void:
	general_progress_bar.value = Global.general_progress #continuously update the bar based on global progress
	if has_interacted and has_entered: #when player has entered and interacted with an are, hide UI
		$UI/BottomPanel/InteractLabel.hide()
		$UI/TopPanel/InfoLabel.hide()
		$UI/TopPanel/ReturnLabel.show()
	if not has_interacted and has_entered: #when player has entered an area but has not interacted with it, show UI
		$UI/BottomPanel/InteractLabel.show()
		$UI/TopPanel/InfoLabel.show()
		$UI/TopPanel/ReturnLabel.hide()
		
	Dialogic.VAR.score_perc = Global.general_progress #update variable for fitness score used in dialog


func handle_exit():
	if minigame_isVisible: #if mini game is running, close it
		$UI/MiddlePanel.hide()
		$UI/BottomPanel/PlayLabel.hide()
		minigame_isVisible = false
		has_interacted = false
	elif not minigame_isVisible: #if mini game is closed
		if Dialogic.current_timeline !=null: #close dialog if there is one running
			Dialogic.end_timeline()
			capture_mouse()
			has_interacted = false
		else: #else close app
			get_tree().quit()



func handle_interaction():
	has_interacted = true;
	if jody_trainer_entered:
		prepareForDialog("jody_trainer_timeline")
	elif megan_dietitian_entered:
		prepareForDialog("megan_dietitian_timeline")
	elif calisthenics_entered or groupFitnessClassA_entered or groupFitnessClassB_entered or cardio_entered:
		prepareForMiniGame()
	elif pullDownMachines_entered or benchPresses_entered or benches_entered or smMachines_entered:
		prepareForMiniGame()



func prepareForDialog(timeline:String):	
	Dialogic.start(timeline)
	release_mouse()

func prepareForMiniGame():
	minigame_isVisible = true
	$UI/MiddlePanel.show()
	$UI/BottomPanel/PlayLabel.show()

func _on_calisthenics_area_3d_body_entered(body: Node3D) -> void:
	calisthenics_entered = true
	has_entered = true

func _on_calisthenics_area_3d_body_exited(body: Node3D) -> void:
	calisthenics_entered = false
	has_entered = false

func _on_group_fitness_class_a_area_3d_body_entered(body: Node3D) -> void:
	groupFitnessClassA_entered = true
	has_entered = true

func _on_group_fitness_class_a_area_3d_body_exited(body: Node3D) -> void:
	groupFitnessClassA_entered = false
	has_entered = false

func _on_group_fitness_class_b_area_3d_body_entered(body: Node3D) -> void:
	groupFitnessClassB_entered = true
	has_entered = true

func _on_group_fitness_class_b_area_3d_body_exited(body: Node3D) -> void:
	groupFitnessClassB_entered = false
	has_entered = false

func _on_cardio_area_3d_body_entered(body: Node3D) -> void:
	cardio_entered = true
	has_entered = true

func _on_cardio_area_3d_body_exited(body: Node3D) -> void:
	cardio_entered = false
	has_entered = false

func _on_pull_down_machines_area_3d_body_entered(body: Node3D) -> void:
	pullDownMachines_entered = true
	has_entered = true

func _on_pull_down_machines_area_3d_body_exited(body: Node3D) -> void:
	pullDownMachines_entered = false
	has_entered = false

func _on_bench_presses_area_3d_body_entered(body: Node3D) -> void:
	benchPresses_entered = true
	has_entered = true

func _on_bench_presses_area_3d_body_exited(body: Node3D) -> void:
	benchPresses_entered = false
	has_entered = false

func _on_benches_area_3d_body_entered(body: Node3D) -> void:
	benches_entered = true
	has_entered = true

func _on_benches_area_3d_body_exited(body: Node3D) -> void:
	benches_entered = false
	has_entered = false

func _on_sm_machines_area_3d_body_entered(body: Node3D) -> void:
	smMachines_entered = true
	has_entered = true

func _on_sm_machines_area_3d_body_exited(body: Node3D) -> void:
	smMachines_entered = false
	has_entered = false

func _on_megan_area_3d_body_entered(body: Node3D) -> void:
	megan_dietitian_entered = true
	has_entered = true

func _on_megan_area_3d_body_exited(body: Node3D) -> void:
	megan_dietitian_entered = false
	has_entered = false

func _on_jody_area_3d_body_entered(body: Node3D) -> void:
	jody_trainer_entered = true
	has_entered = true

func _on_jody_area_3d_body_exited(body: Node3D) -> void:
	jody_trainer_entered = false
	has_entered = false
