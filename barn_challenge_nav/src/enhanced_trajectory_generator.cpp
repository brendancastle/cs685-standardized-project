#include <dwa_local_planner/trajectory_generator.h>
#include <pluginlib/class_list_macros.h>
#include <nav_msgs/OccupancyGrid.h>

namespace dwa_local_planner_plugin {

  class EnhancedTrajectoryGenerator : public dwa_local_planner::TrajectoryGenerator {
  public:
    EnhancedTrajectoryGenerator() : dwa_local_planner::TrajectoryGenerator() {}

    void setCostmap(const nav_msgs::OccupancyGrid& costmap) {
      costmap_ = costmap;
    }

    bool generateTrajectory(const Eigen::Vector3f& pos, const Eigen::Vector3f& vel, Eigen::Vector3f& acc,
                            std::vector<Eigen::Vector3f>& traj) override {
      // Original trajectory generation code
      bool success = dwa_local_planner::TrajectoryGenerator::generateTrajectory(pos, vel, acc, traj);

      // Enhanced obstacle avoidance code
      if (success && !traj.empty()) {
        for (auto& point : traj) {
          // Calculate the cost of the trajectory point based on the costmap
          float cost = calculateCost(point);

          // Add a penalty to the cost if the trajectory point is close to an obstacle
          if (cost > 0.0 && cost < max_cost_) {
            float penalty = (max_cost_ - cost) / max_cost_;
            point.z() += penalty * penalty_factor_;
          }
        }
      }

      return success;
    }

  private:
    nav_msgs::OccupancyGrid costmap_;
    float max_cost_ = 100.0;
    float penalty_factor_ = 0.5;

    float calculateCost(const Eigen::Vector3f& point) {
      // Convert the trajectory point to costmap coordinates
      int x = (int)((point.x() - costmap_.info.origin.position.x) / costmap_.info.resolution);
      int y = (int)((point.y() - costmap_.info.origin.position.y) / costmap_.info.resolution);

      // Check if the costmap coordinates are within the bounds of the costmap
      if (x < 0 || x >= costmap_.info.width || y < 0 || y >= costmap_.info.height) {
        return 0.0;
      }

      // Get the cost of the costmap cell at the trajectory point
      int index = y * costmap_.info.width + x;
      int cost = costmap_.data[index];

      // Scale the cost to be between 0 and 1
      return (float)cost / 100.0;
    }
  };

}  // namespace dwa_local_planner_plugin

PLUGINLIB_EXPORT_CLASS(dwa_local_planner_plugin::EnhancedTrajectoryGenerator, dwa_local_planner::TrajectoryGenerator)
