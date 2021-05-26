class FavoriteSerializer
    include JSONAPI::Serializer

    attributes :name, :fmid, :address, :dates, :times
    belongs_to :user
end