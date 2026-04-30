'''

A parked car abruptly pulls up into the road

scenic special_scenarios/2.scenic --2d --model scenic.simulators.carla.model --simulate

'''

param map = localPath('../assets/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
param time_step = 1.0/10

model scenic.domains.driving.model

behavior PullIntoRoad():
    while (distance from self to ego) > 15:
        wait
    do FollowLaneBehavior(target_speed=4, laneToFollow=ego.lane)


ego = new Car at 193.95 @ -19.3, with blueprint "vehicle.audi.tt", with behavior DriveAvoidingCollisions(target_speed=2, avoidance_threshold=5)



parkedCar = new Car at 185.41 @ -52.12,
                with behavior PullIntoRoad


terminate after 30 seconds
