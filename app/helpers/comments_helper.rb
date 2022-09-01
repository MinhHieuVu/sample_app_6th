module CommentsHelper
  def dom_id_for_records(*records, prefix: nil)
    records.map { |record| dom_id(record, prefix) }.join("_")
  end
end
