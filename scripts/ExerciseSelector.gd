extends MenuButton

func _ready():
	var popup = $".".get_popup()  # Access the internal PopupMenu
	popup.connect("id_pressed", Callable(self, "on_MenuButton_id_pressed"))

func on_MenuButton_id_pressed(id):
	match id:
		0:
			print(0, 'interval identification')
			$"../../IntervalIdentification".show()
			$"../../Homepage".hide()
		1:
			print(1, 'option b')
