extends BaseMachine


var _notes_collected: int = 0
var notes_collected: int:
    get:
        return _notes_collected
    set(value):
        _notes_collected = value
        note_progress_bar.value = _notes_collected * 10

@export var notes_to_start: int

@export var note_tscn: PackedScene
@export var note_spawn_area: CollisionShape2D
@export var note_spawn_interval: float
@export var karaoke_duration: float

@onready var note_spawn_timer: Timer = $NoteSpawnTimer
@onready var karaoke_timer: Timer = $KaraokeTimer
@onready var note_progress_bar: TextureProgressBar = $NoteProgress
@onready var note_icon: Sprite2D = $NoteIcon

@onready var _note_appear_audio: AudioStreamPlayer = $NoteAppearAudio
@onready var _note_collect_audio: AudioStreamPlayer = $NoteCollectAudio
@onready var _note_miss_audio: AudioStreamPlayer = $NoteMissAudio

@export var off_color: Color
@export var available_color: Color
@export var active_color: Color

@export var max_notes_in_world: int = 3

@export var ram_cost: float = 10

var _active = false


func _ready():
    note_progress_bar.max_value = notes_to_start * 10
    note_progress_bar.value = 0
    note_spawn_timer.start(note_spawn_interval)
    note_spawn_timer.timeout.connect(spawn_note)

    note_icon.modulate = off_color
    
    Game.do_pause.connect(_on_pause)
    Game.do_start.connect(_on_start)
    Game.do_reset.connect(_on_reset)
    
    
func _on_pause():
    deactivate_machine()
    

func _on_start():
    activate_machine()
    

func _on_reset():
    end_karaoke()
    _active = false
    notes_collected = 0
    Game.get_neuro_logic().update_karaoke_status(_active)


# func start_interacting():
#     if notes_collected >= notes_to_start and not _active:
#         start_karaoke()


func start_karaoke():
    if machine_active:
        _active = true
        notes_collected = 0
        karaoke_timer.start(karaoke_duration)
        note_icon.modulate = active_color
        Game.get_neuro_logic().update_karaoke_status(true)
        Game.get_ram_logic().add_ram(ram_cost)
        print("Karaoke start")

        await karaoke_timer.timeout
        end_karaoke()


func end_karaoke():
    if _active:
        print("Karaoke end")
        Game.get_neuro_logic().update_karaoke_status(false)
        note_icon.modulate = off_color
        _active = false


func spawn_note():
    if machine_active and not _active and notes_collected < notes_to_start and get_tree().get_node_count_in_group("Note") < max_notes_in_world:
        var note_inst: Note = note_tscn.instantiate()
        var rect := note_spawn_area.shape.get_rect()
        var pos := Vector2(randf_range(rect.position.x, rect.position.x + rect.size.x), randf_range(rect.position.y, rect.position.y + rect.size.y))
        note_spawn_area.add_child(note_inst)
        note_inst.position = pos
        note_inst.collect.connect(on_note_collected)
        note_inst.miss.connect(on_note_missed)

        _note_appear_audio.play()


func on_note_collected():
    if not _active and notes_collected < notes_to_start:
        _note_collect_audio.play()
        
        if machine_active:
            print("Note collected")
            notes_collected += 1

            if notes_collected >= notes_to_start:
                note_icon.modulate = available_color
                start_karaoke()
            

func on_note_missed():
    _note_miss_audio.play()
