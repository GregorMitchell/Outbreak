extends CanvasLayer

func update_healthbar(value):
	$Margin/Container/HealthBar/Tween.interpolate_property($Margin/Container/HealthBar, 'value', $Margin/Container/HealthBar.value, value, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Margin/Container/HealthBar/Tween.start()
	$Margin/Container/HealthBar.value = value
