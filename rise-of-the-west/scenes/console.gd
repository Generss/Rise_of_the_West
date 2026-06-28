extends LineEdit

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_QUOTELEFT:
			self.visible = !self.visible
