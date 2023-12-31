extends Node
class_name ViewershipLogic

signal viewership_changed(new_viewership : int)
signal viewership_resetted(starting_viewership : int)

var current_viewership := 1000
var stream_time := 0.0
var peak_viewers := 0

const max_latest_categories_count := 8
const max_latest_intentions_count := 5

var filter_counter := 0
var latest_categories : Array[NeuroLogic.NeuroActionCategory] = []
var latest_categories_start_idx := 0
var donowall_counter := 0
var latest_intentions : Array[int] = []
var latest_intentions_start_idx := 0
var bedge_counter := 0
var schizo_factor := 0.0
var timeouts_counter := 0
var tutel_hype := false
var bad_wording_counter := 0

var bomb_defused_hype := 0.0

var current_neuro_action : NeuroLogic.NeuroFinalAction = null


var _logic_active := false

# + karaoke

func _init():
    for i in max_latest_categories_count:
        latest_categories.append(NeuroLogic.NeuroActionCategory.HiChat)
    for i in max_latest_intentions_count:
        latest_intentions.append(0)

func _ready():
    randomize()
    Game.get_neuro_logic().neuro_action_started.connect(_on_neuro_action_started)
    await get_tree().process_frame
    
    _on_reset()

    Game.do_start.connect(_on_start)
    Game.do_pause.connect(_on_pause)
    Game.do_reset.connect(_on_reset)

func _on_start():
    _logic_active = true
    # TODO: Fill this in

func _on_pause():
    _logic_active = false
    # TODO: Fill this in

func _on_reset():
    filter_counter = 0
    latest_categories.clear()
    latest_categories_start_idx = 0
    donowall_counter = 0
    latest_intentions.clear()
    latest_intentions_start_idx = 0
    bedge_counter = 0
    schizo_factor = 0.0
    timeouts_counter = 0
    tutel_hype = false
    bad_wording_counter = 0
    bomb_defused_hype = 0.0
    peak_viewers = 0
    stream_time = 0
    current_neuro_action = null

    for i in max_latest_categories_count:
        latest_categories.append(NeuroLogic.NeuroActionCategory.HiChat)
    for i in max_latest_intentions_count:
        latest_intentions.append(0)

    current_viewership = 1000
    viewership_resetted.emit(current_viewership)

var next_viewership_time := 0.0

func _process(delta):
    if _logic_active:
        stream_time += delta
        
        next_viewership_time -= randf_range(5.0, 8.0) * delta
        if next_viewership_time <= 0.0:
            _update_viewership()
            next_viewership_time += 1.0
    
func _push_category(category : NeuroLogic.NeuroActionCategory) -> void:
    latest_categories[latest_categories_start_idx] = category
    latest_categories_start_idx = (latest_categories_start_idx + 1) % max_latest_categories_count

func _push_intention(intention_level : int) -> void:
    latest_intentions[latest_intentions_start_idx] = intention_level
    latest_intentions_start_idx = (latest_intentions_start_idx + 1) % max_latest_intentions_count

func _on_neuro_action_started(neuro_action : NeuroLogic.NeuroFinalAction) -> void:
    current_neuro_action = neuro_action
    if neuro_action == null:
        return

    var neuro_logic : NeuroLogic = Game.get_neuro_logic()
    if neuro_logic.latest_bomb_defused_successfully:
        bomb_defused_hype = 1.0

    if neuro_logic.sleep_active:
        bedge_counter = min(bedge_counter + randi_range(1, 3), 12)  # tylko pierwsze 1..8 daje hype
        return
    else:
        bedge_counter = max(bedge_counter - 2, 0)

    if neuro_action.action_oopsie == NeuroLogic.NeuroActionOopsie.Ignored:
        donowall_counter = min(donowall_counter + randi_range(1, 3), 12)  # tylko pierwsze 1..8 daje hype
        return
    else:
        donowall_counter = max(donowall_counter - 2, 0)

    if neuro_action.action_oopsie == NeuroLogic.NeuroActionOopsie.Filtered:
        filter_counter = min(filter_counter + randi_range(1, 3), 12)  # tylko pierwsze 1..8 daje hype
        return
    else:
        filter_counter = max(filter_counter - 2, 0)

    tutel_hype = neuro_action.is_tutel_receiver
    bad_wording_counter = min(bad_wording_counter + randi_range(1, 3), 12) if neuro_action.contains_bad_words else max(bad_wording_counter - 2, 0)
    
    if neuro_action.neuro_timeouted_someone:
        timeouts_counter = min(timeouts_counter + randi_range(1, 2), 12)
    elif randf() < 0.4:
        timeouts_counter = max(timeouts_counter - 1, 0)
        
    schizo_factor = neuro_logic.get_perceived_schizo_factor()

    var intention_level := neuro_action.get_intention_level()
    _push_intention(intention_level)
    _push_category(neuro_action.category)

