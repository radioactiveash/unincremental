class_name GamePanel
extends PanelContainer

@onready var panel_tickscreen = $VSplitContainer/HSplitContainer/tickscreen
func tickupdate():
	panel_tickscreen.find_child("tickupdates").tickupdate()
