class UserSerializer
    include JSONAPI::Serializer

    set_type :user  # optional
    # set_id :owner_id # optional
    attributes :id, :name, :email
    # has_many :actors
    # belongs_to :owner, record_type: :user
    # belongs_to :movie_type
end