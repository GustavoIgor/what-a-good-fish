extends Node

signal inventory_updated

const MAX_EXPANSION = 30
const EXPANSION_STEP = 10

var fish_inventory: Array = []
var usable_inventory: Array = []

var fish_capacity: int = 10
