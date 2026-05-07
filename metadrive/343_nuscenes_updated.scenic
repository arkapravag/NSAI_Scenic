param map = localPath('../maps/Town05.xodr')
model scenic.domains.driving.model

STEPS_PER_SEC = 10

pointOnIntersection = new OrientedPoint at -128 @ 0
intersection = network.intersectionAt(pointOnIntersection)
left_maneuvers = filter(lambda m: m.type == ManeuverType.LEFT_TURN, intersection.maneuvers)
L_maneuver = left_maneuvers[2]
L_centerlines = [L_maneuver.startLane, L_maneuver.connectingLane, L_maneuver.endLane]

behavior leftTurnBehavior(speed, trajectory):
    do FollowLaneBehavior(20) for 1 seconds
    do FollowTrajectoryBehavior(target_speed=speed, trajectory=trajectory)
    do FollowLaneBehavior(20) for 20 seconds

behavior EgoBehavior():
    # do DriveAvoidingCollisions(target_speed=12, avoidance_threshold=10)

    do FollowLaneBehavior(0) for 6 seconds
    do FollowLaneBehavior(20) for 10 seconds


behavior carBesideEgoBehavior():
    do FollowLaneBehavior(0) for 5 seconds
    do FollowLaneBehavior(50) for 10 seconds

behavior onComingStraight():
    do FollowLaneBehavior(15) for 20 seconds

behavior changeLane():
    do FollowLaneBehavior(15) for 5 seconds
    current_laneSection = network.laneSectionAt(self)
    rightLaneSec = current_laneSection._laneToRight
    do LaneChangeBehavior(rightLaneSec, False, 3)
    do FollowLaneBehavior(20) for 2 seconds
    # while 2 * STEPS_PER_SEC < simulation().currentTime:
    #     take SetBrakeAction(1.0)

behavior noLaneRightTurn():
    try:
        do FollowLaneBehavior(20)
        
    interrupt when 3 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 5 * STEPS_PER_SEC:
        take SetSteerAction(0.5)

    interrupt when 5 * STEPS_PER_SEC < simulation().currentTime:
        take SetThrottleAction(0)
        take SetBrakeAction(1)

ego = new Car at -124 @ -16.6, with behavior EgoBehavior(),
    with sensors {
        "front_rgb": RGBSensor(offset=(0.3, 0, 1.7), width=1280, height=720)
    }
# car0 = new Car at -129.73 @ -1.03, facing 180 deg relative to ego, with behavior onComingStraight()
car1 = new Car at -128.5 @ 16, with behavior leftTurnBehavior(20, L_centerlines)
car2 = new Car at -128.5 @ 27, with behavior leftTurnBehavior(20, L_centerlines)
car3 = new Car at -132 @ 16, with behavior onComingStraight()
car4 = new Car at -132 @ 26, with behavior onComingStraight()
car5 = new Car at -128 @ 36, with behavior onComingStraight()
car6 = new Car at -121 @ -25, with behavior carBesideEgoBehavior()

car5 = new Car at -128.5 @ 51, with behavior onComingStraight() # right to rightmost incoming lane
car5 = new Car at -128.5 @ 71, with behavior onComingStraight()
car5 = new Car at -128.5 @ 91, with behavior changeLane()
car5 = new Car at -128.5 @ 111, with behavior onComingStraight()

car4 = new Car at -132 @ 41, with behavior noLaneRightTurn()
car4 = new Car at -132 @ 61, with behavior onComingStraight()
car4 = new Car at -132 @ 81, with behavior onComingStraight()
car4 = new Car at -132 @ 111, with behavior onComingStraight()





# car5 = new Car at -128 @ 20, with behavior onComingStraight()
# car6 = new Car at -128 @ 16, with behavior onComingStraight()

record ego.observations["front_rgb"] to "ego_front.mp4"

terminate after 20 seconds
