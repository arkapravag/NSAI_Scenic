param map = localPath('maps/Town04.xodr')
model scenic.domains.driving.model

STEPS_PER_SEC = 10

behavior EgoBehavior():
    do DriveAvoidingCollisions(target_speed=12, avoidance_threshold=12)

behavior BarelyMoving():
    do FollowLaneBehavior(1) for 20 seconds

behavior NudgeLeft():
    try:
        do FollowLaneBehavior(10) for 20 seconds
    interrupt when 2 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 4 * STEPS_PER_SEC:
        take SetSteerAction(-0.5)

behavior NudgeRight():
    try:
        do FollowLaneBehavior(10) for 20 seconds
    interrupt when 2 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 4 * STEPS_PER_SEC:
        take SetSteerAction(0.5)

ego = new Car at -262.11 @ -425.37, with behavior EgoBehavior()

front1 = new Car at -255.80 @ -425.35, with behavior BarelyMoving()
front2 = new Car at -254.20 @ -428.10, with behavior BarelyMoving()
side1 = new Car at -262.00 @ -428.20, with behavior NudgeLeft()
rear1 = new Car at -269.50 @ -425.30, with behavior BarelyMoving()
rear2 = new Car at -268.20 @ -428.25, with behavior NudgeRight()

print('Ego:', network.laneAt(ego))