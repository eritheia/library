module BooksHelper
	def books_alert(book)
		req = book.requests.where(user_id: current_user.id).last
		return if req.nil? || req.due_date.nil?
       	if req.due_date < Date.today
		'Your Book Return Date Is Overdue'
		else
		 (req.due_date - Date.today).to_i 
		end
	end
end
