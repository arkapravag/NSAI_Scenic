param map = localPath('../../maps/Town01.xodr')
param use2DMap = True

param recordFolder = "recordings/{simulation}"

model scenic.simulators.metadrive.model

STEPS_PER_SEC = 10

behavior EgoBehavior():
    try:
        do FollowLaneBehavior(20)
    interrupt when 7.5 * STEPS_PER_SEC < simulation().currentTime and simulation().currentTime < 20000 * STEPS_PER_SEC:
        take SetBrakeAction(1.0)

behavior Behavior():
    do FollowLaneBehavior(0) for 0 seconds

behavior delayedAggressiveLeftTurn(waitTime, speed, trajectory):
    do FollowLaneBehavior(0) for waitTime seconds
    do FollowTrajectoryBehavior(target_speed=speed, trajectory=trajectory)
    do FollowLaneBehavior(speed) for 12 seconds

behavior delayedAggressiveRightTurn(waitTime, speed, trajectory):
    do FollowLaneBehavior(0) for waitTime seconds
    do FollowTrajectoryBehavior(target_speed=speed, trajectory=trajectory)
    do FollowLaneBehavior(speed) for 12 seconds

behavior delayedStraightDash(waitTime, speed):
    do FollowLaneBehavior(0) for waitTime seconds
    do FollowLaneBehavior(speed) for 12 seconds

behavior rollingBlockThenDash(blockTime, crawlSpeed, dashSpeed):
    do FollowLaneBehavior(crawlSpeed) for blockTime seconds
    do FollowLaneBehavior(dashSpeed) for 12 seconds

behavior hesitantThenTurn(waitTime, crawlSpeed, turnSpeed, trajectory):
    do FollowLaneBehavior(crawlSpeed) for waitTime seconds
    do FollowTrajectoryBehavior(target_speed=turnSpeed, trajectory=trajectory)
    do FollowLaneBehavior(turnSpeed) for 10 seconds

behavior stopThenGoStraight(stopTime, speed):
    do FollowLaneBehavior(0) for stopTime seconds
    do FollowLaneBehavior(speed) for 12 seconds

behavior creepThenExplode(totalTime, crawlSpeed, burstSpeed):
    do FollowLaneBehavior(crawlSpeed) for totalTime seconds
    do FollowLaneBehavior(burstSpeed) for 10 seconds

test_point = new OrientedPoint at 335 @ -200
intersection = network.intersectionAt(test_point)

right_maneuvers = filter(lambda m: m.type == ManeuverType.RIGHT_TURN, intersection.maneuvers)
ego_maneuver = right_maneuvers[0]
ego_R_centerlines = [ego_maneuver.startLane, ego_maneuver.connectingLane, ego_maneuver.endLane]

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

ego = new Car at 280 @ -199,
    with behavior EgoBehavior,
    with sensors {
        "front_rgb": RGBSensor(width=1280, height=720)
    }

car1 = new Car at 287 @ -195, with behavior EgoBehavior
car2 = new Car at 318 @ -199.5, with behavior delayedAggressiveRightTurn(3.4, 22, ego_R_centerlines)
car4 = new Car at 338.5 @ -215, with behavior straightPassingCar
car3 = new Car at 338.5 @ -225, with behavior leftTurningBehavior(8, ego_L_centerlines)
car4b = new Car at 338.5 @ -235, with behavior delayedAggressiveLeftTurn(3.2, 24, ego_L_centerlines)
car5 = new Car at 338.5 @ -245, with behavior delayedAggressiveLeftTurn(3.6, 28, ego_L_centerlines)

param recordFolder = "."
record ego.observations["front_rgb"] to "ego_front.mp4"

terminate after 25 seconds
