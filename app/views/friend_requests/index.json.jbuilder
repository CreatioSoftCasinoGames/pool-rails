json.array!(@friend_requests) do |friend_request|
  json.extract! friend_request, :id, :requested_to_id, :confirmed, :user_id
  json.url friend_request_url(friend_request, format: :json)
end
