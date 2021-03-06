extends "res://Scripts/Worlds/WorldTemplate.gd"

onready var Tips = $Path2D/Tips
onready var TipsImage = $Path2D/Tips/Sprite
onready var TipsAnimator = $Path2D/Tips/AnimationPlayer

func _ready():
	WorldCamera.set_camera_limits($GridLimits)
	TipsImage.flip_h = true
	
	$ControlsLayer/ControlsUI.hide()

func _on_Player_win():
	pass

func _on_Tips_goto_next_offset(offset_id):
	match offset_id:
		1,2,5,7:
			TipsImage.flip_h = false
			continue

func _on_Tips_reached_offset(offset_id):
	match offset_id:
		1,4,6:
			TipsImage.flip_h = true
			continue


func _on_EndAnimation_body_entered(body):
	if body.is_in_group("Player"):
		$Player.controls_enabled = false
		$Player.animations_enabled = false
		$Player.velocity = Vector2(-200,-120)
		$Player._PlayerSprite.play("CutsceneFall")
		Tips.goto_next_offset()
		
		WorldCamera.shake(2.0, 1.0)
		$AnimationPlayer.play("ShowControls")
		yield($AnimationPlayer, "animation_finished")
		
		Global.set_transition(3)
		Global.goto_scene(next_level)

func retrieve_all_controls():
	$Objects/BreakParticles.emitting = true
	for node in [$Objects/ControlPropJump,$Objects/ControlPropLeft,$Objects/ControlPropRight]:
		node.hide()
	for node in [$Objects/ControlRight,$Objects/ControlLeft,$Objects/ControlJump]:
		node.visible = true
		$ControlsLayer/ControlsUI._on_Control_retrieve_from_world(node)

func break_end_platforms():
	$Tilemaps/PlatformTileMap.set_cell(57,11,-1)
	$Tilemaps/PlatformTileMap.set_cell(58,11,-1)
	$Tilemaps/PlatformTileMap/CPUParticles2D.emitting = true
	
	$Player.animations_enabled = true
	$Player.velocity = Vector2(0,-140)
	
