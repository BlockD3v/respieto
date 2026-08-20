extends CanvasLayer

var game_menu_screen = preload("res://scenes/ui/GameMenuScreen.tscn")
var game_menu_instance: Node = null
var game_running: bool = false
var is_connected: bool = false
var wallet_address: String = ""

@onready var wallet_adapter: WalletAdapter = $WalletAdapter
@onready var connect_button: Button = $ConnectButton
@onready var status_label: Label = $StatusLabel
@onready var wallet_address_label: Label = $WalletAddressLabel

func _ready():
	if wallet_adapter:
		# 🔥 FORCE WEB ENVIRONMENT
		if wallet_adapter.has_method("set_environment"):
			wallet_adapter.set_environment("web")
		if wallet_adapter.has_method("set_network"):
			wallet_adapter.set_network("devnet")
		
		if wallet_adapter.has_signal("wallet_connected"):
			wallet_adapter.wallet_connected.connect(_on_wallet_connected)
		if wallet_adapter.has_signal("wallet_disconnected"):
			wallet_adapter.wallet_disconnected.connect(_on_wallet_disconnected)
		if wallet_adapter.has_signal("connection_failed"):
			wallet_adapter.connection_failed.connect(_on_wallet_connection_failed)
		
		var timer = Timer.new()
		timer.wait_time = 0.5
		timer.timeout.connect(_poll_connection)
		add_child(timer)
		timer.start()
func _poll_connection():
	if not wallet_adapter:
		return
	
	var addr = null
	if wallet_adapter.has_method("get_public_key"):
		addr = wallet_adapter.get_public_key()
	elif wallet_adapter.has_method("get_address"):
		addr = wallet_adapter.get_address()
	elif wallet_adapter.has_method("get_wallet_address"):
		addr = wallet_adapter.get_wallet_address()
	elif wallet_adapter.has_method("get_wallet"):
		var wallet = wallet_adapter.get_wallet()
		if wallet and wallet.has_method("get_public_key"):
			addr = wallet.get_public_key()
	
	if addr != null and addr != "":
		if not is_connected:
			is_connected = true
			wallet_address = addr
			_on_wallet_connected(addr)
	else:
		if is_connected:
			is_connected = false
			wallet_address = ""
			_on_wallet_disconnected()

func _unhandled_input(event: InputEvent) -> void:
	if game_running:
		return
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

func exit_game() -> void:
	get_tree().quit()

func show_game_menu_screen() -> void:
	if game_menu_instance == null:
		game_menu_instance = game_menu_screen.instantiate()
		get_tree().root.add_child(game_menu_instance)

func _on_connect_wallet_pressed() -> void:
	if not wallet_adapter:
		return
	if is_connected:
		wallet_adapter.disconnect_wallet()
	else:
		wallet_adapter.connect_wallet()
		if status_label:
			status_label.text = "Connecting..."

func _on_wallet_connected(address: String):
	is_connected = true
	wallet_address = address
	if status_label:
		status_label.text = "Connected!"
	if wallet_address_label:
		wallet_address_label.text = address
	if connect_button:
		connect_button.text = "Disconnect"
	check_token_balance(address)

func _on_wallet_disconnected():
	is_connected = false
	wallet_address = ""
	if status_label:
		status_label.text = "Disconnected"
	if wallet_address_label:
		wallet_address_label.text = ""
	if connect_button:
		connect_button.text = "Connect Wallet"

func _on_wallet_connection_failed(error: String):
	if status_label:
		status_label.text = "Connection Failed: " + error

func check_token_balance(address: String):
	if status_label:
		status_label.text = "Checking balance..."
	await get_tree().create_timer(1.5).timeout
	if status_label:
		status_label.text = "✅ Access Granted!"

func _on_start_game_button_pressed() -> void:
	if not is_connected:
		if status_label:
			status_label.text = "⚠️ Please connect wallet first!"
		return
	
	game_running = true
	if game_menu_instance:
		game_menu_instance.queue_free()
		game_menu_instance = null
	queue_free()
	
	SceneManager.load_main_scene_container()
	SceneManager.load_level("Level1")
