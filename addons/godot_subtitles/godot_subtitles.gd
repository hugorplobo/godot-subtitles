tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("SubtitleVideoPlayer", "VideoPlayer", preload("res://addons/godot_subtitles/subtitles_video_player.gd"), preload("res://icon.svg"))

func _exit_tree():
	remove_custom_type("SubtitleVideoPlayer")
