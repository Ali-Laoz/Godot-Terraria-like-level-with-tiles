extends Node2D

#player
onready var player=$Player

enum block{grass,dirt,stone,sand,brick,wood,coal,iron,gold,diamond,water,lava}

#general
var unloadCordXY=Vector2(0,0)
var cordXY=Vector2(0,0)
var array=PoolIntArray()

var boundsCordXY=Vector2(0,0)

const HEIGHT=6000

##about block
var block_size=8
var block_id=0


#load6 vars
var load6DistanceToStartLoad=520 # 700 or 520 defualt
var load6HowMuchToLoad=405 # 520 defualt or 505
var load6CurrentLoadedBlockY=0
var load6CurrentLoadedBlockX=0
var load6fromtoload=0

#load4 vars
var load4DistanceToStartLoad=520  # 700 or 520 defualt
var load4HowMuchToLoad=405	# 520 defualt or 405
var load4CurrentLoadedBlockY=0
var load4CurrentLoadedBlockX=0
var load4fromtoload=0

#load2 vars
var load2DistanceToStartLoad=400	# 500 or 400 defualt
var load2HowMuchToLoad=505 # 720 defualt or 505
var load2CurrentLoadedBlockY=0
var load2CurrentLoadedBlockX=0

#load8 vars
var load8DistanceToStartLoad=400	# 500 or 400 defualt
var load8HowMuchToLoad=505	# 720 defualt or 505
var load8CurrentLoadedBlockY=0
var load8CurrentLoadedBlockX=0

var frame=0
var flag=100

#about noise
var noise=OpenSimplexNoise.new()
var noise1d=OpenSimplexNoise.new()
var noiseCoal=OpenSimplexNoise.new()
var noiseIron=OpenSimplexNoise.new()
var noiseGold=OpenSimplexNoise.new()
var noiseDiamond=OpenSimplexNoise.new()


#tile
onready var tile=$TileMap
onready var tiletest=$TileMapTest
onready var tileTree01=$Tree01

var rnd=RandomNumberGenerator.new()

#addingBlocks
var blockType=0 #block type is the index of tile
var arrayHights=PoolIntArray()
var funcNum=0
var randnum


var counter=75

func _ready():

	tile=tiletest
	block_id=0
	Globalvars.cell_size=block_size
	
	
	noise.seed=0
	noise.lacunarity=900
	noise.period = 500
	noise.persistence = 0.5
	noise.octaves=1
	
	noiseCoal.seed=0
	noiseCoal.lacunarity=0
	noiseCoal.period = 75
	noiseCoal.persistence = 1
	noiseCoal.octaves=2
	
	
	noiseIron.seed=1
	noiseIron.lacunarity=0
	noiseIron.period = 75
	noiseIron.persistence = 1.1
	noiseIron.octaves=2
	
	
	noiseGold.seed=2
	noiseGold.lacunarity=0
	noiseGold.period = 75
	noiseGold.persistence = 1.2
	noiseGold.octaves=2
	
	
	noiseDiamond.seed=3
	noiseDiamond.lacunarity=0
	noiseDiamond.period = 75
	noiseDiamond.persistence = 1.3
	noiseDiamond.octaves=2
	
	array.resize(32000*6000)
	arrayHights.resize(32000)


	
	#-2 means not changed yeat
	array.fill(-2)

	arrayHights.fill(-2)
	

	noise1d.seed=rnd.randi_range(1,100000)
	noise1d.lacunarity=0.1
	noise1d.period=500
	noise1d.persistence=0.9
	noise1d.octaves=9
	for x in range(0,31999,1):
		var y = ((noise1d.get_noise_1d(x)) * 100 * 0.75) + 100 *0.01
		var hight=(2000*block_size)+(y*block_size)
		
		if x%250==0:
			noise1d.lacunarity=rnd.randf_range(0.1,2)
			noise1d.period=rnd.randi_range(50,500)
			noise1d.persistence=rnd.randf_range(0.1,2)
			noise1d.octaves=rnd.randi_range(1,9)
		arrayHights[x]=hight
		
		if x%100==0:
			x*=8
			hight-=350
			#tileTree01.set_cellv(tile.world_to_map(Vector2(x,hight)),0)
			
		
		
		

		

	var startPoint=rnd.randi_range(1500,3500)
	for adder in range(startPoint,32000*block_size,rnd.randi_range(1500,3500)):
		noise1d.seed=rnd.randi_range(1,100000)
		noise1d.lacunarity=rnd.randf_range(0.1,0.9)
		noise1d.period=rnd.randi_range(50,300)
		noise1d.persistence=rnd.randf_range(0,0.1)
		noise1d.octaves=rnd.randi_range(1,9)
		if funcNum>7:
			funcNum=0
		funcGraphs(adder)			

			

			
	player.global_position.x=16000*block_size
	player.global_position.y=(arrayHights[16000])-block_size			
			
	#load6 intelizing
	load6CurrentLoadedBlockX=player.global_position.x
	load6CurrentLoadedBlockY=player.global_position.y
	
	#load4 intelizing
	load4CurrentLoadedBlockX=player.global_position.x
	load4CurrentLoadedBlockY=player.global_position.y
	
	#load2 intelizing
	load2CurrentLoadedBlockX=player.global_position.x
	load2CurrentLoadedBlockY=player.global_position.y

	#load8 intelizing
	load8CurrentLoadedBlockX=player.global_position.x
	load8CurrentLoadedBlockY=player.global_position.y

	
	


