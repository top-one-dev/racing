module ApplicationHelper
	def active_menu(path)
		menu = /^\/[a-zA-Z]*/.match(request.path)[0]
		
		result = /^\/admin\/races/.match(request.path)
		if result.nil?
			result = /^\/cyclists/.match(request.path)
		end

		if result.nil?
			menu = /^\/results/.match(request.path)
		end

		if result
			menu = result[0]
		end		
		
		return 'active' if menu == path
	end
end