class Dashing.RSS extends Dashing.Widget

	ready: ->
		@currentIndex = 0
		@postElem = $(@node).find('.post-container')
		@nextComment()
		@startCarousel()

	onData: (data) ->
		@currentIndex = 0

	startCarousel: ->
		interval = $(@node).attr('data-interval')
		interval = "30" if not interval
		setInterval(@nextComment, parseInt( interval ) * 1000)		

	nextComment: =>
		posts = @get('posts')
		max_posts = posts.length
		
		# just in case there are a crazy amount of posts
		if max_posts > 50
			max_posts = 50

		@set 'current_post', posts[@currentIndex]

		p = []
		for i in [1..(max_posts-1)]
			p.push posts[(@currentIndex + i) % max_posts]
		@set 'postskw', p
		
		@currentIndex = (@currentIndex + 1) % max_posts
    		
        
        
        
        