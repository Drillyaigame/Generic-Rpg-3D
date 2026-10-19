extends Control

var player: RPGPlayer
var joystick_id := -1
var stick_center := Vector2.ZERO
var stick_offset := Vector2.ZERO
var attack_id := -1
const RADIUS := 90.0

func _ready() -> void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 mouse_filter = Control.MOUSE_FILTER_IGNORE
 set_process_input(true)

func _draw() -> void:
 var center := Vector2(125, size.y - 130)
 draw_circle(center, RADIUS, Color(0.1, 0.13, 0.18, 0.40))
 draw_arc(center, RADIUS, 0, TAU, 48, Color(1, 1, 1, 0.55), 4)
 draw_circle(center + stick_offset, 37, Color(0.85, 0.92, 1, 0.65))
 var attack_center := Vector2(size.x - 125, size.y - 130)
 draw_circle(attack_center, 72, Color(0.8, 0.12, 0.12, 0.55))
 draw_arc(attack_center, 72, 0, TAU, 48, Color(1, 1, 1, 0.65), 4)
 draw_string(ThemeDB.fallback_font, attack_center + Vector2(-36, 9), "UTOK", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.WHITE)

func _input(event: InputEvent) -> void:
 if event is InputEventScreenTouch:
  var p: Vector2 = event.position
  var center := Vector2(125, size.y - 130)
  var attack_center := Vector2(size.x - 125, size.y - 130)
  if event.pressed:
   if joystick_id == -1 and p.distance_to(center) < 145:
    joystick_id = event.index
    _move_stick(p, center)
   elif attack_id == -1 and p.distance_to(attack_center) < 100:
    attack_id = event.index
    if is_instance_valid(player):
     player.attack()
  else:
   if event.index == joystick_id:
    joystick_id = -1
    stick_offset = Vector2.ZERO
    if is_instance_valid(player):
     player.mobile_vector = Vector2.ZERO
   if event.index == attack_id:
    attack_id = -1
  queue_redraw()
 elif event is InputEventScreenDrag and event.index == joystick_id:
  _move_stick(event.position, Vector2(125, size.y - 130))

func _move_stick(p: Vector2, center: Vector2) -> void:
 stick_offset = (p - center).limit_length(RADIUS)
 if is_instance_valid(player):
  player.mobile_vector = stick_offset / RADIUS
 queue_redraw()







