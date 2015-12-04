json.partial! partial: "api/v1/resource", collection: @polls, as: :resource
#json.array! @polls do |poll|
	#json.partial! "api/v1/resource", resource: poll
#end