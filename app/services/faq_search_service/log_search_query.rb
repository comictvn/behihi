
module FaqSearchService
  class LogSearchQuery
    def self.log_search_query(user_id, search_query)
      user = User.find_by(id: user_id)
      return { error: 'User not found' } unless user

      if search_query.blank?
        return { error: 'Search query cannot be empty' }
      else
        faq_search = FaqSearch.create(user_id: user_id, search_query: search_query, created_at: Time.current)
        return { message: 'Search query logged', id: faq_search.id }
      end
    end
  end
end
