# Livox driver (Docker)

## Start / stop

From the directory that contains `docker-compose.yml`:

```bash
docker compose -f docker-compose.yml up -d
docker logs -f livox_driver
```

Stop:

```bash
docker compose -f docker-compose.yml down
```

## What to check

- **Logs:** `docker logs -f livox_driver` - compare to **Expected startup logs** below.
- **ROS:** `ros2 topic info /livox/lidar` and `ros2 topic hz /livox/lidar` to confirm data is publishing.

### Expected startup logs (for cross-check)

Example from a healthy run (hostname, log path, timestamps, build time, and LiDAR IP in the log will differ on your machine):

```text
[livox] Sourcing ROS 2...
[livox] Building workspace...
Starting >>> livox_ros_driver2
Finished <<< livox_ros_driver2 [3.53s]

Summary: 1 package finished [3.64s]
[livox] Sourcing workspace overlay...
[livox] Launching livox driver...
[INFO] [launch]: All log files can be found below /root/.ros/log/2026-04-01-08-23-09-328844-companion-NUC14SRK-1
[INFO] [launch]: Default logging verbosity is set to INFO
[INFO] [livox_ros_driver2_node-1]: process started with pid [248]
[livox_ros_driver2_node-1] [INFO] [1775031789.372835535] [livox_lidar_publisher]: Livox Ros Driver2 Version: 1.2.4
[livox_ros_driver2_node-1] [INFO] [1775031789.373326500] [livox_lidar_publisher]: Data Source is raw lidar.
[livox_ros_driver2_node-1] [INFO] [1775031789.373355306] [livox_lidar_publisher]: Config file : /root/ros2_ws/install/livox_ros_driver2/share/livox_ros_driver2/launch/../config/pcl_HAP_config.json
[livox_ros_driver2_node-1] LdsLidar *GetInstance
[livox_ros_driver2_node-1] config lidar type: 8
[livox_ros_driver2_node-1] successfully parse base config, counts: 1
[livox_ros_driver2_node-1] [INFO] [1775031789.375294122] [livox_lidar_publisher]: Init lds lidar success!
[livox_ros_driver2_node-1] GetFreeIndex key:livox_lidar_1677830336.
[livox_ros_driver2_node-1] Init queue, real query size:16.
[livox_ros_driver2_node-1] Lidar[0] storage queue size: 10
[livox_ros_driver2_node-1] set pcl data type, handle: 1677830336, data type: 0
[livox_ros_driver2_node-1] set scan pattern, handle: 1677830336, scan pattern: 0
[livox_ros_driver2_node-1] begin to change work mode to 'Normal', handle: 1677830336
[livox_ros_driver2_node-1] successfully set data type, handle: 1677830336, set_bit: 2
[livox_ros_driver2_node-1] successfully set pattern mode, handle: 1677830336, set_bit: 0
[livox_ros_driver2_node-1] successfully set lidar attitude, ip: 192.168.1.100
[livox_ros_driver2_node-1] successfully change work mode, handle: 1677830336
[livox_ros_driver2_node-1] successfully enable Livox Lidar imu, ip: 192.168.1.100
[livox_ros_driver2_node-1] [INFO] [1775031792.375576374] [livox_lidar_publisher]: livox/imu publish use imu format
[livox_ros_driver2_node-1] [INFO] [1775031792.380272097] [livox_lidar_publisher]: livox/lidar publish use PointCloud2 format
```

If logs stop soon after **`GetFreeIndex`** and you never see **`livox/lidar publish use PointCloud2 format`**, check **LiDAR reachability**, **cable/switch**, **`lidar_configs` IP**, and **`host_net_info`** on this machine.

## After you change code or config

The repo is mounted into the container, and **`start_livox.sh` runs `colcon build` on each start**, then launches the driver.

So after you edit **source or JSON under this repo** on the machine, restart the stack so that runs again:

```bash
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml up -d
docker logs -f livox_driver
```

If you changed **`Dockerfile`** or **`docker-compose.yml`**, rebuild the image:

```bash
docker compose -f docker-compose.yml up -d --build
```

## Config

Edit the JSON on this machine (for HAP + PointCloud2 launch: `config/pcl_HAP_config.json` at the **package root**, i.e. one level above `docker/`), then do the steps above.

Set **`host_net_info`** **`cmd_data_ip`**, **`point_data_ip`**, and **`imu_data_ip`** to **this machine’s IP** on the LiDAR network (same value for all three is normal). Set **`lidar_configs`** **`ip`** to the LiDAR’s IP.
