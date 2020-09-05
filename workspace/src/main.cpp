#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>

int main() {
  std::string image_path = cv::samples::findFile("HappyFish.jpg");
  cv::Mat img = cv::imread(image_path, cv::IMREAD_COLOR);
  if(img.empty()) {
    std::cerr << "Could not read the image: " << image_path << std::endl;
    return -1;
  }
  cv::imshow("Display window", img);
  auto k = static_cast<char>(cv::waitKey(0));  // Wait for a keystroke in the window
  if ('s' == k) {
    cv::imwrite("HappyFish.jpg", img);
  }
  return 0;
}

