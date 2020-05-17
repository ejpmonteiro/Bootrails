module ApplicationHelper
	def button_tag_icon(text, classes)
		form_tag :method => :post do
			button_tag(classes) do
				raw text
			end
		end
	end

	def button_icon(text, classes)
		button_tag(classes) do
			raw text
		end
	end
end
