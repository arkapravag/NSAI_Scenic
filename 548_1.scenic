# Collision-seeking variant
# EgoBehavior is intentionally untouched

param map = localPath('maps/Town04.xodr')
model scenic.domains.driving.model

# CONSTANTS
STEPS_PER_SEC = 10

behavior EgoBehavior():
    do DriveAvoidingCollisions(target_speed=12, avoidance_threshold=12)

# A car stopped almost immediately in the ego lane
behavior LaneBlocker():
    do FollowLaneBehavior(0) for 20 seconds

# A side vehicle that quickly cuts into the ego's lane
behavior SideCutIn():
    try:
        do FollowLaneBehavior(25) for 20 seconds
    interrupt when 0.6 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 2.0 * STEPS_PER_SEC:
        take SetSteerAction(-0.9)

# A rear vehicle that keeps pressure from behind
behavior RearPressure():
    do FollowLaneBehavior(40) for 20 seconds

# Another nearby vehicle to reduce escape room
behavior ShoulderBlock():
    do FollowLaneBehavior(5) for 20 seconds

# --- Ego unchanged ---
ego = new Car at -262.11 @ -425.37, with behavior EgoBehavior()

# --- Trap setup around ego ---
# Blocker placed very close ahead in roughly the same lane
front_blocker = new Car at -257.40 @ -425.45, with behavior LaneBlocker()

# Side car starts next to ego and cuts inward
side_cutter = new Car at -261.80 @ -428.30, with behavior SideCutIn()

# Fast car from behind in ego lane
rear_pusher = new Car at -271.50 @ -425.20, with behavior RearPressure()

# Extra nearby vehicle on the adjacent side to reduce space for avoidance
side_block = new Car at -255.80 @ -428.55, with behavior ShoulderBlock()

print('Ego:', network.laneAt(ego))
print('Front blocker:', network.laneAt(front_blocker))
print('Rear pusher:', network.laneAt(rear_pusher))
print('Side cutter:', network.laneAt(side_cutter))