extends Node
class_name Conversions

static func db_to_power(db: float) -> float:
    return pow(10.0, db / 20.0)

static func power_to_db(power: float) -> float:
    return 20.0 * log(power) / log(10)
