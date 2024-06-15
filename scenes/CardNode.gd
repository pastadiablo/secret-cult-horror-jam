@tool
class_name CardNode extends Control

@export var card: Card

signal DragStart(node: CardNode)
signal DragEnd(node: CardNode)

@export var subviewportContainer: SubViewportContainer
@export var cardRootContainer: Container
@export var backPanelContainer: PanelContainer
@export var title: Label
@export var depiction: TextureRect
@export var effects: RichTextLabel
@export var cardBack: Control
@export var elementContainers: Array[PanelContainer] = []
@export var soulCostContainer: Container

@export_group("Card Drag Animation Properties")
@export_subgroup("Position")
@export var targetPosition: Vector2 = Vector2.ZERO
@export var snapBackTime = 1.0
@export var snapBackCurve: Curve

@export_subgroup("Tilt")
@export var dragTiltMaxAngle = 10.0
@export var dragTiltSpeed = 2.0
@export var tiltSnapBackSpeed = 30.0
@export var inHand = true:
	set(value):
		inHand = value
		cardRootContainer.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if inHand else Control.CURSOR_ARROW
		

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
		
@export_subgroup("Scale")
@export var hoverScale = Vector2(1.1, 1.1)
@export var scaleGrowSpeed = .1
@export var scaleShrinkSpeed = .2

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
var _drag_offset: Vector2 = Vector2.ZERO
var _snap_back_active: bool = false
var _snap_back_start: Vector2 = Vector2.ZERO
var _snap_back_progress: float = 0.0
var _scale_progress: float = 0.0

static func create(card: Card) -> CardNode:
	var node: CardNode = load("res://scenes/CardNode.tscn").instantiate()
	node.card = card
	var backingStyle: StyleBoxFlat = load("res://resources/stylebox/CardBackingStyle-%s.tres" % CultConstants.EmotionName(card.emotion))
	var elementStyle: StyleBoxFlat = load("res://resources/stylebox/CardElementBackingStyle-%s.tres" % CultConstants.EmotionName(card.emotion))
	node.backPanelContainer.add_theme_stylebox_override("panel", backingStyle)
	for container in node.elementContainers:
		container.add_theme_stylebox_override("panel", elementStyle)
	return node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var backingStyle: StyleBoxFlat = load("res://resources/stylebox/CardBackingStyle-%s.tres" % CultConstants.EmotionName(card.emotion))
	var elementStyle: StyleBoxFlat = load("res://resources/stylebox/CardElementBackingStyle-%s.tres" % CultConstants.EmotionName(card.emotion))
	backPanelContainer.add_theme_stylebox_override("panel", backingStyle)
	for container in elementContainers:
		container.add_theme_stylebox_override("panel", elementStyle)
		
	cardRootContainer.modulate = modulate
	
	title.text = card.name
	depiction.texture = card.depiction
	
	if (_hovering || _dragging) && inHand:
		scale = Vector2.ONE.move_toward(hoverScale, scaleGrowSpeed * delta)
		z_index = 1
	else:
		scale = hoverScale.move_toward(Vector2.ONE, scaleShrinkSpeed * delta)
		z_index = 0
	
	cardRootContainer.modulate = Color(cardRootContainer.modulate.r, 
										cardRootContainer.modulate.g, 
										cardRootContainer.modulate.b, 
										0.75 - (global_position - targetPosition).length() / 1000 if _dragging else 1.0)
	
	if (!_dragging && global_position != targetPosition && _snap_back_active):
		_snap_back_progress += delta
		var progress = _snap_back_progress / snapBackTime
		progress = snapBackCurve.sample(progress)
		if (progress < 1):
			global_position = _snap_back_start.lerp(targetPosition, progress)
		else:
			_snap_back_active = false
	
	if inHand:
		if (rotationX != 0):
			rotationX = move_toward(rotationX, 0, tiltSnapBackSpeed * delta)
		if (rotationY != 0):
			rotationY = move_toward(rotationY, 0, tiltSnapBackSpeed * delta)
		
	if !card: return
	var effectsText = ""
	for effect: Effect in card.effects:
		if !effect: continue
		effectsText += effect.GetEffectDescription(card.emotion) + "\n"
	effects.text = effectsText
	

func _gui_input(event: InputEvent) -> void:
		
	if event is InputEventMouseMotion:
		if _dragging:
			global_position = get_global_mouse_position() + _drag_offset
			var velocityNormal = event.velocity.normalized()
			var targetRotationX = -dragTiltMaxAngle if velocityNormal.y < 0 else dragTiltMaxAngle
			var targetRotationY = -dragTiltMaxAngle if velocityNormal.x > 0 else dragTiltMaxAngle
			rotationX = move_toward(rotationX, targetRotationX, abs(velocityNormal.y * dragTiltSpeed))
			rotationY = move_toward(rotationY, targetRotationY, abs(velocityNormal.x * dragTiltSpeed))
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.is_pressed() && !_dragging:
					_dragging = true
					DragStart.emit(self)
					_drag_offset = (global_position - get_global_mouse_position()) / scale
					cardRootContainer.mouse_default_cursor_shape = Control.CURSOR_DRAG
				else:
					if event.is_released():
						_dragging = false
						DragEnd.emit(self)
						_hovering = false
						cardRootContainer.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
						_snap_back_start = global_position
						_snap_back_progress = 0
						_snap_back_active = true
						_drag_offset = Vector2.ZERO

						if !SummoningBoard.instance: return
						var agent = SummoningBoard.instance.GetCultistAtMousePosition()
						if agent && card.CardCanBePlayed(agent.cultist):
							card.PlayCard(agent.cultist)
							queue_free()
						else:
							pass #TODO: Cardshake / negative feedback here
						
				
func _mouse_entered() -> void:
	_hovering = true
	
func _mouse_exited() -> void:
	_hovering = false
