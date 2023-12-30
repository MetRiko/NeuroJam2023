extends VBoxContainer

@onready var filter_label: Label = $FilterLabel
@onready var schizo_label: Label = $SchizoLabel
@onready var sleepy_label: Label = $SleepyLabel
@onready var justice_label: Label = $JusticeLabel
@onready var emotional_label: Label = $EmotionalLabel
@onready var donowall_label: Label = $DonowallLabel
@onready var karaoke_label: Label = $KaraokeLabel
@onready var sleep_label: Label = $SleepLabel
@onready var timeout_block_label: Label = $TimeoutBlockLabel
@onready var had_cookie_label: Label = $HadCookieLabel
@onready var latest_bomb_defused_label: Label = $LatestBombDefusedLabel
@onready var category_weight_label: Label = $CategoryWeightLabel


func _process(delta):
    var neuro_logic = Game.get_neuro_logic()

    filter_label.text = "Filter power: %s" % neuro_logic.filter_power
    schizo_label.text = "Schizo power: %s" % neuro_logic.schizo_power
    sleepy_label.text = "Sleepy power: %s" % neuro_logic.sleepy_power
    justice_label.text = "Justice factor: %s" % neuro_logic.justice_factor
    emotional_label.text = "Emotional state: %s" % neuro_logic.emotional_state
    donowall_label.text = "Donowall active: %s" % neuro_logic.donowall_active
    karaoke_label.text = "Karaoke active: %s" % neuro_logic.karaoke_active
    sleep_label.text = "Sleep active: %s" % neuro_logic.sleep_active
    timeout_block_label.text = "Timeout block active: %s" % neuro_logic.timeout_block_active
    latest_bomb_defused_label.text = "Bomb defused: %s" % neuro_logic.latest_bomb_defused_successfully
    had_cookie_label.text = "Had cookie: %s" % neuro_logic.prev_action_had_cookie
    
    var category_weight_label_text = "Category weights:\n"
    for category in neuro_logic.category_weights.keys():
        category_weight_label_text += "%s: %s\n" % [NeuroLogic.NeuroActionCategory.keys()[category], neuro_logic.category_weights[category]]
    category_weight_label.text = category_weight_label_text
