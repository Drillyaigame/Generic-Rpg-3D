extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player.gd")
const ENEMY_SCRIPT = preload("res://scripts/enemy.gd")
const MOBILE_SCRIPT = preload("res://scripts/mobile_controls.gd")
var player: RPGPlayer
var enemies_defeated := 0
var spawn_timer := 0.0
var health_label: Label
var score_label: Label
var message_label: Label
var rng := RandomNumberGenerator.new()

func _ready() -> void:
 rng.randomize()
 _create_environment()
 player = CharacterBody3D.new()
 player.set_script(PLAYER_SCRIPT)
 player.position = Vector3(0, 0.15, 0)
 add_child(player)
 player.health_changed.connect(_update_health)
 player.died.connect(_player_died)
 _create_ui()
 _create_mobile_controls()
 _update_health(player.health)
 for i in range(5):
  _spawn_enemy()

func _process(delta: float) -> void:
 spawn_timer += delta
 if spawn_timer >= 5.0:
  spawn_timer = 0.0
  if get_tree().get_nodes_in_group("enemies").size() < 5:
   _spawn_enemy()

func _create_environment() -> void:
 var environment := WorldEnvironment.new()
 var env := Environment.new()
 env.background_mode = Environment.BG_COLOR
 env.background_color = Color(0.49, 0.72, 0.92)
 env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
 env.ambient_light_color = Color(0.8, 0.84, 1.0)
 environment.environment = env
 add_child(environment)
 var sun := DirectionalLight3D.new()
 sun.rotation_degrees = Vector3(-55, -35, 0)
 sun.light_energy = 1.4
 add_child(sun)
 _make_box(Vector3(0, -0.6, 0), Vector3(48, 1, 48), Color(0.22, 0.49, 0.24), true)
 for i in range(28):
  var x := rng.randf_range(-22, 22)
  var z := rng.randf_range(-22, 22)
  if Vector2(x, z).length() < 5:
   continue
  _make_box(Vector3(x, 0.65, z), Vector3(1.2, 1.3, 1.2), Color(0.38, 0.28, 0.2), true)
  _make_box(Vector3(x, 2.0, z), Vector3(2.5, 1.8, 2.5), Color(0.12, 0.38, 0.17), false)
 for i in range(8):
  var x := -17.0 + float(i % 4) * 10.0
  var z := -17.0 + float(i / 4) * 30.0
  _make_box(Vector3(x, 0.7, z), Vector3(3, 1.4, 3), Color(0.47, 0.45, 0.4), true)

func _make_box(pos: Vector3, dimensions: Vector3, color: Color, solid: bool) -> void:
 var root := StaticBody3D.new() if solid else Node3D.new()
 root.position = pos
 add_child(root)
 var visual := MeshInstance3D.new()
 var box := BoxMesh.new()
 box.size = dimensions
 visual.mesh = box
 var mat := StandardMaterial3D.new()
 mat.albedo_color = color
 visual.material_override = mat
 root.add_child(visual)
 if solid:
  var collision := CollisionShape3D.new()
  var shape := BoxShape3D.new()
  shape.size = dimensions
  collision.shape = shape
  root.add_child(collision)

func _spawn_enemy() -> void:
 var enemy := CharacterBody3D.new()
 enemy.set_script(ENEMY_SCRIPT)
 var angle := rng.randf_range(0, TAU)
 var distance := rng.randf_range(9, 17)
 var pos := player.global_position + Vector3(cos(angle) * distance, 0, sin(angle) * distance)
 pos.x = clampf(pos.x, -21, 21)
 pos.z = clampf(pos.z, -21, 21)
 pos.y = 0.1
 enemy.position = pos
 add_child(enemy)
 enemy.defeated.connect(_enemy_defeated)

func _create_ui()
 _create_mobile_controls() -> void:
 var canvas := CanvasLayer.new()
 add_child(canvas)
 var panel := VBoxContainer.new()
 panel.position = Vector2(22, 18)
 canvas.add_child(panel)
 health_label = Label.new()
 health_label.add_theme_font_size_override("font_size", 26)
 panel.add_child(health_label)
 score_label = Label.new()
 score_label.text = "Poražení démoni: 0"
 score_label.add_theme_font_size_override("font_size", 22)
 panel.add_child(score_label)
 message_label = Label.new()
 message_label.text = "Joystick: pohyb  |  ÚTOK: boj"
 message_label.add_theme_font_size_override("font_size", 18)
 panel.add_child(message_label)

func _create_mobile_controls() -> void:
 var controls := Control.new()
 controls.set_script(preload("res://scripts/mobile_controls.gd"))
 controls.player = player
 var layer := CanvasLayer.new()
 layer.layer = 2
 add_child(layer)
 layer.add_child(controls)

func _update_health(value: int) -> void:
 if health_label:
  health_label.text = "Životy: %d / 100" % value

func _enemy_defeated() -> void:
 enemies_defeated += 1
 score_label.text = "Poražení démoni: %d" % enemies_defeated

func _player_died() -> void:
 message_label.text = "Byl jsi poražen! Znovu se objevuješ na startu."







