param map = localPath('../assets/maps/CARLA/Town01.xodr')
model scenic.domains.driving.model

STEPS_PER_SEC = 10

behavior EgoBehavior():
    try: 
        do FollowLaneBehavior(20)
    interrupt when 5 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 200 * STEPS_PER_SEC:
        take SetBrakeAction(1.0)    
        # do FollowLaneBehavior(0) for 2 seconds

behavior Behavior():
    do FollowLaneBehavior(0) for 0 seconds

test_point = new OrientedPoint at 335 @ -200
intersection = network.intersectionAt(test_point)
right_maneuvers = filter(lambda m: m.type == ManeuverType.RIGHT_TURN, intersection.maneuvers)
ego_maneuver = right_maneuvers[0]
ego_R_centerlines = [ego_maneuver.startLane, ego_maneuver.connectingLane, ego_maneuver.endLane]
# egoStart = new OrientedPoint at ego_maneuver.startLane.centerline[1]
    
behavior rightTurnBehavior(speed, trajectory):
    do FollowLaneBehavior(5) for 1 seconds
    do FollowTrajectoryBehavior(target_speed=speed, trajectory=trajectory)
    do FollowLaneBehavior(10) for 20 seconds

behavior straightPassingCar():
    do FollowLaneBehavior(10) for 10 seconds

left_maneuvers = filter(lambda m: m.type == ManeuverType.LEFT_TURN, intersection.maneuvers)
ego_maneuver = left_maneuvers[0]
ego_L_centerlines = [ego_maneuver.startLane, ego_maneuver.connectingLane, ego_maneuver.endLane]

behavior leftTurningBehavior(speed, trajectory):
    do FollowLaneBehavior(150) for 1 seconds
    do FollowTrajectoryBehavior(target_speed=speed, trajectory=trajectory)
    do FollowLaneBehavior(150) for 20 seconds


ego = new Car at 280 @ -199, with behavior EgoBehavior
car1 = new Car at 287 @ -195, with behavior EgoBehavior
car2 = new Car at 318 @ -199.5, with behavior rightTurnBehavior(4,ego_R_centerlines) # takes a right from the ego car's lane
# car3 = new Car at 338.7 @ -178, with behavior straightPassingCar
car4 = new Car at  338.5 @ -215, with behavior straightPassingCar
car3 = new Car at 338.5 @ -225, with behavior leftTurningBehavior(8,ego_L_centerlines)
car4 = new Car at  338.5 @ -235, with behavior leftTurningBehavior(8,ego_L_centerlines)
car5 = new Car at 338.5 @ -245, with behavior leftTurningBehavior(8,ego_L_centerlines)
# car6 = New Car at  @ , with behavior
