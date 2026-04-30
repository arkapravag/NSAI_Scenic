param map = localPath('maps/Town05.xodr')
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
    do DriveAvoidingCollisions(target_speed=12, avoidance_threshold=10)

behavior stoppedBlocker():
    do FollowLaneBehavior(0) for 20 seconds

behavior rearEndAttack():
    do FollowLaneBehavior(70) for 8 seconds
    do FollowLaneBehavior(80) for 8 seconds

behavior aggressiveCrossTraffic():
    do FollowLaneBehavior(40) for 2 seconds
    do FollowTrajectoryBehavior(target_speed=45, trajectory=L_centerlines)
    do FollowLaneBehavior(40) for 10 seconds

behavior onComingStraightFast():
    do FollowLaneBehavior(35) for 20 seconds

behavior carBesideEgoBehavior():
    do FollowLaneBehavior(0) for 2 seconds
    do FollowLaneBehavior(60) for 10 seconds

behavior changeLane():
    do FollowLaneBehavior(30) for 3 seconds
    current_laneSection = network.laneSectionAt(self)
    rightLaneSec = current_laneSection._laneToRight
    do LaneChangeBehavior(rightLaneSec, False, 8)
    do FollowLaneBehavior(35) for 5 seconds

behavior noLaneRightTurn():
    try:
        do FollowLaneBehavior(35)

    interrupt when 2 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 4 * STEPS_PER_SEC:
        take SetSteerAction(0.7)

    interrupt when 4 * STEPS_PER_SEC < simulation().currentTime:
        take SetThrottleAction(1.0)

ego = new Car at -124 @ -16.6, with behavior EgoBehavior()

# 1. Block the ego’s lane shortly ahead so it must react abruptly.
blocker = new Car at -124 @ -6.5, with behavior stoppedBlocker()

# 2. Fast car behind ego to rear-end it if ego brakes for the blocker.
rearChaser = new Car at -124 @ -38, with behavior rearEndAttack()

# 3. Car beside ego accelerates into conflict region.
carBeside = new Car at -121 @ -25, with behavior carBesideEgoBehavior()

# 4. Cross-traffic entering the same intersection area aggressively.
cross1 = new Car at -128.5 @ 16, with behavior aggressiveCrossTraffic()
cross2 = new Car at -128.5 @ 27, with behavior aggressiveCrossTraffic()

# 5. Faster oncoming traffic to create dense conflict at the junction.
car3 = new Car at -132 @ 16, with behavior onComingStraightFast()
car4 = new Car at -132 @ 26, with behavior onComingStraightFast()
car5 = new Car at -128 @ 36, with behavior onComingStraightFast()

# 6. Additional traffic upstream to create turbulence around the intersection.
car6 = new Car at -128.5 @ 51, with behavior onComingStraightFast()
car7 = new Car at -128.5 @ 71, with behavior onComingStraightFast()
car8 = new Car at -128.5 @ 91, with behavior changeLane()
car9 = new Car at -128.5 @ 111, with behavior onComingStraightFast()

car10 = new Car at -132 @ 41, with behavior noLaneRightTurn()
car11 = new Car at -132 @ 61, with behavior onComingStraightFast()
car12 = new Car at -132 @ 81, with behavior onComingStraightFast()
car13 = new Car at -132 @ 111, with behavior onComingStraightFast()