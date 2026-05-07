param map = localPath('../../maps/Town05.xodr')
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

behavior noLaneRightTurn():
    try:
        do FollowLaneBehavior(20)

    interrupt when 3 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 5 * STEPS_PER_SEC:
        take SetSteerAction(0.5)

    interrupt when 5 * STEPS_PER_SEC < simulation().currentTime:
        take SetThrottleAction(0)
        take SetBrakeAction(1)

# Crash-oriented helper behaviors. These only alter non-ego vehicles.
behavior aggressiveLeftTurn(trajectory):
    do FollowLaneBehavior(8) for 0.5 seconds
    do FollowTrajectoryBehavior(target_speed=38, trajectory=trajectory)
    do FollowLaneBehavior(30) for 8 seconds

behavior delayedLeftTurnCut(trajectory):
    do FollowLaneBehavior(0) for 4.5 seconds
    do FollowTrajectoryBehavior(target_speed=34, trajectory=trajectory)
    do FollowLaneBehavior(25) for 8 seconds

behavior intersectionBlocker():
    do FollowLaneBehavior(10) for 3.5 seconds
    take SetThrottleAction(0)
    take SetBrakeAction(1)
    wait

behavior suddenSprintStraight():
    do FollowLaneBehavior(0) for 4.5 seconds
    do FollowLaneBehavior(45) for 6 seconds
    do FollowLaneBehavior(20) for 8 seconds

behavior hardBrakeInFront():
    do FollowLaneBehavior(20) for 2.5 seconds
    take SetThrottleAction(0)
    take SetBrakeAction(1)
    wait

behavior fastApproachFromBehind():
    do FollowLaneBehavior(0) for 3.5 seconds
    do FollowLaneBehavior(65) for 8 seconds

behavior stagedLaneChangeAttack():
    do FollowLaneBehavior(18) for 3.5 seconds
    current_laneSection = network.laneSectionAt(self)
    rightLaneSec = current_laneSection._laneToRight
    do LaneChangeBehavior(rightLaneSec, False, 2)
    do FollowLaneBehavior(35) for 6 seconds

behavior rollingRoadblock():
    do FollowLaneBehavior(6) for 20 seconds

behavior steerAcrossLaneLeft():
    try:
        do FollowLaneBehavior(15)
    interrupt when 3 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 6 * STEPS_PER_SEC:
        take SetSteerAction(-0.45)
        take SetThrottleAction(0.7)
    interrupt when 6 * STEPS_PER_SEC < simulation().currentTime:
        take SetBrakeAction(1)

behavior steerAcrossLaneRight():
    try:
        do FollowLaneBehavior(15)
    interrupt when 3 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 6 * STEPS_PER_SEC:
        take SetSteerAction(0.45)
        take SetThrottleAction(0.7)
    interrupt when 6 * STEPS_PER_SEC < simulation().currentTime:
        take SetBrakeAction(1)

behavior hesitantThenGo():
    do FollowLaneBehavior(0) for 6 seconds
    do FollowLaneBehavior(35) for 6 seconds

# Variant: c4_v4_multi_vehicle_box_in
# Modified vehicles: car1->aggressiveLeftTurn(L_centerlines), car2->hesitantThenGo(), car3->intersectionBlocker(), car6->fastApproachFromBehind(), car9->stagedLaneChangeAttack(), car12->rollingRoadblock()

ego = new Car at -124 @ -16.6, with behavior EgoBehavior(), with sensors {
        "front_rgb": RGBSensor(offset=(0.3, 0, 1.7), width=1280, height=720)
    }
car1 = new Car at -128.5 @ 16, with behavior aggressiveLeftTurn(L_centerlines)
car2 = new Car at -128.5 @ 27, with behavior hesitantThenGo()
car3 = new Car at -132 @ 16, with behavior intersectionBlocker()
car4 = new Car at -132 @ 26, with behavior onComingStraight()
car5 = new Car at -128 @ 36, with behavior onComingStraight()
car6 = new Car at -121 @ -25, with behavior fastApproachFromBehind()
car7 = new Car at -128.5 @ 51, with behavior onComingStraight()
car8 = new Car at -128.5 @ 71, with behavior onComingStraight()
car9 = new Car at -128.5 @ 91, with behavior stagedLaneChangeAttack()
car10 = new Car at -128.5 @ 111, with behavior onComingStraight()
car11 = new Car at -132 @ 41, with behavior noLaneRightTurn()
car12 = new Car at -132 @ 61, with behavior rollingRoadblock()
car13 = new Car at -132 @ 81, with behavior onComingStraight()
car14 = new Car at -132 @ 111, with behavior onComingStraight()

terminate after 20 seconds
