# CS 685 Standardized Project

## Team

- Saad Muhammad Abdul Ghani
- Archange Giscard Destiné
- Brendan Castle

## Usage

### Build Singularity image

```shell
sudo singularity build --notest nav_competition_image.sif Singularityfile.def
```

### Run Singularity container

```shell
./singularity_run.sh nav_competition_image.sif python3 run.py --world_idx 0
```

## Scripts

`ros_install.sh` installs ROS Noetic on an Ubuntu 20.04 machine

`jackal_setup.sh` installs and configures the BARN navigation challenge using a simulation of the Jackal robot

An Ansible playbook to perform the installation is also provided