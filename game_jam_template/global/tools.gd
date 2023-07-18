class_name Tools

static func is_url(url: String) -> bool:
	return url.begins_with("https://") and url.split(".", false).size() > 1 and url.count(" ") == 0
