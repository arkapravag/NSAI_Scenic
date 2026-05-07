# Corrected Scenic syntax: avoid combining multiple priority-1 position specifiers
# such as `behind ego by 24, offset by 3 @ 0`.
# Instead, use a single placement specifier like:
#   offset along ego.orientation by X @ Y

param map = localPath('../../maps/Town01.xodr')
model scenic.domains.driving.model

PARKED_CAR_OFFSET = 1
PEDESTRIAN_OFFSET = 3
EGO_TO_PARKED_CAR_MIN_DIST = 0

behavior EgoBehavior():
    do DriveAvoidingCollisions(target_speed=20, avoidance_threshold=10)

behavior StandStill():
    take SetWalkingSpeedAction(0)

behavior WalkForward():
    take SetWalkingSpeedAction(10)

behavior CrossStreet():
    do StandStill() for 3 seconds
    do WalkForward() for 4 seconds
    do StandStill() for 2 seconds
    do WalkForward() for 1 seconds

behavior Cruise(speed):
    do FollowLaneBehavior(speed)

behavior DelayedLaunch(waitTime, speed):
    do FollowLaneBehavior(0) for waitTime seconds
    do FollowLaneBehavior(speed)

behavior SuddenBrake(cruiseTime, speed):
    do FollowLaneBehavior(speed) for cruiseTime seconds
    do FollowLaneBehavior(0)

behavior RollingBlock(slowSpeed):
    do FollowLaneBehavior(slowSpeed)

ego = new Car,
    with sensors {
        "front_rgb": RGBSensor(offset=(0.3, 0, 1.7), width=1280, height=720)
    },
    with behavior EgoBehavior()

rightCurb = ego.laneGroup.curb
spot = new OrientedPoint on visible rightCurb

parkedCar = new Car right of spot by PARKED_CAR_OFFSET,
    with regionContainedIn None

require distance from ego to parkedCar > EGO_TO_PARKED_CAR_MIN_DIST

pedestrian = new Pedestrian ahead of parkedCar by PEDESTRIAN_OFFSET,
    facing 90 deg relative to parkedCar,
    with behavior CrossStreet()

parkedCar.behavior = DelayedLaunch(1.0, 16)

leadCar = new Car offset along ego.orientation by 0 @ 24,
    with behavior SuddenBrake(1.8, 16)


record ego.observations["front_rgb"] to "ego_front.mp4"

terminate after 20 seconds
