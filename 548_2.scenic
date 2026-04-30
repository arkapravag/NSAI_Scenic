param map = localPath('maps/Town04.xodr')
model scenic.domains.driving.model

STEPS_PER_SEC = 10

behavior EgoBehavior():
    do DriveAvoidingCollisions(target_speed=12, avoidance_threshold=5)

behavior DriftIntoLane():
    try:
        do FollowLaneBehavior(10) for 20 seconds
    interrupt when 3 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 5 * STEPS_PER_SEC:
        take SetSteerAction(-0.7)

behavior FollowFast():
    do FollowLaneBehavior(30) for 20 seconds

ego = new Car at -262.11 @ -425.37, with behavior EgoBehavior()

# Car slightly offset ahead
drifter = new Car at -250.50 @ -428.30, with behavior DriftIntoLane()

# Rear follower adds pressure
rearcar = new Car at -273.00 @ -425.30, with behavior FollowFast()

print('Ego:', network.laneAt(ego))
print('Drifter:', network.laneAt(drifter))