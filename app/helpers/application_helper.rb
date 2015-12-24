module ApplicationHelper
	def active_menu(path)
		return 'active' if request.path == path
	end
end
