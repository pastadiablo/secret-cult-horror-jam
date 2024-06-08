@tool
class_name CardNode extends Control

@export var card: Card

@export var subviewportContainer: SubViewportContainer
@export var cardRootContainer: Container
@export var title: Label
@export var depiction: TextureRect
@export var effects: RichTextLabel
@export var cardBack: Control

@export_group("Card Drag Animation Properties")
@export var dragTiltMaxAngle = 10.0
@export var dragTiltSpeed = 0.1
@export var snapBackSpeed = 10.0
@export var hoverScale = Vector2(1.1, 1.1)
@export var scaleGrowSpeed = .1
@export var scaleShrinkSpeed = .2

@export_range(-360, 360) var rotationX: float:
	get: return rotationX
	set(value):
		var newVal = WrapWithOverflow(value, -180, 180)
		cardBack.visible = newVal < -90 || newVal >= 90 
		subviewportContainer.material.set("shader_parameter/x_rot", newVal)
		rotationX = value
@export_range(-360, 360) var rotationY: float:
	get: return rotationY
	set(value):
		var newVal = WrapWithOverflow(value, -180, 180)
		cardBack.visible = newVal < -90 || newVal >= 90
		subviewportContainer.material.set("shader_parameter/y_rot", newVal)
		rotationY = value
@export_range(-360, 360) var rotationZ: float:
	get: return rad_to_deg(rotation)
	set(value):
		rotation = deg_to_rad(value)

func WrapWithOverflow(value: float, minValue: float, maxValue) -> float:
	if (minValue > maxValue):
		push_error("Cannot wrap with a minValue higher than maxValue!")
	if (value < minValue):
		return maxValue - (minValue - value)
	elif (value > maxValue):
		return minValue + (value - maxValue)
	else:
		return value

var _hovering = false
var _dragging = false
var _drag_offset = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	title.text = card.name
	depiction.texture = card.depiction
	if (_hovering || _dragging):
		scale = lerp(scale, hoverScale, scaleGrowSpeed)
	else:
		scale = lerp(scale, Vector2.ONE, scaleShrinkSpeed)
	
	if (rotationX != 0):
		rotationX = move_toward(rotationX, 0, snapBackSpeed * delta) #lerpf(rotationX, 0, snapBackSpeed * delta)
	if (rotationY != 0):
		rotationY = move_toward(rotationY, 0, snapBackSpeed * delta) #lerpf(rotationY, 0, snapBackSpeed * delta)
	
	if !card: return
	var effectsText = ""
	for effect in card.effects:
		if !effect: continue
		effectsText += effect.GetEffectDescription()
	effects.text = effectsText
	

func _gui_input(event: InputEvent) -> void:
		
	if event is InputEventMouseMotion:
		if _dragging:
			position = get_global_mouse_position() + _drag_offset
			var velocityNormal = event.velocity.normalized()
			var targetRotationX = dragTiltMaxAngle if velocityNormal.y < 0 else -dragTiltMaxAngle
			var targetRotationY = dragTiltMaxAngle if velocityNormal.x > 0 else -dragTiltMaxAngle
			rotationX = move_toward(rotationX, targetRotationX, abs(velocityNormal.y * dragTiltSpeed))
			rotationY = move_toward(rotationY, targetRotationY, abs(velocityNormal.x * dragTiltSpeed))
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.is_pressed() && !_dragging:
					_dragging = true
					_drag_offset = (global_position - get_global_mouse_position())/scale
					cardRootContainer.mouse_default_cursor_shape = Control.CURSOR_DRAG
					print("Setting Cursor Drag Shape")
				else:
					if event.is_released():
						_dragging = false
						_drag_offset = 0
						cardRootContainer.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
						print("Setting Cursor Pointing Shape")
				
func _mouse_entered() -> void:
	_hovering = true
	
func _mouse_exited() -> void:
	_hovering = false
	if _dragging: return
	pass
