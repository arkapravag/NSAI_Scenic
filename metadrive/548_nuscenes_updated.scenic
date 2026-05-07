# Done

param map = localPath('../maps/Town04.xodr')
model scenic.domains.driving.model

param recordFolder = "recordings/{simulation}"


# CONSTANTS
STEPS_PER_SEC = 10

behavior EgoBehavior():
    # do DriveAvoidingCollisions(target_speed=12, avoidance_threshold=12)    # do FollowLaneBehavior(12) for 7 seconds
    do FollowLaneBehavior(30) for 20 seconds
    current_lane = network.laneAt(self)
    initLaneSec = Uniform(*laneSecsWithLeftLane)
    RightLaneSec = current_lane.laneToLRight
    do LaneChangeBehavior(laneSectionToSwitch=RightLaneSec, is_oppositeTraffic=False, target_speed=5) for 2 seconds

    do FollowLaneBehavior(50) for 10 seconds
    do FollowLaneBehavior(5) for 8 seconds

behavior EgoSideBehavior():
    do FollowLaneBehavior(50) for 3 seconds
    do FollowLaneBehavior(0) for 5 seconds

behavior otherCarsBehavior():
    do FollowLaneBehavior(0) for 3 seconds
    do FollowLaneBehavior(100) for 20 seconds

behavior otherCarsBehavior2():
    try:
        do FollowLaneBehavior(0) for 4 seconds
        do FollowLaneBehavior(20) for 9 seconds
    # interrupt when 8 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 9 * STEPS_PER_SEC:
    #     take SetBrakeAction(1)
    interrupt when 9 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 11 * STEPS_PER_SEC:
        take SetSteerAction(0.5)

behavior otherCarsBehavior2Faulty():
    try:
        do FollowLaneBehavior(0) for 4 seconds
        do FollowLaneBehavior(5) for 9 seconds
    # interrupt when 8 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 9 * STEPS_PER_SEC:
    #     take SetBrakeAction(1)
    interrupt when 9 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 11 * STEPS_PER_SEC:
        take SetSteerAction(-0.5)

    # interrupt when 11 * STEPS_PER_SEC < simulation().currentTime:
    #     take SetThrottleAction(0)
    #     take SetBrakeAction(1)

ego = new Car at -262.11 @ -425.37, with behavior EgoBehavior(),
    with sensors {
        "front_rgb": RGBSensor(offset=(0.3, 0, 1.7), width=1280, height=720)
    }
car2 = new Car at -197.14 @ -428.11, with behavior otherCarsBehavior2Faulty()
car3 = new Car at -191.35 @ -428.69, with behavior otherCarsBehavior2()
car4 = new Car at -185.67 @ -431.40, with behavior otherCarsBehavior()
car5 = new Car at -195.21 @ -432.27, with behavior otherCarsBehavior2()
car6 = new Car at -204.83 @ -431.29, with behavior otherCarsBehavior2()
ego_side = new Car at -262.11 @ -428.37, with behavior EgoSideBehavior()

print('Ego:', network.laneAt(ego))

record ego.observations["front_rgb"] to "ego_front.mp4"

terminate after 20 seconds
