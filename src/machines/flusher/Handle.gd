extends Grabbable
class_name FlusherHandle

@export var up_force: float
@export var flush_threshold: float

var _flushed := false

signal flush


func _integrate_forces(state):
    state.apply_central_force(Vector2.UP * up_force)

    if position.y > flush_threshold:
        if not _flushed:
            flush.emit()
            _flushed = true
    else:
        _flushed = false
