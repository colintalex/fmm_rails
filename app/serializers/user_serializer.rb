class UserSerializer
    include JSONAPI::Serializer

    set_type :user
    attributes :id, :name, :email, :favorites
    has_many :favorites
end