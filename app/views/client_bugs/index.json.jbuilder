json.array!(@client_bugs) do |client_bug|
  json.extract! client_bug, :id, :exception, :bug_type
  json.url client_bug_url(client_bug, format: :json)
end
