class Dashing.Log extends Dashing.Widget

  ready: ->
    
  onData: (data) ->
  	# fired when received data
  	for key,value of data
  		break if key in ["id","updatedAt"]
  		id = $(@node).find("##{key}")
  		console.log(id)
  		[error,warning] = value.split("/")
  		if error != "0"
  			id.attr("class","value-error")
  			
  	debugger