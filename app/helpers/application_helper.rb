module ApplicationHelper
	def active_menu(path)
		menu = /^\/[a-zA-Z]*/.match(request.path)[0]
		return 'active' if menu == path
	end
end