func _add_viewers(viewers_delta : int) -> void:
    current_viewership = max(current_viewership + viewers_delta, 0)
    peak_viewers = max(current_viewership, peak_viewers)
    viewership_changed.emit(current_viewership)

func is_between(value : int, min_value : int, max_value : int) -> bool:
    return value >= min_value and value <= max_value

func _calculate_viewership_increment(counter : int, increment_border : int, viewership_multiplier : float) -> int:
    var half := increment_border * 0.5
    var factor := (half - absf(float(counter) - half)) / half
    return int(viewership_multiplier * factor)

func _update_viewership():
    if current_neuro_action == null:
        return

    var neuro_logic : NeuroLogic = Game.get_neuro_logic()
    if neuro_logic.karaoke_active:
        _add_viewers(randi_range(10, 100))
        return

    var new_viewers := 0

    if bomb_defused_hype > 0.0:
        new_viewers += int(bomb_defused_hype * randi_range(20, 70))
        bomb_defused_hype -= randf() * 0.1

    
    new_viewers += min(0, _calculate_viewership_increment(donowall_counter, 4, 40.0))
    new_viewers += _calculate_viewership_increment(timeouts_counter, 8, 50.0)

    if neuro_logic.sleep_active:
        new_viewers += _calculate_viewership_increment(bedge_counter, 4, 20.0)

    var viewers_increment_by_counters : Array[int] = [
        _calculate_viewership_increment(filter_counter, 3, 15.0),
        _calculate_viewership_increment(bad_wording_counter, 6, 35.0),
    ]

    var min_increment_by_counters : int = viewers_increment_by_counters.min()
    var max_increment_by_counters : int = viewers_increment_by_counters.max()
    new_viewers += min_increment_by_counters if abs(min_increment_by_counters) > max_increment_by_counters else max_increment_by_counters

    # new_viewers += _calculate_viewership_increment(filter_counter, 4, 15.0)
    # new_viewers += min(0, _calculate_viewership_increment(donowall_counter, 3, 30.0))
    # new_viewers += _calculate_viewership_increment(bedge_counter, 3, 15.0)
    # new_viewers += _calculate_viewership_increment(timeouts_counter, 4, 20.0)
    # new_viewers += _calculate_viewership_increment(bad_wording_counter, 3, 15.0)

    new_viewers -= int(schizo_factor * 60.0)

    if tutel_hype:
        new_viewers += randi_range(0, 10)

    # var intention = latest_intentions[latest_intentions_start_idx]
    for intention in latest_intentions:
        match intention:
            1: new_viewers += randi_range(0, 5)
            2: new_viewers += randi_range(0, 15)
            3: new_viewers -= randi_range(0, 30)
            -1: new_viewers += randi_range(0, 5)
            -2: new_viewers += randi_range(0, 15)
            -3: new_viewers -= randi_range(0, 30)

    # var categories := {}
    for category in latest_categories:
        match category:
            NeuroLogic.NeuroActionCategory.HiChat:
                new_viewers += randi_range(0, 20)
            # NeuroLogic.NeuroActionCategory.None:
            # 	pass
            # _:
            # 	if categories.has(category):
            # 		categories[category] += 1
            # 	else:
            # 		categories[category] = 1

    # for category in categories:
    # 	var category_count : int = categories[category]
    # 	new_viewers += min(0, _calculate_viewership_increment(category_count, 3, 5.0))

    _add_viewers(new_viewers)

func _old_update_viewership():	
    var delta_vierwership := sin(stream_time * 0.5)
    delta_vierwership *= randi_range(10, 100)
    
    var delta_vierwership_2 := sin(stream_time * 1.0)
    delta_vierwership_2 *= randi_range(1, 50)
    
    _add_viewers(int(delta_vierwership + delta_vierwership_2))
    # print(current_viewership, ' <-', int(delta_vierwership), ' & ', int(delta_vierwership_2)) 
