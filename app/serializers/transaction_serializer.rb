class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :deducted_at

  def deducted_at
    object.created_at
  end
end