# Create a circle-shaped hole at the position
func explosion(pos: Vector2, radius: int) -> void:
	
	
	
	for x in range(-radius, radius + 1 , block_size):
		for y in range(-radius, radius + 1 , block_size):
			# Loop over a square shape
			if Vector2(x, y).length() > radius:
				# Filter out the corners to leave the circle in the middle
				continue
			var pixel = pos + Vector2(x,y) # Move the circle to `pos`
			var vec=tile.world_to_map(pixel)
		
			array[(vec.x*HEIGHT)+vec.y]=-1
			if tile.get_cellv(vec)>=0:
				tile.set_cellv(vec, -1) # Set pixel transparent
	# Lock the graphics and use them



func explosionTunnels(pos: Vector2, radius: int) -> void:
	
	
	
	for x in range(-radius, radius + 1 , block_size):
		for y in range(-radius, radius + 1 , block_size):
			# Loop over a square shape
			if Vector2(x, y).length() > radius:
				# Filter out the corners to leave the circle in the middle
				continue
			var pixel = pos + Vector2(x,y) # Move the circle to `pos`
		 # Move the circle to `pos`
			var vec=tile.world_to_map(pixel)
			
			
			if vec.x<0 or vec.y<0 or vec.x>31999 or vec.y>5999:
				continue
			
			array[(vec.x*HEIGHT)+vec.y]=-1

	# Lock the graphics and use them


# Create a circle-shaped hole at the position
func set_blocks(pos: Vector2, radius: int) -> void:

	
	for x in range(-radius, radius + 1,block_size):
		for y in range(-radius, radius + 1,block_size):
			# Loop over a square shape
			if Vector2(x, y).length() > radius:
				# Filter out the corners to leave the circle in the middle
				continue
			var pixel = pos + Vector2(x,y) # Move the circle to `pos`
			var vec=tile.world_to_map(pixel)
			array[(vec.x*HEIGHT)+vec.y]=1
			tile.set_cellv(vec, 1) # Set pixel transparent
	# Lock the graphics and use them
	
	
	
			
func _process(delta):
	if(Globalvars.player_mouse_left==1):
		explosion(Globalvars.player_mouse_pos,50)
		Globalvars.player_mouse_left=0
		
	if(Globalvars.player_mouse_right==1):
		set_blocks(Globalvars.player_mouse_pos,50)
		Globalvars.player_mouse_right=0	
	

	
	
	
	
	
		#print("player.x:"+str(int(player.global_position.x)))
	if (player.global_position.x+load6DistanceToStartLoad)>load6CurrentLoadedBlockX:
		load6chunk()
		deleteOutsideTileTopLeft()
		deleteOutsideTileButtomLeft()
		
	if (player.global_position.x-load4DistanceToStartLoad)<load4CurrentLoadedBlockX:
		load4chunk()
		deleteOutsideTileTopRight()
		deleteOutsideTileButtomRight()
		
			
	if (player.global_position.y+load2DistanceToStartLoad)>load2CurrentLoadedBlockY:
		load2chunk()
		deleteOutsideTileTopLeft()
		deleteOutsideTileTopRight()
		
			
	if (player.global_position.y-load8DistanceToStartLoad)<load8CurrentLoadedBlockY:
		load8chunk()
		deleteOutsideTileButtomLeft()
		deleteOutsideTileButtomRight()
				
		pass

			
			


