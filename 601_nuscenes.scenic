# Could not find a way to make pedestrians stop and then start walking again

param map = localPath('maps/Town01.xodr')
model scenic.domains.driving.model

PARKED_CAR_OFFSET = 1   
PEDESTRIAN_OFFSET = 3      
EGO_TO_PARKED_CAR_MIN_DIST = 0 

behavior StandStill():
    take SetWalkingSpeedAction(0)
behavior WalkForward():
    take SetWalkingSpeedAction(10)

# Sequence behavior using `do ... for ...`
behavior CrossStreet():
    do StandStill() for 3 seconds    # stay still
    do WalkForward() for 4 seconds   # walk forward
    do StandStill() for 2 seconds    # stop again
    do WalkForward() for 1 seconds    # walk again

ego = new Car
rightCurb = ego.laneGroup.curb
spot = new OrientedPoint on visible rightCurb

parkedCar = new Car right of spot by PARKED_CAR_OFFSET, with regionContainedIn None

require distance from ego to parkedCar > EGO_TO_PARKED_CAR_MIN_DIST

new Pedestrian ahead of parkedCar by PEDESTRIAN_OFFSET,
    facing 90 deg relative to parkedCar,
    with behavior CrossStreet()