
# rubocop:disable Style/ClassAndModuleChildren
class FaqSearchService::RetrieveOptions
  def call(question_id)
    options = Option.where(question_id: question_id)
    options.any? ? options : []
  end
end
# rubocop:enable Style/ClassAndModuleChildren