func load6chunk():
	#
	cordXY.x=load6CurrentLoadedBlockX
	
	
	
	for y in range(-load6HowMuchToLoad,load6HowMuchToLoad,block_size):
		cordXY.y=player.global_position.y-y
		
		
		var vec=tile.world_to_map(cordXY)

		explodeNoise(Vector2(cordXY.x+150,cordXY.y))
		
		
		
	
		unloadCordXY.x=load4CurrentLoadedBlockX
		
		unloadCordXY=tile.world_to_map(unloadCordXY)
		unloadCordXY.y=vec.y
		


		unloadCordXY.x-=2

		tile.set_cellv(unloadCordXY, -1)

		
		#---------------done unloading------------------------
		
		if vec.x<0 or vec.y<0:
			continue


		
		if array[(vec.x*HEIGHT)+vec.y]==-2 and cordXY.y>=arrayHights[vec.x]:
			var tile_id = generate_id(noise.get_noise_2d(cordXY.x,y))
			if(tile_id != -1):
				block_id=funcChooseBlock()
				array[(vec.x*HEIGHT)+vec.y]=block_id
				tile.set_cellv(vec, block_id)
			else:
				array[(vec.x*HEIGHT)+vec.y]=-1

				
					
		
		
		elif array[(vec.x*HEIGHT)+vec.y]>=0:
			block_id=array[(vec.x*HEIGHT)+vec.y]
			tile.set_cellv(vec, block_id)

	
		
	load6CurrentLoadedBlockX=player.global_position.x+load6DistanceToStartLoad		
	#load6CurrentLoadedBlockX+=block_size
		
	
	load4CurrentLoadedBlockX=player.global_position.x-load4DistanceToStartLoad
	#load4CurrentLoadedBlockX+=block_size
	

	
	pass
	
	
func load4chunk():
	cordXY.x=load4CurrentLoadedBlockX
	
	
	
	
	for y in range(-load4HowMuchToLoad,load4HowMuchToLoad,block_size):
		cordXY.y=player.global_position.y-y
		
		var vec=tile.world_to_map(cordXY)
		

		
		explodeNoise(Vector2(cordXY.x-150,cordXY.y))
		
	
		
		##unloading--- diraction of 4 dircarion when player get out of bound
		unloadCordXY.x=load6CurrentLoadedBlockX
		#unloadCordXY.x=player.global_position.x-load6DistanceToStartLoad
		unloadCordXY=tile.world_to_map(unloadCordXY)
		unloadCordXY.y=vec.y

		unloadCordXY.x+=3
		tile.set_cellv(unloadCordXY, -1)
		


		if vec.x<0 or vec.y<0:
			continue
		
		
		
		
		
		if array[(vec.x*HEIGHT)+vec.y]==-2 and cordXY.y>=arrayHights[vec.x]:
			var tile_id = generate_id(noise.get_noise_2d(cordXY.x,y))
			if(tile_id != -1):
				block_id=funcChooseBlock()
				array[(vec.x*HEIGHT)+vec.y]=block_id
				tile.set_cellv(vec, block_id)
			else:
				array[(vec.x*HEIGHT)+vec.y]=-1

				
					
		
		
		elif array[(vec.x*HEIGHT)+vec.y]>=0:
			block_id=array[(vec.x*HEIGHT)+vec.y]
			tile.set_cellv(vec, block_id)
			

	
	load4CurrentLoadedBlockX=player.global_position.x-load4DistanceToStartLoad	
	#load4CurrentLoadedBlockX-=block_size
	
	
	load6CurrentLoadedBlockX=player.global_position.x+load6DistanceToStartLoad
	
	#load6CurrentLoadedBlockX-=block_size
	
	
	
	pass	
	
	
func load2chunk():
	cordXY.y=load2CurrentLoadedBlockY
	
	
	
	for x in range(-load2HowMuchToLoad,load2HowMuchToLoad,block_size):
		cordXY.x=player.global_position.x-x
		
		var vec=tile.world_to_map(cordXY)
		
		
		
		explodeNoise(Vector2(cordXY.x,cordXY.y+150))
		

		
		##unloading--- diraction of 4 dircarion when player get out of bound
		unloadCordXY.y=load8CurrentLoadedBlockY-150
		#unloadCordXY.x=player.global_position.x+load4DistanceToStartLoad
		unloadCordXY=tile.world_to_map(unloadCordXY)
		unloadCordXY.x=vec.x

		
		tile.set_cellv(unloadCordXY, -1)
		

		#---------------done unloading------------------------
		

		
		if vec.x<0 or vec.y<0:
			continue
		
		if array[(vec.x*HEIGHT)+vec.y]==-2 and cordXY.y>=arrayHights[vec.x]:
			var tile_id = generate_id(noise.get_noise_2d(x,cordXY.y))
			if(tile_id != -1):
				block_id=funcChooseBlock()
				array[(vec.x*HEIGHT)+vec.y]=block_id
				tile.set_cellv(vec, block_id)
			else:
				array[(vec.x*HEIGHT)+vec.y]=-1

				
					
		
		
		elif array[(vec.x*HEIGHT)+vec.y]>=0:
			block_id=array[(vec.x*HEIGHT)+vec.y]
			tile.set_cellv(vec, block_id)
	

	

	
	#load2CurrentLoadedBlockY=player.global_position.y+load2DistanceToStartLoad	
	load2CurrentLoadedBlockY+=block_size
	
	#load8CurrentLoadedBlockY=player.global_position.y-load8DistanceToStartLoad
	load8CurrentLoadedBlockY+=block_size
	pass
	
	
	pass	


