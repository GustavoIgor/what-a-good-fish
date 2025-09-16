extends CanvasLayer


func _on_sell_fish_button_pressed() -> void:
	hide()
	$SellFishInterface.show()
	$SellItemInterface.hide()
	$BuyItemInterface.hide()

func _on_sell_items_button_pressed() -> void:
	hide()
	$SellFishInterface.hide()
	$SellItemInterface.show()
	$BuyItemInterface.hide()

func _on_buy_items_button_pressed() -> void:
	hide()
	$SellFishInterface.hide()
	$SellItemInterface.hide()
	$BuyItemInterface.show()

func _on_visibility_changed() -> void:
	if visible:
		$SellFishInterface.hide()
		$SellItemInterface.hide()
		$BuyItemInterface.hide()
