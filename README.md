# NSAI Scenic Scenarios

Scenic scenario programs for generating and testing autonomous-driving situations in road-network simulators. The repository contains intersection scenarios, nuScenes-derived scenarios, simulator-specific variants, and local OpenDRIVE maps.

## Repository Layout

- `*.scenic`: Root-level Scenic scenarios.
- `carla/`: Scenarios intended for CARLA.
- `metadrive/`: MetaDrive scenarios and generated scenario variants grouped by source case.
- `maps/`: Local OpenDRIVE (`.xodr`) and related road-network files for Town maps.
- `recordings/`: Simulation recordings and related output data.

## Requirements

- Python 3
- [Scenic](https://scenic-lang.org/) with the driving domain installed
- A simulator supported by the scenario being run, such as CARLA or MetaDrive

Install Scenic using its official installation instructions. Simulator-specific dependencies should be installed according to the simulator documentation.

## Running a Scenario

From the repository root, run a scenario with the Scenic command-line interface:

```bash
scenic test.scenic
```

The scenario selects its map with `localPath(...)`, so commands should be run from the repository root unless the scenario is adjusted for another working directory. For example:

```bash
scenic metadrive/601_nuscenes_updated.scenic
```

Some scenarios require a simulator to be running or additional simulator-specific options. Refer to the scenario source and the Scenic documentation for the appropriate backend configuration.

## Maps

The repository includes local Town map assets. OpenDRIVE maps use the `.xodr` extension; `.snet` and `.net.xml` files contain related road-network representations. See `maps/README.txt` for the upstream map licensing information.

## Scenario Development

1. Copy an existing scenario that is close to the behavior being tested.
2. Keep map paths relative to the repository structure and use `localPath(...)` for local assets.
3. Run the scenario with the target simulator before adding generated variants or recordings.
4. Keep generated recordings and large simulator outputs separate from scenario source where possible.

## License

The repository includes third-party map and simulator assets. Their licensing terms are documented in the relevant subdirectories, including `maps/README.txt`.