func load8chunk():
	cordXY.y=load8CurrentLoadedBlockY
	
	
	
	for x in range(-load8HowMuchToLoad,load8HowMuchToLoad,block_size):
		cordXY.x=player.global_position.x-x
		
		
		var vec=tile.world_to_map(cordXY)
		

		
		explodeNoise(Vector2(cordXY.x,cordXY.y+150))
		

		
		
				##unloading--- diraction of 4 dircarion when player get out of bound
		unloadCordXY.y=load2CurrentLoadedBlockY+150
		#unloadCordXY.x=player.global_position.x+load4DistanceToStartLoad
		unloadCordXY=tile.world_to_map(unloadCordXY)
		unloadCordXY.x=vec.x

		unloadCordXY.y-=3
		
		tile.set_cellv(unloadCordXY, -1)

		#---------------done unloading------------------------
		
		
		
		if vec.x<0 or vec.y<0:
			continue
		
		if array[(vec.x*HEIGHT)+vec.y]==-2 and cordXY.y>=arrayHights[vec.x]:
			var tile_id = generate_id(noise.get_noise_2d(x,cordXY.y))
			if(tile_id != -1):
				block_id=funcChooseBlock()
				array[(vec.x*HEIGHT)+vec.y]=block_id
				tile.set_cellv(vec, block_id)
			else:
				array[(vec.x*HEIGHT)+vec.y]=-1

				
					
		
		
		elif array[(vec.x*HEIGHT)+vec.y]>=0:
			block_id=array[(vec.x*HEIGHT)+vec.y]
			tile.set_cellv(vec, block_id)
			
			#array[(vec.x*HEIGHT)+vec.y]=0
			

			
	
	#load8CurrentLoadedBlockY=player.global_position.y-load8DistanceToStartLoad	
	load8CurrentLoadedBlockY-=block_size
	
	load2CurrentLoadedBlockY=player.global_position.y+load2DistanceToStartLoad
	
	pass

	
				

func generate_id(noise_level : float):
	if(noise_level <= -0.3):
		return -1
	else:
		return 2
	


func deleteOutsideTileTopLeft():
	
	boundsCordXY.x=player.global_position.x-550
	var start=player.global_position.y-750
	var end=player.global_position.y-250
	
	
	
	for y in range(start,end,block_size):
		boundsCordXY.y=y
		
		if tile.get_cellv(tile.world_to_map(boundsCordXY))>0:
			tile.set_cellv(tile.world_to_map(boundsCordXY), -1)



	pass
	
	
func deleteOutsideTileTopRight():
	
	boundsCordXY.x=player.global_position.x+550
	var start=player.global_position.y-750
	var end=player.global_position.y-300
	
	
	
	for y in range(start,end,block_size):
		boundsCordXY.y=y
		
		if tile.get_cellv(tile.world_to_map(boundsCordXY))>0:
			tile.set_cellv(tile.world_to_map(boundsCordXY), -1)



	pass
	
	
func deleteOutsideTileButtomRight():
	
	boundsCordXY.x=player.global_position.x+550
	var start=player.global_position.y+400
	var end=player.global_position.y+630
	
	
	
	for y in range(start,end,block_size):
		boundsCordXY.y=y
		
		if tile.get_cellv(tile.world_to_map(boundsCordXY))>0:
			tile.set_cellv(tile.world_to_map(boundsCordXY), -1)



	pass
	
	
func deleteOutsideTileButtomLeft():
	
	boundsCordXY.x=player.global_position.x-550
	var start=player.global_position.y+220
	var end=player.global_position.y+570
	
	
	
	for y in range(start,end,block_size):
		boundsCordXY.y=y
		
		if tile.get_cellv(tile.world_to_map(boundsCordXY))>0:
			tile.set_cellv(tile.world_to_map(boundsCordXY), -1)



	pass			

func explodeNoise(expVec:Vector2):
	
	var vec=tile.world_to_map(expVec)

	if vec.x>31999 or vec.y>5999:
		return
	if array[(vec.x*HEIGHT)+vec.y]==-3:
		explosionTunnels(expVec,72)
	pass
		

func funcGraphs(adder):
	var startY=arrayHights[int(adder/block_size)]
	var endY=rnd.randi_range(2500,3000)
	for y in range(startY,endY*block_size,block_size):
		var x=0	
		x=funcChooserGraph(x,y)
		
		x+=adder
		
		
		
		cordXY.x=x
		cordXY.y=y
		var vec=tile.world_to_map(cordXY)

		if vec.x>31999 or vec.y>5999:
			continue
		
		
		array[(vec.x*HEIGHT)+vec.y]=-3
	
	funcNum+=1
	
	
	startY=rnd.randi_range(3000,3500)
	endY=rnd.randi_range(3500,4000)	
	for y in range(startY*block_size,endY*block_size,block_size):
		var x=0	
		x=funcChooserGraph(x,y)
		x+=adder
		cordXY.x=x
		cordXY.y=y
		var vec=tile.world_to_map(cordXY)

		if vec.x>31999 or vec.y>5999:
			continue
			
		array[(vec.x*HEIGHT)+vec.y]=-3
	
	funcNum+=1
	
	startY=rnd.randi_range(4000,4500)
	endY=rnd.randi_range(4500,5000)
	for y in range(startY*block_size,endY*block_size,block_size):
		var x=0	
		x=funcChooserGraph(x,y)
		x+=adder
		cordXY.x=x
		cordXY.y=y
		var vec=tile.world_to_map(cordXY)

		if vec.x>31999 or vec.y>5999:
			continue
			
		array[(vec.x*HEIGHT)+vec.y]=-3
	
	funcNum+=1		
			

			
			

func funcGraph0(y):
	var	 x = ((noise1d.get_noise_1d(y)) * 1000 * 0.75) + 1000 *0.01
	#print(x)
	return x
	pass
	
func funcGraph1(y):
	y=y*2
	var x =-y+2
	#print(x)
	return x
	pass
		
func funcGraph2(y):
	y=y*2
	var x =y+2
	#print(x)
	return x
	pass	
	
func funcGraph3(y):
	var x=pow(12,y/5000.0)
	return x
	pass		


func funcChooserGraph(x,y):
	
	if funcNum==0 or funcNum>3:
		x = funcGraph0(y)
		funcNum=0
			
	if funcNum==1:
		x = funcGraph1(y)
	if funcNum==2:
		x = funcGraph2(y)	
	if funcNum==3:
		x = funcGraph3(y)	

	return x
	pass
	
	
func funcChooseBlock():
	var vec=tile.world_to_map(cordXY)
	
	if (cordXY.y)>arrayHights[vec.x]+(0*block_size) and cordXY.y<arrayHights[vec.x]+(1*block_size):
		block_id=block.grass
	
	elif (cordXY.y)>arrayHights[vec.x]+(0*block_size) and cordXY.y<arrayHights[vec.x]+(10*block_size):
		block_id=block.dirt
	
	elif (cordXY.y)>arrayHights[vec.x]:
		var rand_num = (noiseCoal.get_noise_2d(cordXY.x,cordXY.y))
		var rand_num1 = (noiseIron.get_noise_2d(cordXY.x,cordXY.y))
		var rand_num2 = (noiseGold.get_noise_2d(cordXY.x,cordXY.y))
		var rand_num3 = (noiseDiamond.get_noise_2d(cordXY.x,cordXY.y))
		
		#rand_num=abs(rand_num)
		#print(rand_num)		
		if rand_num <=-0.3: # 25%
			block_id = block.coal
			
		elif rand_num1 <=-0.33 and cordXY.y>2100*block_size:
			block_id=block.iron
		
		elif rand_num2 <=-0.35 and cordXY.y>2300*block_size:
			block_id=block.gold
		
		elif rand_num3 <=-0.34 and cordXY.y>2500*block_size:
			block_id=block.diamond	 	 	
			
		else: # 5%
			if cordXY.y<arrayHights[vec.x]+(600*block_size):
				block_id=block.dirt
			else:
				var rand_num4 = (noise.get_noise_2d(cordXY.x,cordXY.y))
				if rand_num4<=0.05:
					block_id=block.dirt
				else:
					block_id=block.stone
							
				
			
			
			
					
		
	return block_id
	pass	
	
	
		

